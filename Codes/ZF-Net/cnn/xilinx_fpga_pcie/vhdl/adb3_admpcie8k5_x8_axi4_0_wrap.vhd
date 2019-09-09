--
-- Component adb3_admpcie8k5_x8_axi4_0_wrap.vhd
--
-- AXI4 Record Type wrap of adb3_admpcie8k5_x8_axi4_0.vhd
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.axi4_field.all;
use work.axi4_profile.all;
use work.axi4l_profile.all;

entity adb3_admpcie8k5_x8_axi4_0_wrap is
port (
  perst_n : in std_logic;
  pcie100_p : in std_logic;
  pcie100_n : in std_logic;
  refclk200_in : in std_logic;
  aclk : out std_logic;
  aresetn : out std_logic;
  pci_exp_txn : out std_logic_vector(7 downto 0);
  pci_exp_txp : out std_logic_vector(7 downto 0);
  pci_exp_rxn : in std_logic_vector(7 downto 0);
  pci_exp_rxp : in std_logic_vector(7 downto 0);
  model_inout_i : in std_logic_vector(45 downto 0);
  model_inout_o : out std_logic_vector(45 downto 0);
  model_inout_t : out std_logic_vector(45 downto 0);
  dma0_m_axis_tdata : out std_logic_vector(255 downto 0);
  dma0_m_axis_tready : in std_logic;
  dma0_m_axis_tvalid : out std_logic;
  dma1_s_axis_tdata : in std_logic_vector(255 downto 0);
  dma1_s_axis_tready : out std_logic;
  dma1_s_axis_tvalid : in std_logic;
  dma2_m_axis_tdata : out std_logic_vector(255 downto 0);
  dma2_m_axis_tready : in std_logic;
  dma2_m_axis_tvalid : out std_logic;
  core_status : out std_logic_vector(63 downto 0);
  ds_axi_m2s : out axi4_256_m2s_t:=axi4_256_m2s_default;
  ds_axi_s2m : in axi4_256_s2m_t:=axi4_256_s2m_default);
end entity;

architecture rtl of adb3_admpcie8k5_x8_axi4_0_wrap is

COMPONENT adb3_admpcie8k5_x8_axi4_0
  PORT (
    perst_n : IN STD_LOGIC;
    pcie100_p : IN STD_LOGIC;
    pcie100_n : IN STD_LOGIC;
    refclk200_in : IN STD_LOGIC;
    aclk : OUT STD_LOGIC;
    aresetn : OUT STD_LOGIC;
    pci_exp_txn : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    pci_exp_txp : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    pci_exp_rxn : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    pci_exp_rxp : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    model_inout_i : IN STD_LOGIC_VECTOR(45 DOWNTO 0);
    model_inout_o : OUT STD_LOGIC_VECTOR(45 DOWNTO 0);
    model_inout_t : OUT STD_LOGIC_VECTOR(45 DOWNTO 0);
    ds_axi_awaddr : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    ds_axi_awlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    ds_axi_awsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    ds_axi_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ds_axi_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    ds_axi_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    ds_axi_awvalid : OUT STD_LOGIC;
    ds_axi_wdata : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    ds_axi_wstrb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    ds_axi_wlast : OUT STD_LOGIC;
    ds_axi_wvalid : OUT STD_LOGIC;
    ds_axi_bready : OUT STD_LOGIC;
    ds_axi_araddr : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    ds_axi_arlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    ds_axi_arsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    ds_axi_arburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ds_axi_arcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    ds_axi_arprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    ds_axi_arvalid : OUT STD_LOGIC;
    ds_axi_rready : OUT STD_LOGIC;
    ds_axi_awready : IN STD_LOGIC;
    ds_axi_wready : IN STD_LOGIC;
    ds_axi_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    ds_axi_bvalid : IN STD_LOGIC;
    ds_axi_arready : IN STD_LOGIC;
    ds_axi_rdata : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    ds_axi_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    ds_axi_rlast : IN STD_LOGIC;
    ds_axi_rvalid : IN STD_LOGIC;
    ds_axi_awlock : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ds_axi_awqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    ds_axi_arlock : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ds_axi_arqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    ds_axi_awregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    ds_axi_arregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    dma0_m_axis_tdata : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    dma0_m_axis_tready : IN STD_LOGIC;
    dma0_m_axis_tvalid : OUT STD_LOGIC;
    dma1_s_axis_tdata : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    dma1_s_axis_tready : OUT STD_LOGIC;
    dma1_s_axis_tvalid : IN STD_LOGIC;
    dma2_m_axis_tdata : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    dma2_m_axis_tready : IN STD_LOGIC;
    dma2_m_axis_tvalid : OUT STD_LOGIC;
    core_status : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
  );
END COMPONENT;

  signal zeros : std_logic_vector(1023 downto 0);
  signal ds_axi_awaddr : std_logic_vector(63 downto 0);
  signal ds_axi_araddr : std_logic_vector(63 downto 0);

begin

  zeros <= (others => '0');

 ds_axi_m2s.aw.addr <= std_logic_vector(resize(unsigned(ds_axi_awaddr),64));
 ds_axi_m2s.ar.addr <= std_logic_vector(resize(unsigned(ds_axi_araddr),64));
 ds_axi_m2s.aw.id <= (others => '0');
 ds_axi_m2s.ar.id <= (others => '0');

adb3_admpcie8k5_x8_axi4_0_i: adb3_admpcie8k5_x8_axi4_0
  port map (
  perst_n => perst_n,
  pcie100_p => pcie100_p,
  pcie100_n => pcie100_n,
  refclk200_in => refclk200_in,
  aclk => aclk,
  aresetn => aresetn,
  pci_exp_txn => pci_exp_txn,
  pci_exp_txp => pci_exp_txp,
  pci_exp_rxn => pci_exp_rxn,
  pci_exp_rxp => pci_exp_rxp,
  model_inout_i => model_inout_i,
  model_inout_o => model_inout_o,
  model_inout_t => model_inout_t,
  dma0_m_axis_tdata => dma0_m_axis_tdata,
  dma0_m_axis_tready => dma0_m_axis_tready,
  dma0_m_axis_tvalid => dma0_m_axis_tvalid,
  dma1_s_axis_tdata => dma1_s_axis_tdata,
  dma1_s_axis_tready => dma1_s_axis_tready,
  dma1_s_axis_tvalid => dma1_s_axis_tvalid,
  dma2_m_axis_tdata => dma2_m_axis_tdata,
  dma2_m_axis_tready => dma2_m_axis_tready,
  dma2_m_axis_tvalid => dma2_m_axis_tvalid,
  core_status => core_status,
  ds_axi_awaddr => ds_axi_awaddr,
  ds_axi_awlen => ds_axi_m2s.aw.len,
  ds_axi_awsize => ds_axi_m2s.aw.size,
  ds_axi_awburst => ds_axi_m2s.aw.burst,
  ds_axi_awlock => ds_axi_m2s.aw.lock,
  ds_axi_awcache => ds_axi_m2s.aw.cache,
  ds_axi_awprot => ds_axi_m2s.aw.prot,
  ds_axi_awregion => ds_axi_m2s.aw.region,
  ds_axi_awqos => ds_axi_m2s.aw.qos,
  ds_axi_awvalid => ds_axi_m2s.aw.valid,
  ds_axi_awready => ds_axi_s2m.aw.ready,
  ds_axi_wdata => ds_axi_m2s.w.data(255 downto 0),
  ds_axi_wstrb => ds_axi_m2s.w.strb(31 downto 0),
  ds_axi_wvalid => ds_axi_m2s.w.valid,
  ds_axi_wlast => ds_axi_m2s.w.last,
  ds_axi_wready => ds_axi_s2m.w.ready,
  ds_axi_bresp => ds_axi_s2m.b.resp,
  ds_axi_bvalid => ds_axi_s2m.b.valid,
  ds_axi_bready => ds_axi_m2s.b.ready,
  ds_axi_araddr => ds_axi_araddr,
  ds_axi_arlen => ds_axi_m2s.ar.len,
  ds_axi_arsize => ds_axi_m2s.ar.size,
  ds_axi_arburst => ds_axi_m2s.ar.burst,
  ds_axi_arlock => ds_axi_m2s.ar.lock,
  ds_axi_arcache => ds_axi_m2s.ar.cache,
  ds_axi_arprot => ds_axi_m2s.ar.prot,
  ds_axi_arregion => ds_axi_m2s.ar.region,
  ds_axi_arqos => ds_axi_m2s.ar.qos,
  ds_axi_arvalid => ds_axi_m2s.ar.valid,
  ds_axi_arready => ds_axi_s2m.ar.ready,
  ds_axi_rdata => ds_axi_s2m.r.data(255 downto 0),
  ds_axi_rresp => ds_axi_s2m.r.resp,
  ds_axi_rvalid => ds_axi_s2m.r.valid,
  ds_axi_rlast => ds_axi_s2m.r.last,
  ds_axi_rready => ds_axi_m2s.r.ready);
end architecture;
