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
-- Module for widening stream widths to multiple parallel features 
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity stream_widen is
  generic (
    stream_width : natural := 8;
    stream_out_multiplier : natural := 3
    );   
  port (
    clk : in std_logic;
    rst : in std_logic;
    stream_in : in std_logic_vector(stream_width-1 downto 0);
    stream_in_valid  : in  std_logic;
    stream_in_first  : in  std_logic;
    stream_in_last   : in  std_logic;
    stream_out : out  std_logic_vector(stream_width*stream_out_multiplier-1 downto 0);
    stream_out_valid : out std_logic;
    stream_out_first : out std_logic;
    stream_out_last : out std_logic);
end entity;

architecture rtl of stream_widen is
  
    signal stream_out_sr :  std_logic_vector(stream_width*stream_out_multiplier-1 downto 0) := (others => '0');
    signal stream_out_valid_sr : std_logic_vector(stream_out_multiplier-1 downto 0) := (0 => '1', others => '0');
    signal stream_out_first_sr : std_logic_vector(stream_out_multiplier-1 downto 0) := (others => '0');
    signal stream_out_last_sr : std_logic_vector(stream_out_multiplier-1 downto 0) := (others => '0');
    signal stream_in_valid_r1 : std_logic := '0';

begin

  process(clk)
  begin
    if rising_edge(clk) then
      if stream_in_valid = '1' then
        stream_out_sr <= stream_in & stream_out_sr(stream_width*stream_out_multiplier-1 downto stream_width);
        if stream_in_first = '1' then
          stream_out_valid_sr <= (others => '0');
          stream_out_valid_sr(stream_out_multiplier-1) <= '1';
        else
          stream_out_valid_sr <= stream_out_valid_sr(0) & stream_out_valid_sr(stream_out_multiplier-1 downto 1);
          
        end if;
        stream_out_first_sr <= stream_in_first & stream_out_first_sr(stream_out_multiplier-1 downto 1);
        stream_out_last_sr <= stream_in_last & stream_out_last_sr(stream_out_multiplier-1 downto 1);
      end if;

      stream_in_valid_r1 <= stream_in_valid;

      if stream_in_valid_r1 = '1' then
        stream_out_valid <= stream_out_valid_sr(0);
        stream_out <= stream_out_sr;
        stream_out_first <= stream_out_first_sr(0);
        stream_out_last <= stream_out_last_sr(stream_out_multiplier-1);         
      else
        stream_out_valid <= '0';
      end if;
      
      if rst = '1' then
        stream_out_valid_sr <= (others => '0');
        stream_out_valid_sr(0) <= '1';
      end if;
      
    end if;
  end process;    

 
end architecture;
