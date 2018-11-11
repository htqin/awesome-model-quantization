--
-- Component axi_dwidth_converter_1_wrap.vhd
--
-- AXI4 Record Type wrap of axi_dwidth_converter_1.vhd
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.axi4_field.all;
use work.axi4_profile.all;
use work.axi4l_profile.all;

entity axi_dwidth_converter_1_wrap is
port (
  s_axi_aclk : in std_logic;
  s_axi_aresetn : in std_logic;
  s_axi_m2s : in axi4_256_m2s_t:=axi4_256_m2s_default;
  s_axi_s2m : out axi4_256_s2m_t:=axi4_256_s2m_default;
  m_axi_m2s : out axi4_32_m2s_t:=axi4_32_m2s_default;
  m_axi_s2m : in axi4_32_s2m_t:=axi4_32_s2m_default);
end entity;

architecture rtl of axi_dwidth_converter_1_wrap is

COMPONENT axi_dwidth_converter_1
  PORT (
    s_axi_aclk : IN STD_LOGIC;
    s_axi_aresetn : IN STD_LOGIC;
    s_axi_awaddr : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    s_axi_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axi_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_awburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_awlock : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axi_awcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_awregion : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_awqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_awvalid : IN STD_LOGIC;
    s_axi_awready : OUT STD_LOGIC;
    s_axi_wdata : IN STD_LOGIC_VECTOR(255 DOWNTO 0);
    s_axi_wstrb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wlast : IN STD_LOGIC;
    s_axi_wvalid : IN STD_LOGIC;
    s_axi_wready : OUT STD_LOGIC;
    s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bvalid : OUT STD_LOGIC;
    s_axi_bready : IN STD_LOGIC;
    s_axi_araddr : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    s_axi_arlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    s_axi_arsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_arburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_arlock : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axi_arcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    s_axi_arregion : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_arqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_arvalid : IN STD_LOGIC;
    s_axi_arready : OUT STD_LOGIC;
    s_axi_rdata : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
    s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rlast : OUT STD_LOGIC;
    s_axi_rvalid : OUT STD_LOGIC;
    s_axi_rready : IN STD_LOGIC;
    m_axi_awaddr : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    m_axi_awlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axi_awsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_awlock : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_awregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_awqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_awvalid : OUT STD_LOGIC;
    m_axi_awready : IN STD_LOGIC;
    m_axi_wdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_wstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_wlast : OUT STD_LOGIC;
    m_axi_wvalid : OUT STD_LOGIC;
    m_axi_wready : IN STD_LOGIC;
    m_axi_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_bvalid : IN STD_LOGIC;
    m_axi_bready : OUT STD_LOGIC;
    m_axi_araddr : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    m_axi_arlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axi_arsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_arburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_arlock : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axi_arcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_arprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    m_axi_arregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_arqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    m_axi_arvalid : OUT STD_LOGIC;
    m_axi_arready : IN STD_LOGIC;
    m_axi_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axi_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    m_axi_rlast : IN STD_LOGIC;
    m_axi_rvalid : IN STD_LOGIC;
    m_axi_rready : OUT STD_LOGIC
  );
END COMPONENT;

  signal zeros : std_logic_vector(1023 downto 0);
  signal s_axi_awaddr : std_logic_vector(23 downto 0);
  signal s_axi_araddr : std_logic_vector(23 downto 0);
  signal m_axi_awaddr : std_logic_vector(23 downto 0);
  signal m_axi_araddr : std_logic_vector(23 downto 0);

begin

  zeros <= (others => '0');

 s_axi_awaddr <= s_axi_m2s.aw.addr(23 downto 0);
 s_axi_araddr <= s_axi_m2s.ar.addr(23 downto 0);
 s_axi_s2m.r.id <= (others => '0');
 s_axi_s2m.b.id <= (others => '0');
 m_axi_m2s.aw.addr <= std_logic_vector(resize(unsigned(m_axi_awaddr),64));
 m_axi_m2s.ar.addr <= std_logic_vector(resize(unsigned(m_axi_araddr),64));
 m_axi_m2s.aw.id <= (others => '0');
 m_axi_m2s.ar.id <= (others => '0');

axi_dwidth_converter_1_i: axi_dwidth_converter_1
  port map (
  s_axi_aclk => s_axi_aclk,
  s_axi_aresetn => s_axi_aresetn,
  s_axi_awaddr => s_axi_awaddr,
  s_axi_awlen => s_axi_m2s.aw.len,
  s_axi_awsize => s_axi_m2s.aw.size,
  s_axi_awburst => s_axi_m2s.aw.burst,
  s_axi_awlock => s_axi_m2s.aw.lock,
  s_axi_awcache => s_axi_m2s.aw.cache,
  s_axi_awprot => s_axi_m2s.aw.prot,
  s_axi_awregion => s_axi_m2s.aw.region,
  s_axi_awqos => s_axi_m2s.aw.qos,
  s_axi_awvalid => s_axi_m2s.aw.valid,
  s_axi_awready => s_axi_s2m.aw.ready,
  s_axi_wdata => s_axi_m2s.w.data(255 downto 0),
  s_axi_wstrb => s_axi_m2s.w.strb(31 downto 0),
  s_axi_wvalid => s_axi_m2s.w.valid,
  s_axi_wlast => s_axi_m2s.w.last,
  s_axi_wready => s_axi_s2m.w.ready,
  s_axi_bresp => s_axi_s2m.b.resp,
  s_axi_bvalid => s_axi_s2m.b.valid,
  s_axi_bready => s_axi_m2s.b.ready,
  s_axi_araddr => s_axi_araddr,
  s_axi_arlen => s_axi_m2s.ar.len,
  s_axi_arsize => s_axi_m2s.ar.size,
  s_axi_arburst => s_axi_m2s.ar.burst,
  s_axi_arlock => s_axi_m2s.ar.lock,
  s_axi_arcache => s_axi_m2s.ar.cache,
  s_axi_arprot => s_axi_m2s.ar.prot,
  s_axi_arregion => s_axi_m2s.ar.region,
  s_axi_arqos => s_axi_m2s.ar.qos,
  s_axi_arvalid => s_axi_m2s.ar.valid,
  s_axi_arready => s_axi_s2m.ar.ready,
  s_axi_rdata => s_axi_s2m.r.data(255 downto 0),
  s_axi_rresp => s_axi_s2m.r.resp,
  s_axi_rvalid => s_axi_s2m.r.valid,
  s_axi_rlast => s_axi_s2m.r.last,
  s_axi_rready => s_axi_m2s.r.ready,
  m_axi_awaddr => m_axi_awaddr,
  m_axi_awlen => m_axi_m2s.aw.len,
  m_axi_awsize => m_axi_m2s.aw.size,
  m_axi_awburst => m_axi_m2s.aw.burst,
  m_axi_awlock => m_axi_m2s.aw.lock,
  m_axi_awcache => m_axi_m2s.aw.cache,
  m_axi_awprot => m_axi_m2s.aw.prot,
  m_axi_awregion => m_axi_m2s.aw.region,
  m_axi_awqos => m_axi_m2s.aw.qos,
  m_axi_awvalid => m_axi_m2s.aw.valid,
  m_axi_awready => m_axi_s2m.aw.ready,
  m_axi_wdata => m_axi_m2s.w.data(31 downto 0),
  m_axi_wstrb => m_axi_m2s.w.strb(3 downto 0),
  m_axi_wvalid => m_axi_m2s.w.valid,
  m_axi_wlast => m_axi_m2s.w.last,
  m_axi_wready => m_axi_s2m.w.ready,
  m_axi_bresp => m_axi_s2m.b.resp,
  m_axi_bvalid => m_axi_s2m.b.valid,
  m_axi_bready => m_axi_m2s.b.ready,
  m_axi_araddr => m_axi_araddr,
  m_axi_arlen => m_axi_m2s.ar.len,
  m_axi_arsize => m_axi_m2s.ar.size,
  m_axi_arburst => m_axi_m2s.ar.burst,
  m_axi_arlock => m_axi_m2s.ar.lock,
  m_axi_arcache => m_axi_m2s.ar.cache,
  m_axi_arprot => m_axi_m2s.ar.prot,
  m_axi_arregion => m_axi_m2s.ar.region,
  m_axi_arqos => m_axi_m2s.ar.qos,
  m_axi_arvalid => m_axi_m2s.ar.valid,
  m_axi_arready => m_axi_s2m.ar.ready,
  m_axi_rdata => m_axi_s2m.r.data(31 downto 0),
  m_axi_rresp => m_axi_s2m.r.resp,
  m_axi_rvalid => m_axi_s2m.r.valid,
  m_axi_rlast => m_axi_s2m.r.last,
  m_axi_rready => m_axi_m2s.r.ready);
end architecture;
