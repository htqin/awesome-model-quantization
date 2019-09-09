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
-- tb_feature_buffer.vhd
-- Testbench for CNN Feature Buffer
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all; --  Imports the standard textio package.

entity tb_feature_buffer is
end entity;

architecture test of tb_feature_buffer is

  constant feature_width         : natural := 8;
  constant no_feature_planes_par : natural := 2;
  constant no_feature_planes_ser : natural := 3;
  constant mask_width            : natural := 3;
  constant mask_height           : natural := 3;
  constant feature_plane_width   : natural := 8;
  constant feature_plane_height  : natural := 8;
  constant stride                : natural := 1;
  
  signal clk                 : std_logic := '0';
  signal rst                 : std_logic := '0';
  signal mask_feature_stream : std_logic_vector(feature_width*no_feature_planes_par-1 downto 0) := (others => '0');
  signal mask_feature_valid  : std_logic := '0';
  signal mask_feature_ready  : std_logic := '0';
  signal mask_feature_first  : std_logic := '0';
  signal mask_feature_last   : std_logic := '0';
  
  signal feature_stream : std_logic_vector(feature_width*no_feature_planes_par-1 downto 0):= (others => '0');
  signal feature_ready  : std_logic := '0';
  signal feature_valid  : std_logic := '0';

  component feature_buffer is
    generic (
      feature_width         : natural;
      no_feature_planes_par : natural;
      no_feature_planes_ser : natural;
      mask_width            : natural;
      mask_height           : natural;
      feature_plane_width   : natural;
      feature_plane_height  : natural;
      stride                : natural);
    port (
      clk                 : in  std_logic;
      rst                 : in  std_logic;
      feature_stream      : in  std_logic_vector(feature_width*no_feature_planes_par-1 downto 0);
      feature_valid       : in  std_logic;
      feature_ready       : out std_logic;
      mask_feature_stream : out std_logic_vector(feature_width*no_feature_planes_par-1 downto 0);
      mask_feature_valid  : out std_logic;
      mask_feature_ready  : in  std_logic;
      mask_feature_first  : out std_logic;
      mask_feature_last   : out std_logic);
  end component feature_buffer;
  
begin

  clk <= not clk after 2 ns; -- Simulate 250MHz Clock

  feature_buffer_1: feature_buffer
    generic map (
      feature_width         => feature_width,
      no_feature_planes_par => no_feature_planes_par,
      no_feature_planes_ser => no_feature_planes_ser,
      mask_width            => mask_width,
      mask_height           => mask_height,
      feature_plane_width   => feature_plane_width,
      feature_plane_height  => feature_plane_height,
      stride                => stride)
    port map (
      clk                 => clk,
      rst                 => rst,
      feature_stream      => feature_stream,
      feature_valid       => feature_valid,
      feature_ready       => feature_ready,
      mask_feature_stream => mask_feature_stream,
      mask_feature_valid  => mask_feature_valid,
      mask_feature_ready  => mask_feature_ready,
      mask_feature_first  => mask_feature_first,
      mask_feature_last   => mask_feature_last);
 

  process
    variable seed1, seed2: positive;
    variable rand: real;
    variable int_rand: integer;
    variable l : line;
  begin

   
    wait for 12 ns;
  
    --
    -- Throw data at feature_buffer
    --
    for repeats in 1 to 10 loop
    wait until clk = '1';
    wait until clk = '0';
    feature_valid <= '1';
    
    for j in 1 to feature_plane_height loop
      for k in 1 to feature_plane_width loop
        for i in 1 to no_feature_planes_ser loop
          --UNIFORM(seed1, seed2, rand);
          --int_rand := INTEGER(TRUNC(rand*(2.0**feature_width)));
          int_rand := k+j*10+(i-1)*100;
          feature_stream <= std_logic_vector(to_unsigned(int_rand, feature_width*no_feature_planes_par));
          --write (l, int_rand);
          --write (l, string'(" "));
          wait until clk = '1';
          wait until clk = '0';
          while feature_ready = '0' loop
            wait until clk = '1';
            wait until clk = '0';
          end loop;
        end loop;
      end loop;     
    end loop;
    --writeline (output, l);
    feature_valid <= '0';
    end loop;
    wait;
  end process;

  -- Print out buffer outputs
  process(clk)
    variable l : line;
    variable int_output : integer;
  begin
    if rising_edge(clk) then
      mask_feature_ready <='1';
      if mask_feature_valid = '1' then
        int_output := to_integer(unsigned(mask_feature_stream));      
        
        if mask_feature_first = '1' then
           write (l, string'("F "));
        end if;
        write (l, int_output);
        write (l, string'(" "));
        if mask_feature_last = '1' then
           write (l, string'("L"));
           writeline (output, l);
        end if;
        
       
      end if;
    end if;
  end process;
  

  
end test;
