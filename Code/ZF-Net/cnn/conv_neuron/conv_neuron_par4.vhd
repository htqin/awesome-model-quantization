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
-- conv_neuron.vhd
-- 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity conv_neuron_par4 is
  generic (
    feature_width : natural := 8;
    weight_width : natural := 8;
    weight_mem_order : natural := 5;
    output_width : natural := 8;
    output_shift : natural := 0;    
    bias_shift : natural := 0;
    ReLU : boolean := true);   
  port (
    clk : in std_logic;
    feature_stream : in std_logic_vector(4*feature_width-1 downto 0);
    feature_first  : in std_logic;
    feature_last   : in std_logic;
    weight_stream  : in std_logic_vector(weight_width-1 downto 0);
    weight_first   : in std_logic;
    weight_last    : in std_logic;
    output_stream  : out std_Logic_vector(output_width-1 downto 0);
    output_valid   : out std_logic);
end entity;

architecture rtl of conv_neuron_par4 is

  constant weight_mem_size : natural := 2**(weight_mem_order-2);

  constant acc_size : natural := feature_width+weight_width+weight_mem_order;
  constant p_size : natural := feature_width+weight_width+1;
  
  type weight_mem is array (0 to weight_mem_size-1) of std_logic_vector(weight_width*4-1 downto 0);

  signal wmem : weight_mem := (others => (others => '0'));
  signal wmem_waddr : unsigned(weight_mem_order-3 downto 0) := (others => '0');
  signal wmem_raddr : unsigned(weight_mem_order-3 downto 0) := (others => '0');
  signal wmem_pcount : unsigned(1 downto 0):= (others => '0');
  
  signal bias : std_logic_vector(weight_width-1 downto 0) := (others => '0');
  signal wmem_writing : std_logic := '0';
  
  signal p1 : signed(p_size-1 downto 0) := (others => '0');
  signal p2 : signed(p_size-1 downto 0) := (others => '0');
  signal p3 : signed(p_size-1 downto 0) := (others => '0');
  signal p4 : signed(p_size-1 downto 0) := (others => '0');
  signal feature_stream_reg1 : std_logic_vector(feature_width-1 downto 0) := (others => '0');
  signal feature_stream_reg2 : std_logic_vector(feature_width-1 downto 0) := (others => '0');
  signal feature_stream_reg3 : std_logic_vector(feature_width-1 downto 0) := (others => '0');
  signal feature_stream_reg4 : std_logic_vector(feature_width-1 downto 0) := (others => '0');
  signal weight_reg1 : std_logic_vector(weight_width-1 downto 0) := (others => '0');
  signal weight_reg2 : std_logic_vector(weight_width-1 downto 0) := (others => '0');
  signal weight_reg3 : std_logic_vector(weight_width-1 downto 0) := (others => '0');
  signal weight_reg4 : std_logic_vector(weight_width-1 downto 0) := (others => '0');

  signal feature_stream_r1 : std_logic_vector(4*feature_width-1 downto 0) := (others => '0');
  signal feature_stream_r2 : std_logic_vector(4*feature_width-1 downto 0) := (others => '0');
  signal feature_stream_r3 : std_logic_vector(4*feature_width-1 downto 0) := (others => '0');
  
  signal weight_out : std_logic_vector(4*weight_width-1 downto 0) := (others => '0');
  signal weight_out2 : std_logic_vector(4*weight_width-1 downto 0) := (others => '0');
  
  
  signal acc1 : signed(acc_size-1 downto 0) := (others => '0');
  signal acc2 : signed(acc_size-1 downto 0) := (others => '0');
  signal acc3 : signed(acc_size-1 downto 0) := (others => '0');
  signal acc4 : signed(acc_size-1 downto 0) := (others => '0');
  signal acc1r1 : signed(acc_size-1 downto 0) := (others => '0');
  signal acc2r1 : signed(acc_size-1 downto 0) := (others => '0');
  signal acc3r1 : signed(acc_size-1 downto 0) := (others => '0');
  signal acc4r1 : signed(acc_size-1 downto 0) := (others => '0');
  signal acc12 : signed(acc_size-1 downto 0) := (others => '0');
  signal acc34 : signed(acc_size-1 downto 0) := (others => '0');
  signal acc : signed(acc_size-1 downto 0) := (others => '0');
  
  signal feature_first_r1 : std_logic := '0';
  signal feature_first_r2 : std_logic := '0';
  signal feature_first_r3 : std_logic := '0';
  signal feature_first_r4 : std_logic := '0';
  signal feature_first_r5 : std_logic := '0';
  signal feature_last_r1 : std_logic := '0';
  signal feature_last_r2 : std_logic := '0';
  signal feature_last_r3 : std_logic := '0';
  signal feature_last_r4 : std_logic := '0';
  signal feature_last_r5 : std_logic := '0';
  signal feature_last_r6 : std_logic := '0';
  signal feature_last_r7 : std_logic := '0';
  signal feature_last_r8 : std_logic := '0';
  signal feature_last_r9 : std_logic := '0';
  signal feature_last_r10 : std_logic := '0';
                                         
  signal zeros : std_logic_vector(63 downto 0) := X"00000000_00000000";

  signal acc_slv : std_logic_vector(acc_size-1 downto 0) := (others => '0');
  
  attribute use_dsp : string;
  attribute use_dsp of p1 : signal is "yes";
  attribute use_dsp of p2 : signal is "yes";
  attribute use_dsp of p3 : signal is "yes";
  attribute use_dsp of p4 : signal is "yes";

  attribute ram_style : string;
  attribute ram_style of wmem : signal is "block";
  
begin

  process(clk)
    
  begin
    if rising_edge(clk) then
      if weight_first = '1' then
        wmem_writing <= '1';
        wmem_waddr <= to_unsigned(0,weight_mem_order-2);
        bias <= weight_stream;
        wmem_pcount <= to_unsigned(0,2);
      end if;
      if wmem_writing = '1' then
        if weight_last = '1' then
          wmem_writing <= '0';
        end if;
        for i in 0 to 3 loop
          if wmem_pcount = i then
            wmem(to_integer(wmem_waddr))(((i+1)*weight_width)-1 downto i*weight_width) <= weight_stream;
          end if;
        end loop;
        wmem_pcount <= wmem_pcount +1;
        if wmem_pcount = 3 then
          wmem_waddr <= wmem_waddr+1;
        end if;
      end if;

      weight_out <= wmem(to_integer(wmem_raddr)); 
      weight_out2 <= weight_out;
      weight_reg1 <= weight_out2(weight_width-1 downto 0);
      weight_reg2 <= weight_out2(2*weight_width-1 downto weight_width);
      weight_reg3 <= weight_out2(3*weight_width-1 downto 2*weight_width);
      weight_reg4 <= weight_out2(4*weight_width-1 downto 3*weight_width);
      if feature_first = '1' then
        wmem_raddr <= to_unsigned(0,weight_mem_order-2);    
      else 
        wmem_raddr <= wmem_raddr+1;  
      end if;

      feature_stream_r1 <= feature_stream;
      feature_stream_r2 <= feature_stream_r1;
      feature_stream_r3 <= feature_stream_r2;
      feature_stream_reg1 <= feature_stream_r3(feature_width-1 downto 0);
      feature_stream_reg2 <= feature_stream_r3(2*feature_width-1 downto feature_width);
      feature_stream_reg3 <= feature_stream_r3(3*feature_width-1 downto 2*feature_width);
      feature_stream_reg4 <= feature_stream_r3(4*feature_width-1 downto 3*feature_width);

      feature_first_r1 <= feature_first;
      feature_first_r2 <= feature_first_r1;
      feature_first_r3 <= feature_first_r2;
      feature_first_r4 <= feature_first_r3;
      feature_first_r5 <= feature_first_r4;
      feature_last_r1 <= feature_last;
      feature_last_r2 <= feature_last_r1;
      feature_last_r3 <= feature_last_r2;
      feature_last_r4 <= feature_last_r3;
      feature_last_r5 <= feature_last_r4;
      feature_last_r6 <= feature_last_r5;
      feature_last_r7 <= feature_last_r6;
      feature_last_r8 <= feature_last_r7;
      feature_last_r9 <= feature_last_r8;
      feature_last_r10 <= feature_last_r9;
      
      p1 <= signed(weight_reg1)*signed('0' & feature_stream_reg1); 
      p2 <= signed(weight_reg2)*signed('0' & feature_stream_reg2);
      p3 <= signed(weight_reg3)*signed('0' & feature_stream_reg3);
      p4 <= signed(weight_reg4)*signed('0' & feature_stream_reg4);
      
      if feature_first_r5 = '1' then      
        acc1 <= shift_left(resize(signed(bias),acc_size),bias_shift)+resize(p1,acc_size);
        acc2 <= resize(p2,acc_size);
        acc3 <= resize(p3,acc_size);
        acc4 <= resize(p4,acc_size);
      else        
        acc1 <= acc1+resize(p1,acc_size);
        acc2 <= acc2+resize(p2,acc_size);
        acc3 <= acc3+resize(p3,acc_size);
        acc4 <= acc4+resize(p4,acc_size);
      end if;

      acc1r1 <= acc1;
      acc2r1 <= acc2;
      acc3r1 <= acc3;
      acc4r1 <= acc4;
      
      
      acc12 <= acc1r1+acc2r1;
      acc34 <= acc3r1+acc4r1;
      acc <= acc12+acc34;
      
       
      acc_slv <= std_logic_vector(acc);
      
      if feature_last_r10 = '1' then        
        if ReLU then
          if acc_slv(acc_size-1) = '1' then
            -- If negative output 0
            output_stream <= (others => '0');
          else
            if acc_size = output_width+output_shift then
              -- Maximum shift, cannot overflow
              output_stream <= acc_slv(acc_size-1 downto output_shift);
            else
              if acc_slv(acc_size-1 downto output_width+output_shift-1) /= zeros(acc_size-1 downto output_width+output_shift-1) then
                -- Saturate if overflow
                output_stream(output_width-1) <= '0';
                output_stream(output_width-2 downto 0) <= (others => '1');                      
                  
              else
                -- Select bits of interest
                output_stream <=  acc_slv(output_width+output_shift-1 downto output_shift);
              end if;
            end if;
          end if;
        else
          output_stream <= acc_slv(output_width+output_shift-1 downto output_shift);
        end if;
        output_valid <= '1';
      else
        output_valid <= '0';
      end if;
      
    end if;
  end process;
  
end architecture;
