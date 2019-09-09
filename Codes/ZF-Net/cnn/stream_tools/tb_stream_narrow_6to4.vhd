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
-- tb_stream_narrow_6to4.vhd
-- Testbench for 6 to 4 feature stream narrowing for 7x7x3
-- Stream
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all; --  Imports the standard textio package.

entity tb_stream_narrow_6to4 is
end entity;

architecture test of tb_stream_narrow_6to4 is

  component stream_narrow_6to4 is
    generic (
      stream_width        : natural;
      buffer_depth        : natural;
      buffer_accept_space : natural;
      burst_level         : natural);
    port (
      clk              : in  std_logic;
      rst              : in  std_logic;
      stream_in        : in  std_logic_vector(6*stream_width-1 downto 0);
      stream_in_valid  : in  std_logic;
      stream_in_ready  : out std_logic;
      stream_out       : out std_logic_vector(4*stream_width-1 downto 0);
      stream_out_valid : out std_logic;
      stream_out_first : out std_logic;
      stream_out_last  : out std_logic);
  end component stream_narrow_6to4;

  constant stream_width        : natural := 8;
  constant buffer_depth        : natural := 9;
  constant buffer_accept_space : natural := 64;
  constant burst_level         : natural := 26;
  
  signal clk              : std_logic := '0';
  signal rst              : std_logic := '0';
  signal stream_in        : std_logic_vector(6*stream_width-1 downto 0) := (others => '0');
  signal stream_in_valid  : std_logic := '0';
  signal stream_in_ready  : std_logic := '0';
  signal stream_out       : std_logic_vector(4*stream_width-1 downto 0);
  signal stream_out_valid : std_logic;
  signal stream_out_first : std_logic;
  signal stream_out_last  : std_logic;

  
begin

  clk <= not clk after 2 ns; -- Simulate 250MHz Clock
  
  stream_narrow_6to4_1: stream_narrow_6to4
    generic map (
      stream_width        => stream_width,
      buffer_depth        => buffer_depth,
      buffer_accept_space => buffer_accept_space,
      burst_level         => burst_level)
    port map (
      clk              => clk,
      rst              => rst,
      stream_in        => stream_in,
      stream_in_valid  => stream_in_valid,
      stream_in_ready  => stream_in_ready,
      stream_out       => stream_out,
      stream_out_valid => stream_out_valid,
      stream_out_first => stream_out_first,
      stream_out_last  => stream_out_last);


  process
    variable int_in: integer;
    variable l : line;
  begin
    
    --
    -- Initialize Neuron with weights
    -- 

    wait for 12 ns;
    for i in 1 to 10 loop
      int_in := 0;
      stream_in_valid <= '1';
      for j in 1 to 28 loop
        for k in 1 to 6 loop
          stream_in(k*stream_width-1 downto (k-1)*stream_width) <= std_logic_vector(to_unsigned(int_in, stream_width));
          
          write (l, int_in);
          int_in := int_in+1;
          write (l, string'(" "));
        end loop;
        wait until clk = '1';
        wait until clk = '0';                         
        writeline (output, l);
      end loop;
      stream_in_valid <= '0';
      wait for 64 ns;
    end loop;
    wait;
  end process;

-- Print out outputs
  process(clk)
    variable l : line;
    variable int_output : integer;
  begin
    if rising_edge(clk) then
      if stream_out_valid = '1' then
        write (l, string'("Output: "));
        int_output := to_integer(unsigned(stream_out(stream_width-1 downto 0)));
        
        
        write (l, int_output);
        write (l, string'(" "));
        int_output := to_integer(unsigned(stream_out(2*stream_width-1 downto stream_width)));
        
        
        write (l, int_output);
        write (l, string'(" "));
        int_output := to_integer(unsigned(stream_out(3*stream_width-1 downto 2*stream_width)));
        
        
        write (l, int_output);
        write (l, string'(" "));
        int_output := to_integer(unsigned(stream_out(4*stream_width-1 downto 3*stream_width)));
        
        
        write (l, int_output);
        
        write (l, string'(" "));
        if stream_out_first = '1' then
          write (l, string'("First"));
        end if;
        if stream_out_last = '1' then
          write (l, string'("Last"));
        end if;
        
        writeline (output, l);
      end if;
    end if;
  end process;



end test;
