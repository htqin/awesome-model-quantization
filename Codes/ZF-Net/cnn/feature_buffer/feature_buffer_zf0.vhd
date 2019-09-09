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
-- feature_buffer_zf0.vhd
-- FIFO buffer to extract region of interest from tensor 
-- ZFNET Layer 0 optimization added
-- Treates 224x3 lines as 112x6, with horizontal stride divided by 2
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


use std.textio.all; --  Imports the standard textio package.

entity feature_buffer_zf0 is
  generic (
    feature_width : natural := 8;
    no_feature_planes_par : natural := 1;
    no_feature_planes_ser : natural := 3;
    mask_width : natural := 3;
    mask_height : natural := 3;
    feature_plane_width : natural := 224;
    feature_plane_height : natural := 224;
    stride : natural := 1 
   );   
  port (
    clk : in std_logic;
    rst : in std_logic;
    feature_stream : in std_logic_vector(feature_width*no_feature_planes_par-1 downto 0);
    feature_valid  : in  std_logic;
    feature_ready  : out std_logic;
    mask_feature_stream : out std_logic_vector(feature_width*no_feature_planes_par-1 downto 0);
    mask_feature_valid  : out std_logic;
    mask_feature_ready  : in  std_logic;
    mask_feature_first  : out std_logic;
    mask_feature_last   : out std_logic);
end entity;

architecture rtl of feature_buffer_zf0 is

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

  constant feature_plane_width_bits : natural := bits_reqd(feature_plane_width*no_feature_planes_ser);
  constant feature_plane_height_bits: natural := bits_reqd(feature_plane_height);
  constant memory_rows : natural := mask_height+2;
  constant memory_rows_bits : natural := bits_reqd(memory_rows);
  constant mask_height_bits: natural := bits_reqd(mask_height);
  constant mask_width_bits: natural := bits_reqd(mask_width*no_feature_planes_ser);

  
  type memory_row_type is array(0 to feature_plane_width*no_feature_planes_ser-1) of std_logic_vector(feature_width*no_feature_planes_par-1 downto 0);
  type memory_type is array(0 to memory_rows-1) of memory_row_type;
  type mem_out_type is array(0 to memory_rows-1) of std_logic_vector(feature_width*no_feature_planes_par-1 downto 0);

  signal mem : memory_type := (others => (others => (others => '0')));
  signal mem_out : mem_out_type := (others => (others=> '0'));
  signal mem_out_valid : std_Logic_vector(memory_rows-1 downto 0) := (others => '0');
  signal write_col_addr : unsigned(feature_plane_width_bits-1 downto 0) := (others => '0');
  signal write_row_addr : unsigned(feature_plane_height_bits-1 downto 0) := (others => '0');
  signal write_row_mem_addr : unsigned(memory_rows_bits-1 downto 0) := (others => '0');
  signal read_col_addr : unsigned(feature_plane_width_bits-1 downto 0) := (others => '0');
  signal read_row_addr : unsigned(feature_plane_height_bits-1 downto 0) := (others => '0');
  signal read_col_start_addr : unsigned(feature_plane_width_bits-1 downto 0) := (others => '0');
  signal read_row_mem_addr : unsigned(memory_rows_bits-1 downto 0) := (others => '0');
  signal read_row_start_mem_addr : unsigned(memory_rows_bits-1 downto 0) := (others => '0');

  signal mask_col : unsigned(mask_width_bits-1 downto 0) := (others => '0');
  signal mask_row : unsigned(mask_height_bits-1 downto 0) := (others => '0');
  
  signal memory_row_used : std_logic_vector(memory_rows-1 downto 0) := (others => '0');
  signal writer_ready : std_logic := '0';

  signal reader_rows_required : std_logic_vector(mask_height-1 downto 0);

  signal mask_first, mask_first_e1, mask_last : std_logic := '0';
  signal mask_can_start : std_logic := '0';
  signal mask_read_running : std_logic := '0';
  signal mask_read_running_r1 : std_logic := '0';
  signal mask_read_running_r2 : std_logic := '0';
  signal mask_read_running_r3 : std_logic := '0';

  constant ones : std_logic_vector(63 downto 0) := (others => '1');

  attribute ram_style : string;
  attribute ram_style of mem : signal is "block";
  
begin

  feature_ready <= writer_ready;
  
  process(clk)
    variable next_write_row_mem_addr : unsigned(memory_rows_bits-1 downto 0) := (others => '0');
    variable l : line;
  begin
    if rising_edge(clk) then
      
     
      if feature_valid = '1' and writer_ready = '1' then
        if write_col_addr = feature_plane_width*no_feature_planes_ser-1 then
          write_col_addr <= (others => '0');
          memory_row_used(to_integer(write_row_mem_addr))<= '1';
          if write_row_mem_addr = memory_rows-1 then
            next_write_row_mem_addr := (others => '0'); 
          else
            next_write_row_mem_addr := write_row_mem_addr+1;
          end if;
          
          write_row_mem_addr <= next_write_row_mem_addr;
          
        else
          next_write_row_mem_addr := write_row_mem_addr;
          write_col_addr <= write_col_addr+1;
        end if;
      else
        next_write_row_mem_addr := write_row_mem_addr;
      end if;
      writer_ready <= not memory_row_used(to_integer(next_write_row_mem_addr));

      if feature_valid = '1' and writer_ready = '1' then
        for i in 0 to memory_rows-1 loop
          if i = write_row_mem_addr then
            mem(i)(to_integer(write_col_addr)) <= feature_stream;
          end if;
        end loop;
      end if;
      mem_out_valid <= (others => '0');
      for i in 0 to memory_rows-1 loop
        if i = read_row_mem_addr then
          mem_out(i) <= mem(i)(to_integer(read_col_addr));
          mem_out_valid(i) <= '1';
        end if;
      end loop;

      for i in 0 to mask_height-1 loop
        if read_row_start_mem_addr+i < memory_rows then
          reader_rows_required(i) <= memory_row_used(to_integer(read_row_start_mem_addr)+i);
        else
          reader_rows_required(i) <= memory_row_used(to_integer(read_row_start_mem_addr)+i-memory_rows);
        end if;
      end loop;

      if reader_rows_required = ones(mask_height-1 downto 0) and mask_feature_ready = '1' then
        mask_can_start <= '1';
      else
        mask_can_start <= '0';
      end if;

      mask_first_e1 <= '0';
      mask_first <= mask_first_e1;
      mask_last <= '0';
      
      if mask_read_running = '0' then
        -- allow 2 cycle gap between mask reads
        if mask_can_start = '1' and mask_read_running_r3 = '0' then
          read_col_addr <= read_col_start_addr;
          read_row_mem_addr <= read_row_start_mem_addr;
          mask_col <= (others => '0');
          mask_row <= (others => '0');
          mask_first_e1 <= '1';
          mask_read_running <= '1';
        end if;
      else
        if mask_row = mask_height-1 then
          if mask_col = mask_width*no_feature_planes_ser-1 then
            mask_read_running <= '0';
            mask_last <= '1';
          else
            mask_col <= mask_col+1;
            read_col_addr <= read_col_addr +1;
          end if;
        else
          if mask_col = mask_width*no_feature_planes_ser-1 then
            mask_row <= mask_row+1;
            mask_col <= (others => '0');
            if read_row_mem_addr = memory_rows-1 then
              read_row_mem_addr <= (others => '0');
            else
              read_row_mem_addr <= read_row_mem_addr +1;
            end if;
            read_col_addr <= read_col_start_addr;        
          else
            mask_col <= mask_col+1;
            read_col_addr <= read_col_addr +1;
          end if;
        end if;
      end if;

      mask_read_running_r1 <= mask_read_running;
      mask_read_running_r2 <= mask_read_running_r1;
      mask_read_running_r3 <= mask_read_running_r2;

      
      if mask_last = '1' then
        
        if read_col_start_addr = (feature_plane_width-mask_width)*no_feature_planes_ser then
          read_col_start_addr <= (others => '0');
         
          if read_row_addr = feature_plane_height-mask_height then
            for i in 0 to mask_height-1 loop
              if read_row_start_mem_addr+i < memory_rows then
                memory_row_used(to_integer(read_row_start_mem_addr)+i) <= '0';
              else
                memory_row_used(to_integer(read_row_start_mem_addr)+i-memory_rows) <= '0';
              end if;
            end loop;
            read_row_addr <= (others => '0');

            if read_row_start_mem_addr+mask_height > memory_rows-1 then
              read_row_start_mem_addr <= read_row_start_mem_addr+mask_height - memory_rows;
            else
              read_row_start_mem_addr <= read_row_start_mem_addr+mask_height;
            end if;
            
          else
            for i in 0 to stride-1 loop
              if read_row_start_mem_addr+i < memory_rows then
                memory_row_used(to_integer(read_row_start_mem_addr)+i) <= '0';
              else
                memory_row_used(to_integer(read_row_start_mem_addr)+i-memory_rows) <= '0';
              end if;
            end loop;
            read_row_addr <= read_row_addr+stride;
            
            if read_row_start_mem_addr+stride > memory_rows-1 then
              read_row_start_mem_addr <= read_row_start_mem_addr+stride - memory_rows;
            else
              read_row_start_mem_addr <= read_row_start_mem_addr+stride;
            end if;
            
          end if;
        else
          read_col_start_addr <= read_col_start_addr+(stride/2)*no_feature_planes_ser;
        end if;
      end if;


      for i in 0 to memory_rows-1 loop
        if mem_out_valid(i) = '1' then
          mask_feature_stream <= mem_out(i);
        end if;
      end loop;
         
      mask_feature_valid <= mask_read_running_r1;
      mask_feature_first <= mask_first;
      mask_feature_last <= mask_last;

      -- Synchronous reset, only for signals needing reset
      -- i.e. holding state
      if rst = '1' then
        writer_ready <= '0';
        write_col_addr <= (others => '0');
        write_row_mem_addr <= (others => '0');
        memory_row_used <= (others => '0');
        read_col_start_addr <= (others => '0');
        read_row_start_mem_addr <= (others => '0');
        read_row_addr <= (others => '0');
        mask_read_running <= '0';
      end if;
    end if;
  end process;
  
end architecture;
