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
-- FIFO buffer for narrowing stream widths to single feature 
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

--use std.textio.all; --  Imports the standard textio package.

entity stream_narrow is
  generic (
    stream_width : natural := 8;
    stream_in_multiplier : natural := 3;
    buffer_depth : natural := 9;
    buffer_accept_space : natural := 64;
    burst_level : natural := 1
    );   
  port (
    clk : in std_logic;
    rst : in std_logic;
    stream_in : in std_logic_vector(stream_width*stream_in_multiplier-1 downto 0);
    stream_in_valid  : in  std_logic;
    stream_in_first  : in  std_logic;
    stream_in_last   : in  std_logic;
    stream_in_ready  : out std_logic;
    stream_out : out  std_logic_vector(stream_width-1 downto 0);
    stream_out_valid : out std_logic;
    stream_out_first : out std_logic;
    stream_out_last : out std_logic);
end entity;

architecture rtl of stream_narrow is

  constant buffer_size : natural := natural(2.0**real(buffer_depth));

  type mem_buffer_type is array(0 to buffer_size-1) of std_logic_vector(stream_width*stream_in_multiplier-1 downto 0);

  signal mem : mem_buffer_type := (others => (others => '0'));
  signal first_mem : std_logic_vector(buffer_size-1 downto 0):= (others => '0');
  signal last_mem : std_logic_vector(buffer_size-1 downto 0):=(others => '0');
  
  signal space_free : unsigned(buffer_depth-1 downto 0) := (others => '1');
  signal fifo_level : unsigned(buffer_depth-1 downto 0) := (others => '0');
  signal rd_addr : unsigned(buffer_depth-1 downto 0) := (others => '0');
  signal wr_addr : unsigned(buffer_depth-1 downto 0) := (others => '0');

  signal stream_in_ready_i : std_logic := '0';
  signal fifo_empty : std_logic := '1';

  signal stream_out_select_valid : std_logic_vector(stream_in_multiplier-1 downto 0) := (others => '0');
  signal fifo_out : std_logic_vector(stream_width*stream_in_multiplier-1 downto 0) := (others => '0');

  signal fifo_first_out :  std_logic := '0';
  signal fifo_last_out :  std_logic := '0';

  signal radv,radv_r1,radv_q :  std_logic := '0';
  
  
  signal fifo_sr : std_logic_vector(stream_width*stream_in_multiplier-1 downto 0) := (others => '0');
  signal fifo_first_sr :  std_logic_vector(stream_in_multiplier-1 downto 0) := (others => '0');
  signal fifo_last_sr :  std_logic_vector(stream_in_multiplier-1 downto 0) := (others => '0');
  signal fifo_valid_sr :  std_logic_vector(stream_in_multiplier-1 downto 0) := (others => '0');

  signal radv_req_state : std_logic_vector(stream_in_multiplier-1 downto 0) := (0 => '1', others => '0');

  attribute shreg_extract : string;
  attribute shreg_extract of fifo_sr: signal is "no"; 
  
begin

  stream_in_ready <= stream_in_ready_i;
  
  process(clk)
  begin
    if rising_edge(clk) then
      if space_free >  buffer_accept_space then
        stream_in_ready_i <= '1';
      else
        stream_in_ready_i <= '0';
      end if;

      if stream_in_valid = '1' then
        wr_addr <= wr_addr+1;
        mem(to_integer(wr_addr)) <= stream_in;
        first_mem(to_integer(wr_addr)) <= stream_in_first;
        last_mem(to_integer(wr_addr)) <= stream_in_last;
      end if;

      if stream_in_valid = '1' and radv = '0' then
        space_free <= space_free-1;
        fifo_level <= fifo_level+1;
        fifo_empty <= '0';
      elsif (stream_in_valid = '0') and radv = '1' then
        space_free <= space_free+1;
        fifo_level <= fifo_level-1;
        if fifo_level = 1 then
          fifo_empty <= '1';
        end if;
      end if;

      fifo_out <= mem(to_integer(rd_addr));
      fifo_first_out <=first_mem(to_integer(rd_addr));
      fifo_last_out <=last_mem(to_integer(rd_addr));
      if radv = '1' then
        rd_addr <= rd_addr+1;
      end if;

      if (fifo_first_out = '1' or fifo_last_out = '1') and fifo_level < burst_level then
        radv_q <= '0';
      else
        radv_q <= '1';
      end if;

      radv_r1 <= radv;
      
      if radv = '1' or radv_req_state(0) = '0' then
        radv_req_state <= radv_req_state(stream_in_multiplier-2 downto 0) & radv_req_state(stream_in_multiplier-1);
      end if;

      if radv_r1 = '1' then
        fifo_sr <= fifo_out;
        fifo_first_sr <= (others => '0');
        fifo_first_sr(0) <= fifo_first_out;
        fifo_last_sr <= (others => '0');
        fifo_last_sr(stream_in_multiplier-1) <= fifo_last_out;
        fifo_valid_sr <= (others => '1');
      else
        fifo_sr(stream_width*(stream_in_multiplier-1)-1 downto 0) <= fifo_sr(stream_width*stream_in_multiplier-1 downto stream_width);
        fifo_valid_sr <= "0" & fifo_valid_sr(stream_in_multiplier-1 downto 1);
        fifo_first_sr <= "0" & fifo_first_sr(stream_in_multiplier-1 downto 1);
        fifo_last_sr <= "0" & fifo_last_sr(stream_in_multiplier-1 downto 1);
        
      end if;

      stream_out <= fifo_sr(stream_width-1 downto 0);
      stream_out_valid <= fifo_valid_sr(0);
      stream_out_first <= fifo_first_sr(0);
      stream_out_last <= fifo_last_sr(0);
      
      
      if rst = '1' then
        space_free <= (others => '1');
        fifo_level <= (others => '0');
        rd_addr <= (others => '0');
        wr_addr <= (others => '0');
        radv_req_state <= (0 => '1', others => '0');
        fifo_valid_sr <= (others => '0');
        radv_r1 <= '0';
        fifo_empty <= '1';
      end if;
      
    end if;
  end process;    
  radv <= (not fifo_empty) and radv_req_state(0) and radv_q; 


 --debug_log0: process(clk) is
 --    variable l : line;
 --    variable count : integer := 0;
 -- begin
 --   if rising_edge(clk) then
 --     write (l,count);
 --     count := count+1;
 --     write (l, string'(": "));
 --     write (l,to_integer(unsigned(fifo_valid_sr)));
 --     write (l, string'(" "));
 --     write (l,to_integer(unsigned(fifo_first_sr)));
 --     write (l, string'(" "));
 --     write (l,to_integer(unsigned(fifo_last_sr)));
 --     write (l, string'(" "));
 --     write (l,to_integer(unsigned(wr_addr)));
 --     write (l, string'(" "));
 --     write (l,to_integer(unsigned(rd_addr)));
 --     write (l, string'(" "));
 --      write (l,to_integer(unsigned(space_free)));
 --     write (l, string'(" "));
 --      write (l,to_integer(unsigned(fifo_level)));
 --     write (l, string'(" "));
 --     --for i in 0 to buffer_size-1 loop
 --     --  if (last_mem(i) = '1') then
 --     --    write (l, string'(" L"));
 --     --    write (l, i);
 --     --  end if;
 --     --end loop;
      
 --     writeline(output,l);
         
    
 --   end if;
 -- end process;


  
end architecture;
