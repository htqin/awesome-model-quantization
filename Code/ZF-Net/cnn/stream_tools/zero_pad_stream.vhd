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
-- Module for zero padding streams 
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- synthesis translate_off
--use std.textio.all; --  Imports the standard textio package.
-- synthesis translate_on


entity zero_pad_stream is
  generic (
    stream_width : natural := 8;
    zero_pad_top : natural := 1;
    zero_pad_bottom : natural := 1;
    zero_pad_left : natural := 1;
    zero_pad_right : natural := 1;
    input_height : natural := 224;
    input_width  : natural := 224 
    );   
  port (
    clk : in std_logic;
    rst : in std_logic;
    stream_in : in std_logic_vector(stream_width-1 downto 0);
    stream_in_valid  : in  std_logic;
    stream_in_ready  : out  std_logic;
    stream_out : out  std_logic_vector(stream_width-1 downto 0);
    stream_out_valid : out std_logic;
    stream_out_ready : in std_logic);
end entity;

architecture rtl of zero_pad_stream is

   -- Log2 function that returns log2(x) rounded up
  function bits_reqd(x: natural) return natural is
  begin
    if x<1 then
      return 0;
    elsif x<2 then
      return 1;
    elsif x<4 then
      return 2;
    elsif x<8 then
      return 3;
    elsif x<16 then
      return 4;
    elsif x<32 then
      return 5;
    elsif x<64 then
      return 6;
    elsif x<128 then
      return 7;
    elsif x<256 then
      return 8;
    elsif x<512 then
      return 9;
    elsif x<1024 then
      return 10;
    elsif x<2048 then
      return 11;
    elsif x<4096 then
      return 12;
    elsif x<8192 then
      return 13;
    elsif x<16384 then
      return 14;
    else
      assert false report "Parameter too large for bits_reqd function" severity failure;
      return 64;
    end if;
  end bits_reqd;
  
  constant output_width : natural := input_width + zero_pad_left+zero_pad_right;
  constant output_height : natural := input_height + zero_pad_top + zero_pad_bottom; 

  constant row_bits : natural := bits_reqd(output_height);
  constant col_bits : natural := bits_reqd(output_width);
  
  
  signal row : unsigned(row_bits-1 downto 0) := (others => '0');
  signal col : unsigned(col_bits-1 downto 0) := (others => '0');
  signal op_data : std_logic := '0';
  signal adv : std_logic := '0';
  signal wait_for_data : std_logic := '1';
  
begin

  stream_out_valid <= stream_in_valid when op_data = '1' else ((not wait_for_data) or stream_in_valid);
  stream_out <= stream_in when op_data = '1' else (others => '0');
  
  stream_in_ready <= stream_out_ready when op_data = '1' else '0';

  adv <= (stream_out_ready and stream_in_valid) when op_data = '1' else
         stream_out_ready and ((not wait_for_data) or stream_in_valid);
        
  
  process(clk)
--    variable l : line;
  begin
    if rising_edge(clk) then
      if stream_in_valid = '1' then
        wait_for_data <= '0';
      end if;
      
      if adv = '1' then
         --write (l,string'("Row "));
         --write (l,to_integer(row));
         --write (l,string'("Col "));
         --write (l,to_integer(col));
         --write (l,string'(" "));
         --if stream_in_valid = '1' then
         --  write (l,string'("V"));
         --end if;
         --if op_data = '1' then
         --  write (l,string'("O"));
         --  write (l,to_integer(unsigned(stream_in)));
         --end if;
         --if wait_for_data = '1' then
         --  write (l,string'("W"));
         --end if;
         --writeline(output,l);
        if col = output_width-1 then
          col <= (others => '0');
          if row = output_height-1 then
            row <= (others => '0');
            wait_for_data <= '1';
          else
            row <= row+1;
          end if;
        else
          col <= col+1;
        end if;
        if row >= zero_pad_top and row < input_height+zero_pad_top then
          if col = zero_pad_left-1 then
            op_data <= '1';
          elsif col = input_width+zero_pad_left-1 then
            op_data <= '0';
          end if;
        end if;
      end if;
      if rst = '1' then
        op_data <= '0';
        wait_for_data <= '1';
        row <= (others => '0');
        col <= (others => '0');
      end if;
    end if;
  end process;    

    
 
end architecture;
