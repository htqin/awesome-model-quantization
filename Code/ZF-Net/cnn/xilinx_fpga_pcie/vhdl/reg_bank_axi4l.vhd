--
-- AXI 4 Lite Register Bank 
--
-- Provide a simple Register interface for an 32-bit AXI4 lite slave
-- Address range fixed to 12 bits
-- Number of 32 bit registers parameterizable 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity reg_bank_axi4l is
  generic (
    number_of_axil_regs  : natural := 8);
  port (
    -- AXI4 Interfaces
    aclk               : in  std_logic;
    aresetn            : in std_logic;
    -- AXI4L Interface      
    reg_axi_awaddr     : in  std_logic_vector(11 downto 0);
    reg_axi_awvalid    : in  std_logic;
    reg_axi_wdata      : in  std_logic_vector(31 downto 0);
    reg_axi_wstrb      : in  std_logic_vector(3 downto 0);
    reg_axi_wvalid     : in  std_logic;
    reg_axi_bready     : in  std_logic;
    reg_axi_araddr     : in  std_logic_vector(11 downto 0);
    reg_axi_arvalid    : in  std_logic;
    reg_axi_rready     : in  std_logic;
    reg_axi_awready    : out std_logic;
    reg_axi_wready     : out std_logic;
    reg_axi_bresp      : out std_logic_vector(1 downto 0);
    reg_axi_bvalid     : out std_logic;
    reg_axi_arready    : out std_logic;
    reg_axi_rdata      : out std_logic_vector(31 downto 0);
    reg_axi_rresp      : out std_logic_vector(1 downto 0);
    reg_axi_rvalid     : out std_logic;
    -- Control and status register buses
    status_regs_in     : in  std_Logic_vector(32*number_of_axil_regs-1 downto 0);
    control_regs_out   : out std_Logic_vector(32*number_of_axil_regs-1 downto 0));  
end reg_bank_axi4l;

architecture mixed of reg_bank_axi4l is

  type reg_array_type is array (0 to number_of_axil_regs-1) of std_logic_vector(31 downto 0);
  signal control_regs : reg_array_type := (others => (others => '0'));
  signal status_regs : reg_array_type := (others => (others => '0'));
  
  signal reg_wavalid,reg_wdvalid : std_logic := '0';
  signal reg_waddr : std_logic_vector(11 downto 0);
  signal reg_be : std_logic_vector(3 downto 0);
  signal reg_wdata : std_logic_vector(31 downto 0);
  signal reg_axi_rvalid_i : std_logic;

begin  -- mixed

  reg_axi_awready <= (not reg_wavalid) and (not reg_axi_rvalid_i);
  reg_axi_arready <= (not reg_wavalid) and (not reg_axi_rvalid_i);
  reg_axi_wready <= (not reg_wdvalid) and (reg_wavalid or (reg_axi_awvalid and (not reg_axi_rvalid_i)));
  reg_axi_bresp <= "00";
  reg_axi_rresp <= "00";
  reg_axi_rvalid <= reg_axi_rvalid_i;
  
  axi4_lite_slave0: process (aclk) is
  begin  -- process axi4_lite_slave0
    if rising_edge(aclk) then           -- rising clock edge

      if reg_axi_bready = '1' then
        reg_axi_bvalid <= '0';
      end if;
      
      if reg_axi_awvalid = '1' and reg_axi_rvalid_i = '0' then       
        reg_waddr <= reg_axi_awaddr;
        reg_wavalid <= '1';     
      end if;

      if (reg_axi_wvalid = '1') and (reg_wavalid = '1' or (reg_axi_awvalid = '1' and reg_axi_rvalid_i = '0')) then
        reg_wdvalid <= '1';
        reg_wdata <= reg_axi_wdata;
        reg_be <= reg_axi_wstrb;
      end if;

      if reg_wdvalid = '1' and reg_wavalid = '1' then
        reg_wavalid <= '0';
        reg_wdvalid <= '0';
        reg_axi_bvalid <= '1';
        for i in 0 to number_of_axil_regs-1 loop
          if reg_waddr = 4*i then
            for j in 0 to 3 loop
              if reg_be(j) = '1' then
                control_regs(i)(8*j+7 downto 8*j) <= reg_wdata(8*j+7 downto 8*j);
              end if;
            end loop;  -- j
          end if;
        end loop;  -- i            
      end if;

      if reg_axi_rready = '1' then
        reg_axi_rvalid_i <= '0';
      end if;
      
      if reg_axi_arvalid = '1' and reg_axi_rvalid_i = '0' then
        reg_axi_rvalid_i <= '1';
        for i in 0 to number_of_axil_regs-1 loop
          if reg_axi_araddr = 4*i then
            reg_axi_rdata <= status_regs(i);
          end if;
        end loop;  -- i 
      end if;

      -- Default all control regs to read back
      for i in 0 to number_of_axil_regs-1 loop
        status_regs(i) <= status_regs_in(32*i+31 downto 32*i);
        control_regs_out(32*i+31 downto 32*i) <= control_regs(i);  
      end loop;  -- 
           
      if aresetn= '0' then
        reg_axi_bvalid <= '0';
        reg_axi_rvalid_i <= '0';
        reg_wavalid <= '0';
        reg_wdvalid <= '0';
      end if;
    end if;
  end process axi4_lite_slave0;
  
  
  
  
  
end mixed;
