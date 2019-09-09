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
-- zfnet.vhd
-- CNN  based on ZFNet
-- Contains:
-- All ZFNet layers

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

-- synthesis translate_off
use std.textio.all; --  Imports the standard textio package.
-- synthesis translate_on

entity zfnet is
  generic (
    input_feature_width         : natural := 8;
    weight0_width                : natural := 8;
    weight1_width                : natural := 8;
    weight2_width                : natural := 8;
    weight3_width                : natural := 8;
    weight4_width                : natural := 8;
    weight5_width                : natural := 8;
    weight6_width                : natural := 8;
    weight7_width                : natural := 8;
    l01_width                    : natural := 8;
    l01_shift                    : natural := 0;
    l12_width                    : natural := 8;
    l12_shift                    : natural := 0;
    l23_width                    : natural := 8;
    l23_shift                    : natural := 0;
    l34_width                    : natural := 8;
    l34_shift                    : natural := 0;
    l45_width                    : natural := 8;
    l45_shift                    : natural := 0;
    l56_width                    : natural := 8;
    l56_shift                    : natural := 0;
    l67_width                    : natural := 8;
    l67_shift                    : natural := 0;
    output_width                : natural := 8;   
    output_shift                : natural := 0);   
  port (
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    input_feature_stream : in  std_logic_vector(3*input_feature_width-1 downto 0);
    input_feature_valid  : in  std_logic;
    input_feature_ready  : out std_logic;
    weight0_stream        : in  std_logic_vector(weight0_width-1 downto 0);
    weight0_id            : in  std_logic_vector(6 downto 0);
    weight0_first         : in  std_logic_vector(0 downto 0);
    weight0_last          : in  std_logic_vector(0 downto 0);
    weight1_stream        : in  std_logic_vector(weight1_width-1 downto 0);
    weight1_id            : in  std_logic_vector(8 downto 0);
    weight1_first         : in  std_logic_vector(0 downto 0);
    weight1_last          : in  std_logic_vector(0 downto 0);
    weight2_stream        : in  std_logic_vector(weight2_width-1 downto 0);
    weight2_id            : in  std_logic_vector(8 downto 0);
    weight2_first         : in  std_logic_vector(0 downto 0);
    weight2_last          : in  std_logic_vector(0 downto 0);
    weight3_stream        : in  std_logic_vector(weight3_width-1 downto 0);
    weight3_id            : in  std_logic_vector(8 downto 0);
    weight3_first         : in  std_logic_vector(0 downto 0);
    weight3_last          : in  std_logic_vector(0 downto 0);
    weight4_stream        : in  std_logic_vector(weight4_width-1 downto 0);
    weight4_id            : in  std_logic_vector(8 downto 0);
    weight4_first         : in  std_logic_vector(0 downto 0);
    weight4_last          : in  std_logic_vector(0 downto 0);
    weight5_stream        : in  std_logic_vector(weight5_width-1 downto 0);
    weight5_id            : in  std_logic_vector(12 downto 0);
    weight5_first         : in  std_logic_vector(0 downto 0);
    weight5_last          : in  std_logic_vector(0 downto 0);
    weight6_stream        : in  std_logic_vector(weight6_width-1 downto 0);
    weight6_id            : in  std_logic_vector(12 downto 0);
    weight6_first         : in  std_logic_vector(0 downto 0);
    weight6_last          : in  std_logic_vector(0 downto 0);
    weight7_stream        : in  std_logic_vector(weight7_width-1 downto 0);
    weight7_id            : in  std_logic_vector(10 downto 0);
    weight7_first         : in  std_logic_vector(0 downto 0);
    weight7_last          : in  std_logic_vector(0 downto 0);

    stream_out       : out std_logic_vector(output_width-1 downto 0);
    stream_out_valid : out std_logic;
    stream_out_ready : in  std_logic
    );

end entity;

architecture rtl of zfnet is

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


  component zfnet_layer_tdm is
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
      tdm_order                   : natural;
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
      weight_id            : in  std_logic_vector(tdm_order+layer_size_order-1 downto 0);
      weight_first         : in  std_logic_vector(no_par_layers-1 downto 0);
      weight_last          : in  std_logic_vector(no_par_layers-1 downto 0);
      stream_out           : out std_logic_vector(output_width*output_par_widen_factor*no_par_layers-1 downto 0);
      stream_out_valid     : out std_logic;
      stream_out_ready     : in  std_logic);
  end component zfnet_layer_tdm;

  signal l01_out : std_logic_vector(8*l01_width-1 downto 0);
  signal l01_out_valid : std_logic;
  signal l01_out_ready : std_logic;

  signal l12_out : std_logic_vector(l12_width-1 downto 0);
  signal l12_out_valid : std_logic;
  signal l12_out_ready : std_logic;

  signal l23_out : std_logic_vector(l23_width-1 downto 0);
  signal l23_out_valid : std_logic;
  signal l23_out_ready : std_logic;

  signal l34_out : std_logic_vector(l34_width-1 downto 0);
  signal l34_out_valid : std_logic;
  signal l34_out_ready : std_logic;

  signal l45_out : std_logic_vector(l45_width-1 downto 0);
  signal l45_out_valid : std_logic;
  signal l45_out_ready : std_logic;

  signal l56_out : std_logic_vector(l56_width-1 downto 0);
  signal l56_out_valid : std_logic;
  signal l56_out_ready : std_logic;

  signal l67_out : std_logic_vector(l67_width-1 downto 0);
  signal l67_out_valid : std_logic;
  signal l67_out_ready : std_logic;
  
begin


  
  zfnet_layer_0: zfnet_layer
    generic map (
      input_feature_width         => input_feature_width,
      input_no_feature_planes_par => 3,
      input_no_feature_planes_ser => 1,
      input_feature_plane_width   => 224,
      input_feature_plane_height  => 224,
      zero_pad_top                => 1,
      zero_pad_bottom             => 2,
      zero_pad_left               => 1,
      zero_pad_right              => 2,
      input_mask_width            => 7,
      input_mask_height           => 7,
      input_stride                => 2,
      narrow_buffer_depth         => 9,
      narrow_accept_space         => 50,
      no_par_layers               => 1,
      layer_size                  => 96,
      layer_size_order            => 7,
      weight_width                => weight0_width,
      weight_mem_order            => 8,
      output_width                => l01_width,
      output_shift                => l01_shift,
      ReLU                        => true,
      output_par_widen_factor     => 8,
      use_maxpool                 => true,
      maxpool_mask_width          => 3,
      maxpool_mask_height         => 3,
      maxpool_stride              => 2)
    port map (
      clk                  => clk,
      rst                  => rst,
      input_feature_stream => input_feature_stream,
      input_feature_valid  => input_feature_valid,
      input_feature_ready  => input_feature_ready,
      weight_stream        => weight0_stream,
      weight_id            => weight0_id,
      weight_first         => weight0_first,
      weight_last          => weight0_last,
      stream_out           => l01_out,
      stream_out_valid     => l01_out_valid,
      stream_out_ready     => l01_out_ready);

  zfnet_layer_1: zfnet_layer
    generic map (
      input_feature_width         => l01_width,
      input_no_feature_planes_par => 8,
      input_no_feature_planes_ser => 96/8,
      input_feature_plane_width   => 55,
      input_feature_plane_height  => 55,
      zero_pad_top                => 0,
      zero_pad_bottom             => 0,
      zero_pad_left               => 0,
      zero_pad_right              => 0,
      input_mask_width            => 5,
      input_mask_height           => 5,
      input_stride                => 2,
      narrow_buffer_depth         => 10,
      narrow_accept_space         => 301,
      no_par_layers               => 1,
      layer_size                  => 256,
      layer_size_order            => 9,
      weight_width                => weight1_width,
      weight_mem_order            => 12,
      output_width                => l12_width,
      output_shift                => l12_shift,
      ReLU                        => true,
      output_par_widen_factor     => 1,
      use_maxpool                 => true,
      maxpool_mask_width          => 3,
      maxpool_mask_height         => 3,
      maxpool_stride              => 2)
    port map (
      clk                  => clk,
      rst                  => rst,
      input_feature_stream => l01_out,
      input_feature_valid  => l01_out_valid,
      input_feature_ready  => l01_out_ready,
      weight_stream        => weight1_stream,
      weight_id            => weight1_id,
      weight_first         => weight1_first,
      weight_last          => weight1_last,
      stream_out           => l12_out,
      stream_out_valid     => l12_out_valid,
      stream_out_ready     => l12_out_ready);


  zfnet_layer_2: zfnet_layer_tdm
    generic map (
      input_feature_width         => l12_width,
      input_no_feature_planes_par => 1,
      input_no_feature_planes_ser => 256,
      input_feature_plane_width   => 13,
      input_feature_plane_height  => 13,
      zero_pad_top                => 1,
      zero_pad_bottom             => 1,
      zero_pad_left               => 1,
      zero_pad_right              => 1,
      input_mask_width            => 3,
      input_mask_height           => 3,
      input_stride                => 1,
      narrow_buffer_depth         => 13,
      narrow_accept_space         => 2305,
      no_par_layers               => 1,
      layer_size                  => 384/4,
      layer_size_order            => 7,
      tdm_order                   => 2,
      weight_width                => weight2_width,
      weight_mem_order            => 12,
      output_width                => l23_width,
      output_shift                => l23_shift,
      ReLU                        => true,
      output_par_widen_factor     => 1,
      use_maxpool                 => false,
      maxpool_mask_width          => 0,
      maxpool_mask_height         => 0,
      maxpool_stride              => 0)
    port map (
      clk                  => clk,
      rst                  => rst,
      input_feature_stream => l12_out,
      input_feature_valid  => l12_out_valid,
      input_feature_ready  => l12_out_ready,
      weight_stream        => weight2_stream,
      weight_id            => weight2_id,
      weight_first         => weight2_first,
      weight_last          => weight2_last,
      stream_out           => l23_out,
      stream_out_valid     => l23_out_valid,
      stream_out_ready     => l23_out_ready);

  zfnet_layer_3: zfnet_layer_tdm
    generic map (
      input_feature_width         => l23_width,
      input_no_feature_planes_par => 1,
      input_no_feature_planes_ser => 384,
      input_feature_plane_width   => 13,
      input_feature_plane_height  => 13,
      zero_pad_top                => 1,
      zero_pad_bottom             => 1,
      zero_pad_left               => 1,
      zero_pad_right              => 1,
      input_mask_width            => 3,
      input_mask_height           => 3,
      input_stride                => 1,
      narrow_buffer_depth         => 13,
      narrow_accept_space         => 3457,
      no_par_layers               => 1,
      layer_size                  => 384/4,
      layer_size_order            => 7,
      tdm_order                   => 2,
      weight_width                => weight3_width,
      weight_mem_order            => 12,
      output_width                => l34_width,
      output_shift                => l34_shift,
      ReLU                        => true,
      output_par_widen_factor     => 1,
      use_maxpool                 => false,
      maxpool_mask_width          => 0,
      maxpool_mask_height         => 0,
      maxpool_stride              => 0)
    port map (
      clk                  => clk,
      rst                  => rst,
      input_feature_stream => l23_out,
      input_feature_valid  => l23_out_valid,
      input_feature_ready  => l23_out_ready,
      weight_stream        => weight3_stream,
      weight_id            => weight3_id,
      weight_first         => weight3_first,
      weight_last          => weight3_last,
      stream_out           => l34_out,
      stream_out_valid     => l34_out_valid,
      stream_out_ready     => l34_out_ready);


   zfnet_layer_4: zfnet_layer_tdm
    generic map (
      input_feature_width         => l34_width,
      input_no_feature_planes_par => 1,
      input_no_feature_planes_ser => 384,
      input_feature_plane_width   => 13,
      input_feature_plane_height  => 13,
      zero_pad_top                => 1,
      zero_pad_bottom             => 1,
      zero_pad_left               => 1,
      zero_pad_right              => 1,
      input_mask_width            => 3,
      input_mask_height           => 3,
      input_stride                => 1,
      narrow_buffer_depth         => 12,
      narrow_accept_space         => 2305,
      no_par_layers               => 1,
      layer_size                  => 256/4,
      layer_size_order            => 7,
      tdm_order                   => 2,
      weight_width                => weight4_width,
      weight_mem_order            => 12,
      output_width                => l45_width,
      output_shift                => l45_shift,
      ReLU                        => true,
      output_par_widen_factor     => 1,
      use_maxpool                 => true,
      maxpool_mask_width          => 3,
      maxpool_mask_height         => 3,
      maxpool_stride              => 2)
    port map (
      clk                  => clk,
      rst                  => rst,
      input_feature_stream => l34_out,
      input_feature_valid  => l34_out_valid,
      input_feature_ready  => l34_out_ready,
      weight_stream        => weight4_stream,
      weight_id            => weight4_id,
      weight_first         => weight4_first,
      weight_last          => weight4_last,
      stream_out           => l45_out,
      stream_out_valid     => l45_out_valid,
      stream_out_ready     => l45_out_ready);


  -- Fully Connected Layer
  zfnet_layer_5: zfnet_layer_tdm
    generic map (
      input_feature_width         => l45_width,
      input_no_feature_planes_par => 1,
      input_no_feature_planes_ser => 6*6*256,
      input_feature_plane_width   => 1,
      input_feature_plane_height  => 1,
      zero_pad_top                => 0,
      zero_pad_bottom             => 0,
      zero_pad_left               => 0,
      zero_pad_right              => 0,
      input_mask_width            => 1,
      input_mask_height           => 1,
      input_stride                => 1,
      narrow_buffer_depth         => 14,
      narrow_accept_space         => 9217,
      no_par_layers               => 1,
      layer_size                  => 4096/128,
      layer_size_order            => 6,
      tdm_order                   => 7,
      weight_width                => weight5_width,
      weight_mem_order            => 14,
      output_width                => l56_width,
      output_shift                => l56_shift,
      ReLU                        => true,
      output_par_widen_factor     => 1,
      use_maxpool                 => false,
      maxpool_mask_width          => 0,
      maxpool_mask_height         => 0,
      maxpool_stride              => 0)
    port map (
      clk                  => clk,
      rst                  => rst,
      input_feature_stream => l45_out,
      input_feature_valid  => l45_out_valid,
      input_feature_ready  => l45_out_ready,
      weight_stream        => weight5_stream,
      weight_id            => weight5_id,
      weight_first         => weight5_first,
      weight_last          => weight5_last,
      stream_out           => l56_out,
      stream_out_valid     => l56_out_valid,
      stream_out_ready     => l56_out_ready);

   -- Fully Connected Layer
  zfnet_layer_6: zfnet_layer_tdm
    generic map (
      input_feature_width         => l56_width,
      input_no_feature_planes_par => 1,
      input_no_feature_planes_ser => 4096,
      input_feature_plane_width   => 1,
      input_feature_plane_height  => 1,
      zero_pad_top                => 0,
      zero_pad_bottom             => 0,
      zero_pad_left               => 0,
      zero_pad_right              => 0,
      input_mask_width            => 1,
      input_mask_height           => 1,
      input_stride                => 1,
      narrow_buffer_depth         => 13,
      narrow_accept_space         => 4097,
      no_par_layers               => 1,
      layer_size                  => 4096/128,
      layer_size_order            => 6,
      tdm_order                   => 7,
      weight_width                => weight6_width,
      weight_mem_order            => 13,
      output_width                => l67_width,
      output_shift                => l67_shift,
      ReLU                        => true,
      output_par_widen_factor     => 1,
      use_maxpool                 => false,
      maxpool_mask_width          => 0,
      maxpool_mask_height         => 0,
      maxpool_stride              => 0)
    port map (
      clk                  => clk,
      rst                  => rst,
      input_feature_stream => l56_out,
      input_feature_valid  => l56_out_valid,
      input_feature_ready  => l56_out_ready,
      weight_stream        => weight6_stream,
      weight_id            => weight6_id,
      weight_first         => weight6_first,
      weight_last          => weight6_last,
      stream_out           => l67_out,
      stream_out_valid     => l67_out_valid,
      stream_out_ready     => l67_out_ready);

  -- Fully Connected "Softmax" Layer
  zfnet_layer_7: zfnet_layer_tdm
    generic map (
      input_feature_width         => l67_width,
      input_no_feature_planes_par => 1,
      input_no_feature_planes_ser => 4096,
      input_feature_plane_width   => 1,
      input_feature_plane_height  => 1,
      zero_pad_top                => 0,
      zero_pad_bottom             => 0,
      zero_pad_left               => 0,
      zero_pad_right              => 0,
      input_mask_width            => 1,
      input_mask_height           => 1,
      input_stride                => 1,
      narrow_buffer_depth         => 13,
      narrow_accept_space         => 4097,
      no_par_layers               => 1,
      layer_size                  => 1024/128,
      layer_size_order            => 4,
      tdm_order                   => 7,
      weight_width                => weight7_width,
      weight_mem_order            => 13,
      output_width                => output_width,
      output_shift                => output_shift,
      ReLU                        => false,
      output_par_widen_factor     => 1,
      use_maxpool                 => false,
      maxpool_mask_width          => 0,
      maxpool_mask_height         => 0,
      maxpool_stride              => 0)
    port map (
      clk                  => clk,
      rst                  => rst,
      input_feature_stream => l67_out,
      input_feature_valid  => l67_out_valid,
      input_feature_ready  => l67_out_ready,
      weight_stream        => weight7_stream,
      weight_id            => weight7_id,
      weight_first         => weight7_first,
      weight_last          => weight7_last,
      stream_out           => stream_out,
      stream_out_valid     => stream_out_valid,
      stream_out_ready     => stream_out_ready);
  
end architecture;
