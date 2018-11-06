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

entity stream_narrow_6to4 is
  generic (
    stream_width : natural := 8;
    buffer_depth : natural := 9;
    buffer_accept_space : natural := 64;
    burst_level : natural := 1
    );
  port (
    clk : in std_logic;
    rst : in std_logic;
    stream_in : in std_logic_vector(6*stream_width-1 downto 0);
    stream_in_valid  : in  std_logic;
    stream_in_ready  : out std_logic;
    stream_out : out  std_logic_vector(4*stream_width-1 downto 0);
    stream_out_valid : out std_logic;
    stream_out_first : out std_logic;
    stream_out_last : out std_logic);
end entity;

architecture rtl of stream_narrow_6to4 is

  constant buffer_size : natural := natural(2.0**real(buffer_depth));

  type mem_buffer_type is array(0 to buffer_size-1) of std_logic_vector(stream_width*6-1 downto 0);

  signal mem : mem_buffer_type := (others => (others => '0'));
  signal first_mem : std_logic_vector(buffer_size-1 downto 0):= (others => '0');
  signal last_mem : std_logic_vector(buffer_size-1 downto 0):=(others => '0');
  
  signal space_free : unsigned(buffer_depth-1 downto 0) := (others => '1');
  signal fifo_level : unsigned(buffer_depth-1 downto 0) := (others => '0');
  signal rd_addr : unsigned(buffer_depth-1 downto 0) := (others => '0');
  signal wr_addr : unsigned(buffer_depth-1 downto 0) := (others => '0');

  signal stream_in_ready_i : std_logic := '0';
  signal fifo_empty : std_logic := '1';

  signal fifo_out : std_logic_vector(stream_width*6-1 downto 0) := (others => '0');

  signal radv,radv_r1,radv_q :  std_logic := '0';
  

  type read_regs_type is array (0 to 12) of std_logic_vector(stream_width-1 downto 0);

  signal read_regs : read_regs_type := (others => (others => '0'));
  type output_fsm_select_type is array(0 to 36) of integer;
  constant radv_fsm_sel : std_logic_vector(0 to 36) := "1110111011101111101101111011101111010";
  constant output0_fsm_sel : output_fsm_select_type := (0,10,8,0,10,8, 9,1,11,9,7, 2,0,10,8,6, 7,11,9,7,11, 0,10,8,6,10,8, 9,7,11,9,7, 8,6,10,8,0);
  constant output1_fsm_sel : output_fsm_select_type := (1,11,9,1,11, 0,10,2,0,10,8, 3,1,11,9,7, 8,0,10,8,0, 1,11,9,7,11, 0,10,8,0,10,8, 9,7,11,9,1);
  constant output2_fsm_sel : output_fsm_select_type := (2,0,10,2,0,  1,11,3,1,11, 0,4,2,0,10,8, 9,1,11,9,1, 2,0,10,8,0,  1,11,9,2,11, 0,10,8,0,10,2);
  constant output3_fsm_sel : output_fsm_select_type := (3,1,11,3,1,  2,0,4,2,0,   1,5,3,1,11, 0,10,2,0,10,2,3,1,11,9,1,  2,0,10,3,0,  1,11,9,1,11,12);
                                                        
  signal op0_sel,op1_sel,op2_sel,op3_sel : unsigned(3 downto 0) := (others => '0');

  signal stream_out_i : std_logic_vector(4*stream_width-1 downto 0) := (others => '0');
  signal stream_out_valid_i : std_logic := '0';
  signal stream_out_first_i : std_logic := '0';
  signal stream_out_last_i : std_logic := '0';

  signal radv_running, radv_running_r1, radv_running_r2, radv_running_r3 : std_logic := '0';
  signal radv_state,radv_state_r1,radv_state_r2 : unsigned(5 downto 0) := (others => '0');
  signal radv_first_r3,radv_last_r3 : std_logic := '0';
  
  
begin

  stream_in_ready <= stream_in_ready_i;
  
  process(clk)
    --variable l : line;
  begin
    if rising_edge(clk) then
      --write(l,to_integer(radv_state_r1)); write (l, string'(":"));
      --write(l,to_integer(op0_sel)); write (l, string'(" "));
      --write(l,to_integer(op1_sel)); write (l, string'(" "));
      --write(l,to_integer(op2_sel)); write (l, string'(" "));
      --write(l,to_integer(op3_sel)); write (l, string'(" "));
     
      --if radv_r1 = '1' then
      --  write (l, string'("R"));
      --end if;
      --writeline(output,l);
      --for i in 0 to 11 loop
      --  write(l,to_integer(unsigned(read_regs(i)))); write (l, string'(" "));
      --end loop;
      --writeline(output,l);
        
      if space_free >  buffer_accept_space then
        stream_in_ready_i <= '1';
      else
        stream_in_ready_i <= '0';
      end if;

      if stream_in_valid = '1' then
        wr_addr <= wr_addr+1;
        mem(to_integer(wr_addr)) <= stream_in;
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
      if radv = '1' then
        rd_addr <= rd_addr+1;
      end if;

      if fifo_level < burst_level then
        radv_q <= '0';
      else
        radv_q <= '1';
      end if;

      if radv_running = '1' then
        if radv_state = 36 then
          radv_state <= to_unsigned(0,6);
          if radv_q = '0' then
            radv_running <= '0';
            radv <= '0';
          else
            radv_running <= '1';
            radv <= '1';
          end if;
        else
          radv_state <= radv_state+1;
          radv <= radv_fsm_sel(to_integer(radv_state));
        end if;
      else
        if radv_q = '1' then
          radv_state <= to_unsigned(0,6);          
          radv_running <= '1';
          radv <= '0';
        end if;
      end if;
      
      radv_r1 <= radv;
      radv_running_r1 <= radv_running;
      radv_running_r2 <= radv_running_r1;
      radv_running_r3 <= radv_running_r2;
      radv_state_r1 <= radv_state;
      radv_state_r2 <= radv_state_r1;  

      if to_integer(radv_state_r2) = 0 and radv_running_r2 = '1' then
        radv_first_r3 <= '1';
      else
        radv_first_r3 <= '0';
      end if;

      if to_integer(radv_state_r2) = 36 then
        radv_last_r3 <= '1';
      else
        radv_last_r3 <= '0';
      end if;
      
      if radv_r1 = '1' then
        for i in 0 to 5 loop
          read_regs(i) <= fifo_out(stream_width*(i+1)-1 downto stream_width*i);
          read_regs(i+6) <= read_regs(i);
        end loop;
      end if;
      read_regs(12) <= (others => '0'); -- Last feature padding
      op0_sel <= to_unsigned(output0_fsm_sel(to_integer(radv_state_r2)),4);
      op1_sel <= to_unsigned(output1_fsm_sel(to_integer(radv_state_r2)),4);
      op2_sel <= to_unsigned(output2_fsm_sel(to_integer(radv_state_r2)),4);
      op3_sel <= to_unsigned(output3_fsm_sel(to_integer(radv_state_r2)),4);
      
      stream_out_i(stream_width-1 downto 0) <= read_regs(to_integer(op0_sel));
      stream_out_i(2*stream_width-1 downto stream_width) <= read_regs(to_integer(op1_sel));
      stream_out_i(3*stream_width-1 downto 2*stream_width) <= read_regs(to_integer(op2_sel));
      stream_out_i(4*stream_width-1 downto 3*stream_width) <= read_regs(to_integer(op3_sel));
      stream_out_valid_i <= radv_running_r3;
      stream_out_first_i <= radv_first_r3;
      stream_out_last_i <= radv_last_r3;

      stream_out <= stream_out_i;
      stream_out_valid <= stream_out_valid_i;
      stream_out_first <= stream_out_first_i;
      stream_out_last <= stream_out_last_i;
      
      if rst = '1' then
        space_free <= (others => '1');
        fifo_level <= (others => '0');
        rd_addr <= (others => '0');
        wr_addr <= (others => '0');     
        radv_running <= '0';
        radv <= '0';
        fifo_empty <= '1';
      end if;
      
    end if;
  end process;    
  



  
end architecture;
