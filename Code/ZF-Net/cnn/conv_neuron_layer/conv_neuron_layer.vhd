--Copyright (c) 2017, Alpha Data Parallel Systems Ltd.
--All rights reserved.
--
--Redistribution and use in source and binary forms, with or without
--modification, are permitted provided that the following conditions are met:
--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--    * Neither the name of the Alpha Data Parallel Systems Ltd. nor the
--      names of its contributors may be used to endorse or promote products
--      derived from this software without specific prior written permission.
--
--THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--DISCLAIMED. IN NO EVENT SHALL Alpha Data Parallel Systems Ltd. BE LIABLE FOR ANY
--DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
--ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


--
-- conv_neuron_layer.vhd
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity conv_neuron_layer is
  generic (
    layer_size   : natural := 10;
    layer_size_order : natural := 4;
    feature_width : natural := 8;
    weight_width : natural := 8;
    weight_mem_order : natural := 5;
    output_width : natural := 8;
    output_shift : natural := 0;
    bias_shift : natural := 0;
    ReLU : boolean := true);   
  port (
    clk : in std_logic;
    feature_stream : in std_logic_vector(feature_width-1 downto 0);
    feature_first  : in std_logic;
    feature_last   : in std_logic;
    weight_stream  : in std_logic_vector(weight_width-1 downto 0);
    weight_id      : in std_logic_vector(layer_size_order-1 downto 0);
    weight_first   : in std_logic;
    weight_last    : in std_logic;
    output_stream  : out std_logic_vector(output_width-1 downto 0);
    output_id      : out std_logic_vector(layer_size_order-1 downto 0);
    output_valid   : out std_logic);
end entity;

architecture rtl of conv_neuron_layer is

  -- Create types for shift register chains to fanout and fanin data - at high
  -- clock frequency
  type feature_fanout_type is array (0 to layer_size) of std_logic_vector(feature_width-1 downto 0);  
  type weight_fanout_type is array (0 to layer_size) of std_logic_vector(weight_width-1 downto 0);
  type id_fanout_type is array (0 to layer_size) of std_logic_vector(layer_size_order-1 downto 0);
  type output_fanin_type is array (0 to layer_size) of std_logic_vector(output_width-1 downto 0);

  signal feature_fanout_sr : feature_fanout_type := (others => (others => '0'));
  signal weight_fanout_sr : weight_fanout_type := (others => (others => '0'));
  signal weight_id_fanout_sr : id_fanout_type := (others => (others => '0'));
  signal output_id_fanin_sr : id_fanout_type := (others => (others => '0'));
  signal output_fanin_sr : output_fanin_type := (others => (others => '0'));


  
  signal feature_first_sr : std_logic_vector(layer_size downto 0) := (others => '0');
  signal feature_last_sr : std_logic_vector(layer_size downto 0) := (others => '0');
  signal weight_first_sr : std_logic_vector(layer_size downto 0) := (others => '0');
  signal weight_last_sr : std_logic_vector(layer_size downto 0) := (others => '0');
  signal output_valid_sr : std_logic_vector(layer_size downto 0) := (others => '0');

  signal weight_first_valid : std_logic_vector(layer_size downto 0) := (others => '0');
  signal weight_last_valid : std_logic_vector(layer_size downto 0) := (others => '0');
  
  signal output_valid_sig : std_logic_vector(layer_size downto 0) := (others => '0');
  signal output_sig : output_fanin_type := (others => (others => '0'));


 component conv_neuron is
    generic (
      feature_width    : natural;
      weight_width     : natural;
      weight_mem_order : natural;
      output_width     : natural;
      output_shift     : natural;
      bias_shift : natural;
      ReLU             : boolean);
    port (
      clk            : in  std_logic;
      feature_stream : in  std_logic_vector(feature_width-1 downto 0);
      feature_first  : in  std_logic;
      feature_last   : in  std_logic;
      weight_stream  : in  std_logic_vector(weight_width-1 downto 0);
      weight_first   : in  std_logic;
      weight_last    : in  std_logic;
      output_stream  : out std_Logic_vector(output_width-1 downto 0);
      output_valid   : out std_logic);
  end component conv_neuron;
  
begin

  assert (layer_size_order < weight_mem_order-1) report "Number of neurons must not exceed half number of weights" severity failure;  
  
  -- Shift register to fanout all streams to all neurons in layer
  process(clk)
  begin
    if rising_edge(clk) then
      feature_fanout_sr(0) <= feature_stream;
      feature_first_sr(0) <= feature_first;
      feature_last_sr(0) <= feature_last;
      
      weight_fanout_sr(0) <= weight_stream;
      weight_id_fanout_sr(0) <= weight_id;
      weight_first_sr(0) <= weight_first;
      weight_last_sr(0) <= weight_last;
      
      for i in 1 to layer_size loop
        feature_fanout_sr(i) <= feature_fanout_sr(i-1);
        feature_first_sr(i) <= feature_first_sr(i-1);
        feature_last_sr(i) <= feature_last_sr(i-1);
        weight_fanout_sr(i) <= weight_fanout_sr(i-1);
        weight_first_sr(i) <= weight_first_sr(i-1);
        weight_last_sr(i) <= weight_last_sr(i-1);
        weight_id_fanout_sr(i) <= weight_id_fanout_sr(i-1);

        if unsigned(weight_id_fanout_sr(i-1)) = i then
          weight_first_valid(i) <= weight_first_sr(i-1);
          weight_last_valid(i) <= weight_last_sr(i-1);
        else
          weight_first_valid(i) <= '0';
          weight_last_valid(i) <= '0';
        end if;

        
        if output_valid_sig(i) = '1' then
          output_valid_sr(i-1) <= '1';
          output_fanin_sr(i-1) <= output_sig(i);
          output_id_fanin_sr(i-1) <= std_logic_vector(to_unsigned(i,layer_size_order));
        else
          output_valid_sr(i-1) <= output_valid_sr(i);
          output_fanin_sr(i-1) <= output_fanin_sr(i);
          output_id_fanin_sr(i-1) <= output_id_fanin_sr(i);
        end if;
      end loop;
    end if;
  end process;

  output_valid <= output_valid_sr(0);
  output_id <= output_id_fanin_sr(0);
  output_stream <= output_fanin_sr(0);
  
  gen_neurons: for i in 1 to layer_size generate
     conv_neuron_1: conv_neuron
    generic map (
      feature_width    => feature_width,
      weight_width     => weight_width,
      weight_mem_order => weight_mem_order,
      output_width     => output_width,
      output_shift     => output_shift,
      bias_shift => bias_shift,
      ReLU             => ReLU)
    port map (
      clk            => clk,
      feature_stream => feature_fanout_sr(i),
      feature_first  => feature_first_sr(i),
      feature_last   => feature_last_sr(i),
      weight_stream  => weight_fanout_sr(i),
      weight_first   => weight_first_valid(i),
      weight_last    => weight_last_valid(i),
      output_stream  => output_sig(i),
      output_valid   => output_valid_sig(i));
    
  end generate;


                
  
end architecture;
