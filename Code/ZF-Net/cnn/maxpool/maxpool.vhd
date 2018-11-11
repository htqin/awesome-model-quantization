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
-- maxpool.vhd
-- Max Pool operation 
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


--use std.textio.all; --  Imports the standard textio package.

entity maxpool is
  generic (
    feature_width : natural := 8;
    no_feature_planes_par : natural := 3;
    no_feature_planes_ser : natural := 3;
    pool_size : natural := 4
    );   
  port (
    clk : in std_logic;
    rst : in std_logic;
    feature_stream : in std_logic_vector(feature_width*no_feature_planes_par-1 downto 0);
    feature_valid  : in  std_logic;
    feature_first  : in  std_logic;
    feature_last   : in  std_logic;
    max_feature_stream : out std_logic_vector(feature_width*no_feature_planes_par-1 downto 0);
    max_feature_valid  : out std_logic);
end entity;

architecture rtl of maxpool is

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

  
  type max_memory_row_type is array(0 to no_feature_planes_par-1) of std_logic_vector(feature_width-1 downto 0);
  type max_memory_type is array(0 to no_feature_planes_ser-1) of max_memory_row_type;
  signal max_memory : max_memory_type := (others => (others => (others => '0')));


  constant pool_bits : natural := bits_reqd(pool_size);
  constant ser_feature_bits : natural := bits_reqd(no_feature_planes_ser);

  signal pool_count : unsigned (pool_bits-1 downto 0) := (others => '0');
  signal ser_feature_count : unsigned(ser_feature_bits-1 downto 0) := (others => '0');
  signal feature_first_q : std_logic := '0';
  signal feature_last_q : std_logic := '0';
  signal ser_feature_onehot : std_logic_vector(no_feature_planes_ser-1 downto 0) := (0=> '1', others => '0');
  signal ser_feature_onehot_r1 : std_logic_vector(no_feature_planes_ser-1 downto 0) := (0=> '1', others => '0'); 

  signal max_feature_stream_i :max_memory_type := (others => (others => (others => '0')));
  --  std_logic_vector(feature_width*no_feature_planes_par-1 downto 0) := (others => '0');
  signal max_feature_valid_i  : std_logic := '0';
      
begin

  process(clk)
     --variable l : line;
  begin
    if rising_edge(clk) then
      ser_feature_onehot_r1 <= ser_feature_onehot;
      for i in 0 to no_feature_planes_par-1 loop
        for j in 0 to no_feature_planes_ser-1 loop
          if ser_feature_onehot_r1(j) = '1' then
            max_feature_stream((feature_width)*(i+1)-1 downto (feature_width*i)) <= max_feature_stream_i(j)(i);
          end if;
        end loop;
      end loop;
      max_feature_valid <= max_feature_valid_i;


      
      max_feature_valid_i <= feature_valid and feature_last_q;
      if feature_valid = '1' then
        if feature_first = '1' then
          feature_first_q <= '1';
        end if;
        if feature_first = '1' or feature_first_q = '1' then
          for i in 0 to no_feature_planes_par-1 loop
            for j in 0 to no_feature_planes_ser-1 loop
              if ser_feature_onehot(j) = '1' then
                max_memory(j)(i) <= feature_stream(feature_width*(i+1)-1 downto (feature_width*i));
              end if;
            end loop;
          end loop;
        elsif feature_last_q = '1' then
          for i in 0 to no_feature_planes_par-1 loop
            for j in 0 to no_feature_planes_ser-1 loop
              if ser_feature_onehot(j) = '1' then
                if unsigned(max_memory(j)(i)) > unsigned(feature_stream((feature_width)*(i+1)-1 downto (feature_width*i))) then
                  max_feature_stream_i(j)(i) <= max_memory(j)(i);
              
                else
                  max_feature_stream_i(j)(i) <= feature_stream((feature_width)*(i+1)-1 downto (feature_width*i));
                end if;
              end if;
            end loop;
          end loop;        
        else
          for i in 0 to no_feature_planes_par-1 loop
            for j in 0 to no_feature_planes_ser-1 loop
              if ser_feature_onehot(j) = '1' then
                if unsigned(max_memory(j)(i)) < unsigned(feature_stream((feature_width)*(i+1)-1 downto (feature_width*i))) then           
                  max_memory(j)(i) <= feature_stream((feature_width)*(i+1)-1 downto (feature_width*i));
                end if;
              end if;
            end loop;
          end loop;
        end if;
        
        if ser_feature_count = no_feature_planes_ser-1 then
          ser_feature_count <= (others => '0');
          if feature_first_q = '1' then
            feature_first_q <= '0';
          end if;
          if pool_count = pool_size-1 then
            pool_count <= (others => '0');
            feature_last_q <= '0';
          else
            pool_count <= pool_count+1;
          end if;
          if pool_count = pool_size-2 then
            feature_last_q <= '1';
          end if;
        else
          ser_feature_count <=  ser_feature_count+1;
        end if;
        ser_feature_onehot <= ser_feature_onehot(no_feature_planes_ser-2 downto 0) & ser_feature_onehot(no_feature_planes_ser-1);
        
      end if;
      
      if rst = '1' then
        ser_feature_count <= (others => '0');
        ser_feature_onehot <= (0=> '1', others => '0'); 
        feature_first_q <= '0';
        feature_last_q <= '0';
        pool_count <= (others => '0');
      end if;


      --write (l, to_integer(pool_count));  
      --write (l, string'(" "));
      --write (l, to_integer(ser_feature_count));  
      --write (l, string'(" "));
      --if feature_valid = '1' then
      --  write (l, string'("V"));
      --end if;
      --if feature_first_q = '1'  or feature_first = '1' then
      --  write (l, string'("F"));
      --end if;
      --if feature_last_q = '1' then
      --  write (l, string'("L"));
      --end if;
      --writeline (output, l);

      
    end if;
  end process;
  
end architecture;
