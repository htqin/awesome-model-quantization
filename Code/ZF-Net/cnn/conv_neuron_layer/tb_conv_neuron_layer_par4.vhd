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
-- tb_conv_neuron.vhd
-- Testbench for Convolutional Neuron Layer
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all; --  Imports the standard textio package.

entity tb_conv_neuron_layer_par4 is
end entity;

architecture test of tb_conv_neuron_layer_par4 is

  constant layer_size       : natural := 96;
  constant layer_size_order : natural := 7;
  constant feature_width    : natural := 8;
  constant weight_width     : natural := 8;
  constant weight_mem_order : natural := 8;
  constant output_width     : natural := 8;
  constant output_shift     : natural := 0;
  constant bias_shift     : natural := 0;
  constant ReLU             : boolean := true;
  
  constant no_feature_planes : natural := 4;
  constant mask_width : natural := 7;
  constant mask_height : natural := 7;
  constant no_weights : natural := no_feature_planes * mask_width * mask_height;
  
  signal clk            : std_logic := '0';
  signal feature_stream : std_logic_vector(4*feature_width-1 downto 0):= (others => '0');
  signal feature_first  : std_logic := '0';
  signal feature_last   : std_logic := '0';
  signal weight_stream  : std_logic_vector(weight_width-1 downto 0):= (others => '0');
  signal weight_id  : std_logic_vector(layer_size_order-1 downto 0):= (others => '0');
  signal weight_first   : std_logic := '0';
  signal weight_last    : std_logic := '0';
  signal output_stream  : std_Logic_vector(4*output_width-1 downto 0) := (others => '0');
  signal output_id  : std_logic_vector(layer_size_order-1 downto 0):= (others => '0');
  signal output_valid   : std_logic := '0';

  component conv_neuron_layer_par4 is
    generic (
      layer_size   : natural;
      layer_size_order : natural;
      feature_width    : natural;
      weight_width     : natural;
      weight_mem_order : natural;
      output_width     : natural;
      output_shift     : natural;
      bias_shift       : natural;
      ReLU             : boolean);
    port (
      clk            : in  std_logic;
      feature_stream : in  std_logic_vector(4*feature_width-1 downto 0);
      feature_first  : in  std_logic;
      feature_last   : in  std_logic;
      weight_stream  : in  std_logic_vector(weight_width-1 downto 0);
      weight_id      : in std_logic_vector(layer_size_order-1 downto 0);
      weight_first   : in  std_logic;
      weight_last    : in  std_logic;
      output_stream  : out std_Logic_vector(4*output_width-1 downto 0);
      output_id      : out std_logic_vector(layer_size_order-1 downto 0);
      output_valid   : out std_logic);
  end component conv_neuron_layer_par4;
  
begin

  clk <= not clk after 2 ns; -- Simulate 250MHz Clock
  
  conv_neuron_1: conv_neuron_layer_par4
    generic map (
      layer_size       => layer_size,
      layer_size_order  => layer_size_order,
      feature_width    => feature_width,
      weight_width     => weight_width,
      weight_mem_order => weight_mem_order,
      output_width     => output_width,
      output_shift     => output_shift,
      bias_shift       => bias_shift,
      ReLU             => ReLU)
    port map (
      clk            => clk,
      feature_stream => feature_stream,
      feature_first  => feature_first,
      feature_last   => feature_last,
      weight_stream  => weight_stream,
      weight_id      => weight_id,
      weight_first   => weight_first,
      weight_last    => weight_last,
      output_stream  => output_stream,
      output_id      => output_id,
      output_valid   => output_valid);



  process
    variable seed1, seed2: positive;
    variable rand: real;
    variable int_rand: integer;
    variable l : line;
  begin
    write (l, string'("Test Bench for Convolutional Neuron"));
    writeline (output, l);
    write (l, string'("Parameters: "));
    writeline (output, l);
    write (l, string'("Feature planes, mask size: "));
    write (l, no_feature_planes);
    write (l, string'(" x "));
    write (l, mask_height);
    write (l, string'(" x "));
    write (l, mask_width);
    write (l, string'(" = "));
    write (l, no_weights);
    write (l, string'(" weights"));
    writeline (output, l);
    write (l, string'("Feature bit_width: "));
    write (l, feature_width);
    writeline (output, l);
    write (l, string'("Weight bit_width: "));
    write (l, weight_width);
    writeline (output, l);
    write (l, string'("Output bit_width: "));
    write (l, output_width);
    writeline (output, l);
    write (l, string'("Output scaling: 2^-"));
    write (l, output_shift);
    writeline (output, l);
    if ReLU then
      write (l, string'("Using ReLU non-linearity"));   
      writeline (output, l);
    end if;


    --
    -- Initialize Neuron with weights
    -- 

    wait for 12 ns;

    for n in 1 to layer_size loop
      write (l, string'("Generating weights, for neuron #"));
      write(l,n);
      writeline (output, l);
      weight_id <= std_Logic_vector(to_unsigned(n,layer_size_order));
      wait until clk = '1';
      wait until clk = '0';
      weight_first <= '1';
      
      UNIFORM(seed1, seed2, rand);
      int_rand := INTEGER(TRUNC(rand*(2.0**weight_width)));
      weight_stream <= std_logic_vector(to_unsigned(int_rand, weight_width));
      -- First weight is the BIAS
      write (l, string'("Bias: "));
      int_rand := to_integer(signed(std_logic_vector(to_unsigned(int_rand, weight_width))));
      write (l, int_rand);
      writeline (output, l);
      wait until clk = '1';
      wait until clk = '0';
      weight_first <= '0';    
      for j in 1 to mask_height loop
        for k in 1 to mask_width loop
          for i in 1 to no_feature_planes loop
            UNIFORM(seed1, seed2, rand);
            int_rand := INTEGER(TRUNC(rand*(2.0**weight_width)));
            weight_stream <= std_logic_vector(to_unsigned(int_rand, weight_width));
            if i=no_feature_planes and j= mask_height and k=mask_width then
              weight_last <= '1';
            end if;
            
            int_rand := to_integer(signed(std_logic_vector(to_unsigned(int_rand, weight_stream'LENGTH))));
            write (l, int_rand);
            write (l, string'(" "));
            wait until clk = '1';
            wait until clk = '0';        
          end loop;
          write (l, string'(" : "));
        end loop;
        writeline (output, l);
      end loop;
      weight_last <= '0';
      wait until clk = '1';
      wait until clk = '0';
    end loop;
    
    --
    -- Throw data at neuron
    --
    for repeats in 1 to 100 loop
      wait until clk = '1';
      wait until clk = '0';
      feature_last <= '0';
      for i in 1 to no_feature_planes/4 loop
        for j in 1 to mask_height loop
          for k in 1 to mask_width loop
            UNIFORM(seed1, seed2, rand);
            int_rand := INTEGER(TRUNC(rand*(2.0**feature_width)));
            feature_stream(feature_width-1 downto 0) <= std_logic_vector(to_unsigned(int_rand, feature_width));
            UNIFORM(seed1, seed2, rand);
            int_rand := INTEGER(TRUNC(rand*(2.0**feature_width)));
            feature_stream(2*feature_width-1 downto feature_width) <= std_logic_vector(to_unsigned(int_rand, feature_width));
            UNIFORM(seed1, seed2, rand);
            int_rand := INTEGER(TRUNC(rand*(2.0**feature_width)));
            feature_stream(3*feature_width-1 downto 2*feature_width) <= std_logic_vector(to_unsigned(int_rand, feature_width));
            UNIFORM(seed1, seed2, rand);
            int_rand := INTEGER(TRUNC(rand*(2.0**feature_width)));
            feature_stream(4*feature_width-1 downto 3*feature_width) <= std_logic_vector(to_unsigned(int_rand, feature_width));
            if i=no_feature_planes/4 and j= mask_height and k=mask_width then
              feature_last <= '1';
            end if;
            if i=1 and j=1 and k=1 then
              feature_first <= '1';
            else
              feature_first <= '0';
            end if;           
            write (l, int_rand);
            write (l, string'(" "));
            wait until clk = '1';
            wait until clk = '0';        
          end loop;
        end loop;     
      end loop;
      writeline (output, l);
      feature_last <= '0';
    end loop;
    wait;
  end process;

  -- Print out neuron outputs
  process(clk)
    variable l : line;
    variable int_output : integer;
  begin
    if rising_edge(clk) then
      if output_valid = '1' then
        write (l, string'("Output("));
        int_output := to_integer(unsigned(output_id));
        write (l, int_output);
        write (l, string'("): "));
        -- Output is unsigned if ReLU used
        if ReLU then
          int_output := to_integer(unsigned(output_stream(output_width-1 downto 0)));
        else
          int_output := to_integer(signed(output_stream(output_width-1 downto 0)));
        end if;     
        write (l, int_output);
        write (l, string'(","));
        -- Output is unsigned if ReLU used
        if ReLU then
          int_output := to_integer(unsigned(output_stream(2*output_width-1 downto output_width)));
        else
          int_output := to_integer(signed(output_stream(2*output_width-1 downto output_width)));
        end if;     
        write (l, int_output);
        write (l, string'(","));
        -- Output is unsigned if ReLU used
        if ReLU then
          int_output := to_integer(unsigned(output_stream(3*output_width-1 downto 2*output_width)));
        else
          int_output := to_integer(signed(output_stream(3*output_width-1 downto 2*output_width)));
        end if;     
        write (l, int_output);
        write (l, string'(","));
        -- Output is unsigned if ReLU used
        if ReLU then
          int_output := to_integer(unsigned(output_stream(4*output_width-1 downto 3*output_width)));
        else
          int_output := to_integer(signed(output_stream(4*output_width-1 downto 3*output_width)));
        end if;     
        write (l, int_output);
        writeline (output, l);
      end if;
    end if;
  end process;
  

  
end test;
