--
-- AXI 4 Lite Register Bank 
--
-- Provide a simple Register interface for an 32-bit AXI4 lite slave
-- Address range fixed to 12 bits
-- Number of 32 bit registers parameterizable 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.axi4_field.all;
use work.axi4l_profile.all;

entity reg_bank_axi4l_wrap is
  generic (
    number_of_axil_regs  : natural := 8);
  port (
    aclk               : in  std_logic;
    aresetn            : in std_logic;
    reg_axi_m2s        : in axi4l_32_m2s_t;
    reg_axi_s2m        : out  axi4l_32_s2m_t;
    -- Control and status register buses
    status_regs_in     : in  std_logic_vector(32*number_of_axil_regs-1 downto 0);
    control_regs_out   : out std_logic_vector(32*number_of_axil_regs-1 downto 0));  
end entity reg_bank_axi4l_wrap;

architecture mixed of reg_bank_axi4l_wrap is


begin  -- mixed

  reg_bank_axi4l_1: entity work.reg_bank_axi4l
    generic map (
      number_of_axil_regs => number_of_axil_regs)
    port map (
      aclk             => aclk,
      aresetn          => aresetn,
      reg_axi_awaddr   => reg_axi_m2s.aw.addr(11 downto 0),
      reg_axi_awvalid  => reg_axi_m2s.aw.valid,
      reg_axi_wdata    => reg_axi_m2s.w.data,
      reg_axi_wstrb    => reg_axi_m2s.w.strb,
      reg_axi_wvalid   => reg_axi_m2s.w.valid,
      reg_axi_bready   => reg_axi_m2s.b.ready,
      reg_axi_araddr   => reg_axi_m2s.ar.addr(11 downto 0),
      reg_axi_arvalid  => reg_axi_m2s.ar.valid,
      reg_axi_rready   => reg_axi_m2s.r.ready,
      reg_axi_awready  => reg_axi_s2m.aw.ready,
      reg_axi_wready   => reg_axi_s2m.w.ready,
      reg_axi_bresp    => reg_axi_s2m.b.resp,
      reg_axi_bvalid   => reg_axi_s2m.b.valid,
      reg_axi_arready  => reg_axi_s2m.ar.ready,
      reg_axi_rdata    => reg_axi_s2m.r.data,
      reg_axi_rresp    => reg_axi_s2m.r.resp,
      reg_axi_rvalid   => reg_axi_s2m.r.valid,
      status_regs_in   => status_regs_in,
      control_regs_out => control_regs_out);
  
  
end mixed;
