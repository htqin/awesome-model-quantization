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
-- Testbench for Convolutional Neuron
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all; --  Imports the standard textio package.

entity tb_maxpool is
end entity;

architecture test of tb_maxpool is


  constant feature_width         : natural := 8;
  constant no_feature_planes_par : natural := 3;
  constant no_feature_planes_ser : natural := 3;
  constant pool_size             : natural := 4;
  
  signal clk                : std_logic := '0';
  signal rst                : std_logic := '0';
  signal feature_stream     : std_logic_vector(feature_width*no_feature_planes_par-1 downto 0) := (others => '0');
  signal feature_valid      : std_logic := '0';
  signal feature_first      : std_logic := '0';
  signal feature_last       : std_logic := '0';
  signal max_feature_stream : std_logic_vector(feature_width*no_feature_planes_par-1 downto 0) := (others => '0');
  signal max_feature_valid  : std_logic := '0';

  component maxpool is
    generic (
      feature_width         : natural;
      no_feature_planes_par : natural;
      no_feature_planes_ser : natural;
      pool_size             : natural);
    port (
      clk                : in  std_logic;
      rst                : in  std_logic;
      feature_stream     : in  std_logic_vector(feature_width*no_feature_planes_par-1 downto 0);
      feature_valid      : in  std_logic;
      feature_first      : in  std_logic;
      feature_last       : in  std_logic;
      max_feature_stream : out std_logic_vector(feature_width*no_feature_planes_par-1 downto 0);
      max_feature_valid  : out std_logic);
  end component maxpool;
  
begin

  clk <= not clk after 2 ns; -- Simulate 250MHz Clock


  maxpool_1: maxpool
    generic map (
      feature_width         => feature_width,
      no_feature_planes_par => no_feature_planes_par,
      no_feature_planes_ser => no_feature_planes_ser,
      pool_size             => pool_size)
    port map (
      clk                => clk,
      rst                => rst,
      feature_stream     => feature_stream,
      feature_valid      => feature_valid,
      feature_first      => feature_first,
      feature_last       => feature_last,
      max_feature_stream => max_feature_stream,
      max_feature_valid  => max_feature_valid);


  process
    variable seed1, seed2: positive;
    variable rand: real;
    variable int_rand: integer;
    variable l : line;
  begin
 
    wait for 12 ns;
  
    --
    -- Throw data at maxpool
    --
    for repeats in 1 to 100 loop
    wait until clk = '1';
    wait until clk = '0';
    feature_last <= '0';
    feature_valid <= '1';
    for i in 1 to pool_size loop     
      for j in 1 to no_feature_planes_ser loop
        if i=pool_size and j= no_feature_planes_ser then
          feature_last <= '1';
        end if;
        if i=1 and j=1 then
          feature_first <= '1';
          write (l, string'(" F "));
        else
          feature_first <= '0';
        end if; 
        for k in 1 to no_feature_planes_par loop
          UNIFORM(seed1, seed2, rand);
          int_rand := INTEGER(TRUNC(rand*(2.0**feature_width)));
          feature_stream((k-1)*feature_width+feature_width-1 downto (k-1)*feature_width) <= std_logic_vector(to_unsigned(int_rand, feature_width));
          
          
          int_rand := to_integer(unsigned(std_logic_vector(to_unsigned(int_rand, feature_width))));
          write (l, int_rand);
          write (l, string'(" "));
                  
        end loop;
        
        wait until clk = '1';
        wait until clk = '0';
        write (l, string'(":"));
      end loop;
      writeline (output, l);
     
    end loop;
    feature_valid <= '0';
    feature_last <= '0';
    end loop;
    feature_valid <= '0';
    wait;
  end process;

  -- Print out maxpool outputs
  process(clk)
    variable l : line;
    variable int_output : integer;
  begin
    if rising_edge(clk) then
      if max_feature_valid = '1' then        
        
        write (l, string'("Output: "));
        for k in 1 to  no_feature_planes_par loop
          int_output := to_integer(unsigned(max_feature_stream(k*feature_width-1 downto (k-1)*feature_width)));
        
          write (l, int_output);
          write (l, string'(" "));
        end loop;
        writeline (output, l);
      end if;
    end if;
  end process;
  

  
end test;
