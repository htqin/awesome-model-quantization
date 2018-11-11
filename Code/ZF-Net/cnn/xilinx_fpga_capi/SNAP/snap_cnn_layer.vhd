

--------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity snap_cnn_layer is

  port (
    aclk                : in  std_logic;
    areset_n            : in  std_logic;
    -- Data stream
    data_m_axis_tdata   : in  std_logic_vector(511 downto 0);
    data_m_axis_tready  : out std_logic;
    data_m_axis_tvalid  : in  std_logic;
    data_s_axis_tdata   : out std_logic_vector(511 downto 0);
    data_s_axis_tready  : in  std_logic;
    data_s_axis_tvalid  : out std_logic;
    -- Weights stream
    weight_m_axis_tdata  : in  std_logic_vector(511 downto 0);
    weight_m_axis_tready : out std_logic;
    weight_m_axis_tvalid : in  std_logic;
    user_status         : out std_logic_vector(127 downto 0));

end entity snap_cnn_layer;

architecture rtl of snap_cnn_layer is

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
  
  component stream_narrow_64to3 is
    port (
      clk              : in  std_logic;
      rst              : in  std_logic;
      stream_in        : in  std_logic_vector(511 downto 0);
      stream_in_valid  : in  std_logic;
      stream_in_ready  : out std_logic;
      stream_out       : out std_logic_vector(23 downto 0);
      stream_out_valid : out std_logic;
      stream_out_ready : in  std_logic);
  end component stream_narrow_64to3;


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
 

  signal in_count, out_count, ov_count : unsigned(31 downto 0) := (others => '0');
  
begin  -- architecture rtl

clk <= aclk;
rst <=not areset_n;


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

  stream_narrow_64to3_1 : stream_narrow_64to3
    port map (
      clk              => clk,
      rst              => rst,
      stream_in        => data_m_axis_tdata,
      stream_in_valid  => data_m_axis_tvalid,
      stream_in_ready  => data_m_axis_tready,
      stream_out       => feature_stream,
      stream_out_valid => feature_valid,
      stream_out_ready => feature_ready);


  stream_narrow_weights_1: stream_narrow_weights
  generic map (
    stream_width         => 8,
    stream_in_multiplier => 64,
    weight_depth         => 8,
    no_weights           => 7*7*3,
    weight_padding       => 48,
    weight_id_size       => 7,
    no_ids               => 96,
    buffer_depth         => 9,
    buffer_accept_space  => 32)
  port map (
    clk             => clk,
    rst             => rst,
    stream_in       => weight_m_axis_tdata,
    stream_in_valid => weight_m_axis_tvalid,
    stream_in_ready => weight_m_axis_tready,
    weight_out      => weight_stream,
    weight_id       => weight_id,
    weight_first    => weight_first(0),
    weight_last     => weight_last(0));
  


  output_stream_widen_1 : stream_widen
    generic map (
      stream_width          => 64,
      stream_out_multiplier => 8)
    port map (
      clk              => clk,
      rst              => rst,
      stream_in        => stream_out,
      stream_in_valid  => stream_out_valid,
      stream_in_first  => '0',
      stream_in_last   => '0',
      stream_out       => data_s_axis_tdata,
      stream_out_valid => data_s_axis_tvalid,
      stream_out_first => open,
      stream_out_last  => open);
  stream_out_ready <= data_s_axis_tready;





  
  reg_proc: process (aclk) is
 
  begin  -- process aclk
    if rising_edge(aclk) then           -- rising clock edge

      user_status(31 downto 0) <= std_logic_vector(in_count);
      user_status(63 downto 32) <= std_logic_vector(out_count);
      user_status(95 downto 64) <= std_logic_vector(ov_count);
      user_status(127 downto 96) <= X"00000000";


      if feature_valid = '1' and feature_ready ='1' then
        in_count <= in_count+1;
      end if;
      if stream_out_valid = '1' and stream_out_ready ='1' then
        out_count <= out_count+1;
      end if;
      if stream_out_valid = '1' and stream_out_ready ='0' then
        ov_count <= ov_count+1;
      end if;

      if areset_n = '0' then
        in_count <= (others => '0');
        out_count <= (others => '0');
        ov_count <= (others => '0');
      end if;
    end if;
  end process reg_proc;
  
  
  
end architecture rtl;
