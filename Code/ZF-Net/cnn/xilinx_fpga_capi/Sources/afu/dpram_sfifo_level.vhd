--------------------------------------------------------------------------------
--
-- Module Name      : dpram_sfifo_level
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
-- Description      :
-- Dual Port RAM Synchronous FIFO, with level port
--
-- Configurable data width
--
-- Use behavioural BRAM description to allow tools to identify
-- and use DPBRAMs appropriately
--
--
--
-- Dependencies     : adb3_ocp
--
-- Disclaimer       : THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY
--                    WHATSOEVER AND ALPHA DATA SPECIFICALLY DISCLAIMS ANY
--                    WARRANTIES IMPLIED OF MERCHANTABILITY, FITNESS FOR A
--                    PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

entity dpram_sfifo_level is
  
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
    rdata  : out std_logic_vector(width-1 downto 0);
    rlevel : out std_logic_vector(9 downto 0));

end dpram_sfifo_level;

architecture rtl of dpram_sfifo_level is

  type ram_type is array (511 downto 0) of std_logic_vector(width-1 downto 0);

  signal ram              : ram_type;
  signal waddr            : std_logic_vector(8 downto 0)       := (others => '0');
  signal raddr            : std_logic_vector(8 downto 0)       := (others => '0');
  signal ram_reg, ram_out : std_logic_vector(width-1 downto 0) := (others => '0');
  signal rd_ram           : std_logic                          := '0';

  signal level : std_logic_vector(8 downto 0) := (others => '0');


  type fifo_type is array (0 to 7) of std_logic_vector(width-1 downto 0);

  signal ofifo_regs             : fifo_type;
  signal ofifo_rptr, ofifo_wptr : std_logic_vector(2 downto 0) := "000";
  signal ofifo_level            : std_logic_vector(3 downto 0) := "0000";
  signal ofifo_out, ofifo_in    : std_logic_vector(width-1 downto 0);
  signal ofifo_empty            : std_logic                    := '1';
  signal ofifo_wr, ofifo_rd     : std_logic                    := '0';

  signal of_out_reg_empty : std_logic                          := '1';
  signal of_out_reg_data  : std_logic_vector(width-1 downto 0) := (others => '0');

  signal tlevel : std_logic_vector(9 downto 0) := (others => '0');

  attribute ram_style               : string;
  attribute ram_style of ofifo_regs : signal is "distributed";
  
begin  -- rtl

  -- Model Block Rams, with output register
  process (clk)
  begin  -- process
    if clk'event and clk = '1' then     -- rising clock edge
      if wadv = '1' then
        ram(conv_integer(waddr)) <= wdata;
      end if;
    end if;
  end process;

  process (clk)
  begin  -- process
    if clk'event and clk = '1' then     -- rising clock edge
      ram_reg <= ram(conv_integer(raddr));
      ram_out <= ram_reg;
    end if;
  end process;


  writer : process (clk)
  begin  -- process write
    
    if clk'event and clk = '1' then     -- rising clock edge
      if rst = '1' then
        waddr <= (others => '0');
        nfull <= '0';
      else
        if wadv = '1' then
          waddr <= waddr+1;
        end if;

        --nfull <= AND_reduce(tlevel(8 downto 3));
        nfull <= tlevel(8) or tlevel(9);
      end if;
    end if;
  end process writer;


  reader : process (clk)
  begin  -- process reader
    if clk'event and clk = '1' then     -- rising clock edge
      if rst = '1' then
        raddr <= (others => '0');
        level <= (others => '0');
      else
        level <= waddr - raddr;
        if (ofifo_level(3 downto 2) = "00") and raddr /= waddr then
          raddr  <= raddr+1;
          rd_ram <= '1';
        else
          rd_ram <= '0';
        end if;
        ofifo_wr <= rd_ram;
      end if;
    end if;
  end process reader;


  ofifo_in <= ram_out;
  -- 8 word output FIFO to allow FWFT operation to make FIFO useful
  ofifo : process (clk)
  begin  -- process ofifo   
    if clk'event and clk = '1' then     -- rising clock edge
      if rst = '1' then                 -- asynchronous reset
        ofifo_level <= "0000";
        ofifo_rptr  <= "000";
        ofifo_wptr  <= "000";
        ofifo_empty <= '1';
      else
        if ofifo_wr = '1' and ofifo_rd = '0' then
          ofifo_level <= ofifo_level+1;
          ofifo_empty <= '0';
        elsif ofifo_wr = '0' and ofifo_rd = '1' then
          ofifo_level <= ofifo_level-1;
          if ofifo_level = "0001" then
            ofifo_empty <= '1';
          end if;
        end if;
        if ofifo_wr = '1' then
          ofifo_wptr <= ofifo_wptr+1;
        end if;
        if ofifo_rd = '1' and ofifo_level /= "0000" then
          ofifo_rptr <= ofifo_rptr+1;
        end if;
      end if;
    end if;
  end process ofifo;
  ofifo_out <= ofifo_regs(conv_integer(ofifo_rptr));

  process (clk) is
  begin  -- process
    if rising_edge(clk) then            -- rising clock edge
      if ofifo_wr = '1' then
        ofifo_regs(conv_integer(ofifo_wptr)) <= ofifo_in;
      end if;
    end if;
  end process;

  -- 1 Word Deep FIFO to improve output timing

  of_out : process (clk)
  begin  -- process of_out
    
    if clk'event and clk = '1' then
      if rst = '1' then
        of_out_reg_empty <= '1';
        of_out_reg_data  <= (others => '0');
      else
        if of_out_reg_empty = '1' and ofifo_empty = '0' then
          of_out_reg_empty <= '0';
        elsif ofifo_empty = '1' and radv = '1' then
          of_out_reg_empty <= '1';
        end if;

        if ofifo_rd = '1' then
          of_out_reg_data <= ofifo_out;
        end if;
      end if;
    end if;
  end process of_out;


  ofifo_rd <= not ofifo_empty and (radv or of_out_reg_empty);

  rempty <= of_out_reg_empty;
  rdata  <= of_out_reg_data;



  fifo_level0 : process (clk)
  begin  -- process fifo_level0
    if clk'event and clk = '1' then     -- rising clock edge
      if rst = '1' then                 -- asynchronous reset (active low)
        tlevel <= (others => '0');
      else
        if radv = '1' and wadv = '0' then
          tlevel <= tlevel-1;
        elsif wadv = '1' and radv = '0' then
          tlevel <= tlevel+1;
        end if;
      end if;
    end if;
  end process fifo_level0;

  rlevel <= tlevel(9 downto 0);
  
end rtl;

