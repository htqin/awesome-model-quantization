
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VCOMPONENTS.all;

library work;
use work.axi4_field.all;
use work.axi4_profile.all;
use work.axi4l_profile.all;

entity admpcie8k5_cnn_top is
  port (
    model_inout_tri_io : inout std_logic_vector (45 downto 0);
    pci_exp_rxn        : in    std_logic_vector (7 downto 0);
    pci_exp_rxp        : in    std_logic_vector (7 downto 0);
    pci_exp_txn        : out   std_logic_vector (7 downto 0);
    pci_exp_txp        : out   std_logic_vector (7 downto 0);
    pcie100_n      : in    std_logic;
    pcie100_p      : in    std_logic;
    perst_n            : in    std_logic;
    refclk200          : in    std_logic
    );
end admpcie8k5_cnn_top;

architecture STRUCTURE of admpcie8k5_cnn_top is

  component zfnet_layer is
    generic (
      input_feature_width         : natural;
      input_no_feature_planes_par : natural;
      input_no_feature_planes_ser : natural;
      input_feature_plane_width   : natural;
      input_feature_plane_height  : natural;
      zero_pad_top                : natural;
      zero_pad_bottom             : natural;
      zero_pad_left               : natural;
      zero_pad_right              : natural;
      input_mask_width            : natural;
      input_mask_height           : natural;
      input_stride                : natural;
      narrow_buffer_depth         : natural;
      narrow_accept_space         : natural;
      no_par_layers               : natural;
      layer_size                  : natural;
      layer_size_order            : natural;
      weight_width                : natural;
      weight_mem_order            : natural;
      output_width                : natural;
      output_shift                : natural;
      ReLU                        : boolean;
      output_par_widen_factor     : natural;
      use_maxpool                 : boolean;
      maxpool_mask_width          : natural;
      maxpool_mask_height         : natural;
      maxpool_stride              : natural);
    port (
      clk                  : in  std_logic;
      rst                  : in  std_logic;
      input_feature_stream : in  std_logic_vector(input_feature_width*input_no_feature_planes_par-1 downto 0);
      input_feature_valid  : in  std_logic;
      input_feature_ready  : out std_logic;
      weight_stream        : in  std_logic_vector(weight_width-1 downto 0);
      weight_id            : in  std_logic_vector(layer_size_order-1 downto 0);
      weight_first         : in  std_logic_vector(no_par_layers-1 downto 0);
      weight_last          : in  std_logic_vector(no_par_layers-1 downto 0);
      stream_out           : out std_logic_vector(output_width*output_par_widen_factor*no_par_layers-1 downto 0);
      stream_out_valid     : out std_logic;
      stream_out_ready     : in  std_logic);
  end component zfnet_layer;

  component adb3_admpcie8k5_x8_axi4_0_wrap is
    port (
      perst_n            : in  std_logic;
      pcie100_p          : in  std_logic;
      pcie100_n          : in  std_logic;
      refclk200_in       : in  std_logic;
      aclk               : out std_logic;
      aresetn            : out std_logic;
      pci_exp_txn        : out std_logic_vector(7 downto 0);
      pci_exp_txp        : out std_logic_vector(7 downto 0);
      pci_exp_rxn        : in  std_logic_vector(7 downto 0);
      pci_exp_rxp        : in  std_logic_vector(7 downto 0);
      model_inout_i      : in  std_logic_vector(45 downto 0);
      model_inout_o      : out std_logic_vector(45 downto 0);
      model_inout_t      : out std_logic_vector(45 downto 0);
      dma0_m_axis_tdata  : out std_logic_vector(255 downto 0);
      dma0_m_axis_tready : in  std_logic;
      dma0_m_axis_tvalid : out std_logic;
      dma1_s_axis_tdata  : in  std_logic_vector(255 downto 0);
      dma1_s_axis_tready : out std_logic;
      dma1_s_axis_tvalid : in  std_logic;
      dma2_m_axis_tdata  : out std_logic_vector(255 downto 0);
      dma2_m_axis_tready : in  std_logic;
      dma2_m_axis_tvalid : out std_logic;
      core_status        : out std_logic_vector(63 downto 0);
      ds_axi_m2s         : out axi4_256_m2s_t := axi4_256_m2s_default;
      ds_axi_s2m         : in  axi4_256_s2m_t := axi4_256_s2m_default);
  end component adb3_admpcie8k5_x8_axi4_0_wrap;

  component stream_narrow_32to3 is
    port (
      clk              : in  std_logic;
      rst              : in  std_logic;
      stream_in        : in  std_logic_vector(255 downto 0);
      stream_in_valid  : in  std_logic;
      stream_in_ready  : out std_logic;
      stream_out       : out std_logic_vector(23 downto 0);
      stream_out_valid : out std_logic;
      stream_out_ready : in  std_logic);
  end component stream_narrow_32to3;


  component stream_narrow_weights is
  generic (
    stream_width         : natural;
    stream_in_multiplier : natural;
    weight_depth         : natural;
    no_weights           : natural;
    weight_padding       : natural;
    weight_id_size       : natural;
    no_ids               : natural;
    buffer_depth         : natural;
    buffer_accept_space  : natural);
  port (
    clk             : in  std_logic;
    rst             : in  std_logic;
    stream_in       : in  std_logic_vector(stream_width*stream_in_multiplier-1 downto 0);
    stream_in_valid : in  std_logic;
    stream_in_ready : out std_logic;
    weight_out      : out std_logic_vector(stream_width-1 downto 0);
    weight_id       : out std_logic_vector(weight_id_size-1 downto 0);
    weight_first    : out std_logic;
    weight_last     : out std_logic);
end component stream_narrow_weights;


  component stream_widen is
    generic (
      stream_width          : natural;
      stream_out_multiplier : natural);
    port (
      clk              : in  std_logic;
      rst              : in  std_logic;
      stream_in        : in  std_logic_vector(stream_width-1 downto 0);
      stream_in_valid  : in  std_logic;
      stream_in_first  : in  std_logic;
      stream_in_last   : in  std_logic;
      stream_out       : out std_logic_vector(stream_width*stream_out_multiplier-1 downto 0);
      stream_out_valid : out std_logic;
      stream_out_first : out std_logic;
      stream_out_last  : out std_logic);
  end component stream_widen;

  signal feature_stream : std_logic_vector(23 downto 0);
  signal feature_valid  : std_logic;
  signal feature_ready  : std_logic;

  signal weight_stream : std_logic_vector(7 downto 0);
  signal weight_id     : std_logic_vector(6 downto 0);
  signal weight_first  : std_logic_vector(0 downto 0);
  signal weight_last   : std_logic_vector(0 downto 0);
  signal weight_valid   : std_logic;

  
  signal stream_out       : std_logic_vector(63 downto 0);
  signal stream_out_valid : std_logic;
  signal stream_out_ready : std_logic;

  signal rst,clk : std_logic;

  signal aclk    : std_logic;
  signal aresetn : std_logic;

  signal model_inout_i      : std_logic_vector(45 downto 0);
  signal model_inout_o      : std_logic_vector(45 downto 0);
  signal model_inout_t      : std_logic_vector(45 downto 0);
  signal dma0_m_axis_tdata  : std_logic_vector(255 downto 0);
  signal dma0_m_axis_tready : std_logic;
  signal dma0_m_axis_tvalid : std_logic;
  signal dma1_s_axis_tdata  : std_logic_vector(255 downto 0);
  signal dma1_s_axis_tready : std_logic;
  signal dma1_s_axis_tvalid : std_logic;
  signal dma2_m_axis_tdata  : std_logic_vector(255 downto 0);
  signal dma2_m_axis_tready : std_logic;
  signal dma2_m_axis_tvalid : std_logic;
  signal core_status        : std_logic_vector(63 downto 0);
  signal ds_axi_m2s         : axi4_256_m2s_t := axi4_256_m2s_default;
  signal ds_axi_s2m         : axi4_256_s2m_t := axi4_256_s2m_default;

  signal ds32_axi_m2s : axi4_32_m2s_t := axi4_32_m2s_default;
  signal ds32_axi_s2m : axi4_32_s2m_t := axi4_32_s2m_default;
  signal reg_axi_m2s  : axi4l_32_m2s_t;
  signal reg_axi_s2m  : axi4l_32_s2m_t;


  constant number_of_axil_regs : natural := 8;

  signal status_regs_in   : std_logic_vector(32*number_of_axil_regs-1 downto 0) := (others => '0');
  signal control_regs_out : std_logic_vector(32*number_of_axil_regs-1 downto 0) := (others => '0');

  type reg_array_type is array (0 to number_of_axil_regs-1) of std_logic_vector(31 downto 0);
  signal control_regs : reg_array_type := (others => (others => '0'));
  signal status_regs  : reg_array_type := (others => (others => '0'));

  signal dma0_count,dma1_count,dma2_count : unsigned(31 downto 0) := (others => '0');
  signal in_count, out_count, ov_count : unsigned(31 downto 0) := (others => '0');
  
  
begin


  zfnet_layer_1 : zfnet_layer
    generic map (
      input_feature_width         => 8,
      input_no_feature_planes_par => 3,
      input_no_feature_planes_ser => 1,
      input_feature_plane_width   => 224,
      input_feature_plane_height  => 224,
      zero_pad_top                => 2,
      zero_pad_bottom             => 1,
      zero_pad_left               => 2,
      zero_pad_right              => 1,
      input_mask_width            => 7,
      input_mask_height           => 7,
      input_stride                => 2,
      narrow_buffer_depth         => 10,
      narrow_accept_space         => 256,
      no_par_layers               => 1,
      layer_size                  => 96,
      layer_size_order            => 7,
      weight_width                => 8,
      weight_mem_order            => 8,
      output_width                => 8,
      output_shift                => 0,
      ReLU                        => true,
      output_par_widen_factor     => 8,
      use_maxpool                 => true,
      maxpool_mask_width          => 3,
      maxpool_mask_height         => 3,
      maxpool_stride              => 2)
    port map (
      clk                  => clk,
      rst                  => rst,
      input_feature_stream => feature_stream,
      input_feature_valid  => feature_valid,
      input_feature_ready  => feature_ready,
      weight_stream        => weight_stream,
      weight_id            => weight_id,
      weight_first         => weight_first,
      weight_last          => weight_last,
      stream_out           => stream_out,
      stream_out_valid     => stream_out_valid,
      stream_out_ready     => stream_out_ready);

  stream_narrow_32to3_1 : stream_narrow_32to3
    port map (
      clk              => clk,
      rst              => rst,
      stream_in        => dma0_m_axis_tdata,
      stream_in_valid  => dma0_m_axis_tvalid,
      stream_in_ready  => dma0_m_axis_tready,
      stream_out       => feature_stream,
      stream_out_valid => feature_valid,
      stream_out_ready => feature_ready);


  stream_narrow_weights_1: stream_narrow_weights
  generic map (
    stream_width         => 8,
    stream_in_multiplier => 32,
    weight_depth         => 8,
    no_weights           => 7*7*3,
    weight_padding       => 12,
    weight_id_size       => 7,
    no_ids               => 96,
    buffer_depth         => 5,
    buffer_accept_space  => 8)
  port map (
    clk             => clk,
    rst             => rst,
    stream_in       => dma2_m_axis_tdata,
    stream_in_valid => dma2_m_axis_tvalid,
    stream_in_ready => dma2_m_axis_tready,
    weight_out      => weight_stream,
    weight_id       => weight_id,
    weight_first    => weight_first(0),
    weight_last     => weight_last(0));
  


  output_stream_widen_1 : stream_widen
    generic map (
      stream_width          => 64,
      stream_out_multiplier => 4)
    port map (
      clk              => clk,
      rst              => rst,
      stream_in        => stream_out,
      stream_in_valid  => stream_out_valid,
      stream_in_first  => '0',
      stream_in_last   => '0',
      stream_out       => dma1_s_axis_tdata,
      stream_out_valid => dma1_s_axis_tvalid,
      stream_out_first => open,
      stream_out_last  => open);
  stream_out_ready <= dma1_s_axis_tready;

  adb3_admpcie8k5_x8_axi4_0_wrap_1 : adb3_admpcie8k5_x8_axi4_0_wrap
    port map (
      perst_n            => perst_n,
      pcie100_p          => pcie100_p,
      pcie100_n          => pcie100_n,
      refclk200_in       => refclk200,
      aclk               => aclk,
      aresetn            => aresetn,
      pci_exp_txn        => pci_exp_txn,
      pci_exp_txp        => pci_exp_txp,
      pci_exp_rxn        => pci_exp_rxn,
      pci_exp_rxp        => pci_exp_rxp,
      model_inout_i      => model_inout_i,
      model_inout_o      => model_inout_o,
      model_inout_t      => model_inout_t,
      dma0_m_axis_tdata  => dma0_m_axis_tdata,
      dma0_m_axis_tready => dma0_m_axis_tready,
      dma0_m_axis_tvalid => dma0_m_axis_tvalid,
      dma1_s_axis_tdata  => dma1_s_axis_tdata,
      dma1_s_axis_tready => dma1_s_axis_tready,
      dma1_s_axis_tvalid => dma1_s_axis_tvalid,
      dma2_m_axis_tdata  => dma2_m_axis_tdata,
      dma2_m_axis_tready => dma2_m_axis_tready,
      dma2_m_axis_tvalid => dma2_m_axis_tvalid,
      core_status        => core_status,
      ds_axi_m2s         => ds_axi_m2s,
      ds_axi_s2m         => ds_axi_s2m);


  axi_dwidth_converter_1_wrap_1 : entity work.axi_dwidth_converter_1_wrap
    port map (
      s_axi_aclk    => aclk,
      s_axi_aresetn => aresetn,
      s_axi_m2s     => ds_axi_m2s,
      s_axi_s2m     => ds_axi_s2m,
      m_axi_m2s     => ds32_axi_m2s,
      m_axi_s2m     => ds32_axi_s2m);

  axi_protocol_converter_0_wrap_1 : entity work.axi_protocol_converter_0_wrap
    port map (
      aclk      => aclk,
      aresetn   => aresetn,
      s_axi_m2s => ds32_axi_m2s,
      s_axi_s2m => ds32_axi_s2m,
      m_axi_m2s => reg_axi_m2s,
      m_axi_s2m => reg_axi_s2m);

  reg_bank_axi4l_wrap_1 : entity work.reg_bank_axi4l_wrap
    generic map (
      number_of_axil_regs => number_of_axil_regs)
    port map (
      aclk             => aclk,
      aresetn          => aresetn,
      reg_axi_m2s      => reg_axi_m2s,
      reg_axi_s2m      => reg_axi_s2m,
      status_regs_in   => status_regs_in,
      control_regs_out => control_regs_out);

  -- remap large std_logic_vector to array of 32 bit regs
  gen_reg_array0 : for i in 0 to number_of_axil_regs-1 generate
    status_regs_in(32*i+31 downto 32*i) <= status_regs(i);
    control_regs(i)                     <= control_regs_out(32*i+31 downto 32*i);
  end generate;  --


  clk <= aclk;
  
  status_regs0: process(clk)
  begin
    if rising_edge(clk) then
      rst <= control_regs(0)(0) or not aresetn;
      status_regs(0) <= control_regs(0);

      status_regs(1) <= std_logic_vector(dma0_count);
      status_regs(2) <= std_logic_vector(dma1_count);
      status_regs(3) <= std_logic_vector(dma2_count);
      status_regs(4) <= std_logic_vector(in_count);
      status_regs(5) <= std_logic_vector(out_count);
      status_regs(6) <= std_logic_vector(ov_count);
      status_regs(7) <=(others => '0'); 
  
      if dma0_m_axis_tready = '1' and dma0_m_axis_tvalid = '1' then
        dma0_count <= dma0_count+1;
      end if;
      if dma1_s_axis_tready = '1' and dma1_s_axis_tvalid = '1' then
        dma1_count <= dma1_count+1;
      end if;
      if dma2_m_axis_tready = '1' and dma2_m_axis_tvalid = '1' then
        dma2_count <= dma2_count+1;
      end if;
      if feature_valid = '1' and feature_ready ='1' then
        in_count <= in_count+1;
      end if;
      if stream_out_valid = '1' and stream_out_ready ='1' then
        out_count <= out_count+1;
      end if;
      if stream_out_valid = '1' and stream_out_ready ='0' then
        ov_count <= ov_count+1;
      end if;
      
      
      if rst = '1' then
        dma0_count <= (others => '0');
        dma1_count <= (others => '0');
        dma2_count <= (others => '0');
        in_count <= (others => '0');
        out_count <= (others => '0');
        ov_count <= (others => '0');
      end if;
    end if;
  end process;
    
  gen_iob : for i in 0 to 45 generate
    model_inout_tri_iobuf_i : component IOBUF
      port map (
        I  => model_inout_o(i),
        IO => model_inout_tri_io(i),
        O  => model_inout_i(i),
        T  => model_inout_t(i)
        );
  end generate;
  
end STRUCTURE;
