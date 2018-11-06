--------------------------------------------------------------------------------
--
-- Module Name      : small_sfifo32
--
--                    Copyright 2009 by
--                    Alpha Data Parallel Systems Ltd.
--                    All Rights Reserved.
--
-- Original Author  : Andrew McCormick
-- Created          : 
--
-- Modified By      : 
-- Date             :
-- Change Notes     :     
--
-- Description      : Small Dual Port RAM Synchronous FIFO
--
-- Configurable data width, fixed depth of 32
--
--
-- Dependencies     : 
--
-- Disclaimer       : THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY
--                    WHATSOEVER AND ALPHA DATA SPECIFICALLY DISCLAIMS ANY
--                    WARRANTIES IMPLIED OF MERCHANTABILITY, FITNESS FOR A
--                    PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
--
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

entity small_sfifo64 is
  
  generic (
    width : integer := 64);

  port (
    clk    : in  std_logic;
    rst    : in  std_logic;
    wadv   : in  std_logic;
    wdata  : in  std_logic_vector(width-1 downto 0);
    nfull  : out std_logic;
    radv   : in  std_logic;
    rempty : out std_logic;
    rdata  : out std_logic_vector(width-1 downto 0));

end small_sfifo64;

architecture rtl of small_sfifo64 is

  type fifo_type is array (0 to 63) of std_logic_vector(width-1 downto 0);

  signal ofifo_regs                    : fifo_type                          := (others => (others => '0'));
  signal ofifo_rptr, ofifo_wptr        : std_logic_vector(5 downto 0)       := "000000";
  signal ofifo_level                   : std_logic_vector(6 downto 0)       := "0000000";
  signal ofifo_out, ofifo_in           : std_logic_vector(width-1 downto 0) := (others => '0');
  signal ofifo_empty                   : std_logic                          := '1';
  signal ofifo_wr, ofifo_rd, ofifo_wr1 : std_logic                          := '0';
  
begin  -- rtl

  ofifo_wr <= wadv;
  ofifo_in <= wdata;

  ofifo : process (clk)
  begin  -- process ofifo
    if clk'event and clk = '1' then     -- rising clock edge
      if rst = '1' then                 -- asynchronous reset
        ofifo_level <= "0000000";
        ofifo_rptr  <= "000000";
        ofifo_wptr  <= "000000";
        ofifo_empty <= '1';
        nfull       <= '0';
        ofifo_wr1   <= '0';
      else
        -- Delayed fifo write for improving timing at cost of
        -- NFULL and EMPTY being delayed wrt WADV
        -- FIFO may have 26 elements before NFULL asserted
        ofifo_wr1 <= ofifo_wr;
        if ofifo_wr1 = '1' and ofifo_rd = '0' then
          ofifo_level <= ofifo_level+1;
          ofifo_empty <= '0';
        elsif ofifo_wr1 = '0' and ofifo_rd = '1' then
          ofifo_level <= ofifo_level-1;
          if ofifo_level = "0000001" then
            ofifo_empty <= '1';
          end if;
        end if;
        if ofifo_wr = '1' then
          ofifo_wptr <= ofifo_wptr+1;
        end if;
        if ofifo_rd = '1' and ofifo_level /= "0000000" then
          ofifo_rptr <= ofifo_rptr+1;
        end if;
        nfull <= ofifo_level(6) or ofifo_level(5);
      end if;
    end if;
  end process ofifo;

  process (clk) is
  begin  -- process
    if rising_edge(clk) then            -- rising clock edge
      if ofifo_wr = '1' then
        ofifo_regs(conv_integer(ofifo_wptr)) <= ofifo_in;
      end if;
    end if;
  end process;

  ofifo_out <= ofifo_regs(conv_integer(ofifo_rptr));

  ofifo_rd <= radv and not ofifo_empty;
  rempty   <= ofifo_empty;
  rdata    <= ofifo_out;
  
end rtl;

