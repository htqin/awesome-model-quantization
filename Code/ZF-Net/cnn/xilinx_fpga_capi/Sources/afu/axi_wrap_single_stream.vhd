
--------------------------------------------------------------------------------
--
-- Module Name      : axi_wrap_single_stream
--
--                    Copyright 2016 by
--                    Alpha Data Parallel Systems Ltd.
--                    All Rights Reserved.
--
-- Original Author  : Andrew McCormick
-- Created          : 27/4/16
--
-- Modified By      : 
-- Date             : 
-- Change Notes     :     
--
-- Description      : Very simple single wide stream example to test out
--                    CAPI to AXI4-MM and AXI-Stream AFU 
--                    
--
--
--
-- Dependencies     : 
--
-- Disclaimer       : THESE DESIGNS ARE PROVIDED "AS IS" WITH NO WARRANTY
--                    WHATSOEVER AND ALPHA DATA SPECIFICALLY DISCLAIMS ANY
--                    WARRANTIES IMPLIED OF MERCHANTABILITY, FITNESS FOR A
--                    PARTICULAR PURPOSE, OR AGAINST INFRINGEMENT.
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi_wrapper_if is

  port (
    clk            : in  std_logic;
    reset          : in  std_logic;
    wed_q_waiting : in std_logic;
    wed_q_continue : out std_logic;
    if_ctrl        : in  std_logic_vector(0 to 63);
    if_ctrl_wr     : in  std_logic_vector(0 to 1);
    if_status      : out std_logic_vector(0 to 63);
    if_status_rd   : in  std_logic_vector(0 to 1);
    user_ctrl      : in  std_logic_vector(0 to 127);
    user_ctrl_wr   : in  std_logic_vector(0 to 3);
    user_status    : out std_logic_vector(0 to 127);
    user_status_rd : in std_logic_vector(0 to 3);
    h2f_valid      : in  std_logic;
    h2f_seq_id     : in  std_logic_vector(0 to 31);
    h2f_wr_addr    : in  unsigned(0 to 63);
    h2f_wr_size    : in  unsigned(0 to 23);
    h2f_busy       : out std_logic;
    h2f_fifo_data  : in  std_logic_vector(0 to 511);
    h2f_fifo_radv  : out std_logic;
    h2f_fifo_level : in  std_logic_vector(0 to 9);
    h2f_fifo_empty : in  std_logic;
    f2h_valid      : in  std_logic;
    f2h_seq_id     : in  std_logic_vector(0 to 31);
    f2h_rd_addr    : in  unsigned(0 to 63);
    f2h_rd_size    : in  unsigned(0 to 23);
    f2h_busy       : out std_logic;
    f2h_fifo_data  : out std_logic_vector(0 to 511);
    f2h_fifo_wadv  : out std_logic;
    f2h_fifo_nfull : in  std_logic);

end entity axi_wrapper_if;

architecture rtl of axi_wrapper_if is

  signal aclk : std_logic;
  signal areset_n : std_logic;

  component axi_stream_cnn is
    port (
      aclk               : in  std_logic;
      areset_n           : in  std_logic;
      data_m_axis_tdata  : in  std_logic_vector(0 to 511);
      data_m_axis_tready : out std_logic;
      data_m_axis_tvalid : in  std_logic;
      data_s_axis_tdata  : out std_logic_vector(0 to 511);
      data_s_axis_tready : in  std_logic;
      data_s_axis_tvalid : out std_logic;
      ctrl0_m_axis_tdata  : in  std_logic_vector(0 to 31);
      ctrl0_m_axis_tready : out std_logic;
      ctrl0_m_axis_tvalid : in  std_logic;
      ctrl0_s_axis_tdata  : out std_logic_vector(0 to 31);
      ctrl0_s_axis_tready : in  std_logic;
      ctrl0_s_axis_tvalid : out std_logic;
      ctrl1_m_axis_tdata  : in  std_logic_vector(0 to 31);
      ctrl1_m_axis_tready : out std_logic;
      ctrl1_m_axis_tvalid : in  std_logic;
      ctrl1_s_axis_tdata  : out std_logic_vector(0 to 31);
      ctrl1_s_axis_tready : in  std_logic;
      ctrl1_s_axis_tvalid : out std_logic;
      wed_q_waiting : in std_logic;
      wed_q_continue : out std_logic;
      user_ctrl      : in  std_logic_vector(0 to 127);
      user_ctrl_wr   : in  std_logic_vector(0 to 3);
      user_status    : out std_logic_vector(0 to 127);
      user_status_rd : in std_logic_vector(0 to 3));
  end component axi_example_single_stream;

  signal data_m_axis_tdata   : std_logic_vector(0 to 511);
  signal data_m_axis_tready  : std_logic;
  signal data_m_axis_tvalid  : std_logic;
  signal data_s_axis_tdata   : std_logic_vector(0 to 511);
  signal data_s_axis_tready  : std_logic;
  signal data_s_axis_tvalid  : std_logic;
  signal ctrl0_m_axis_tdata  : std_logic_vector(0 to 31);
  signal ctrl0_m_axis_tready : std_logic;
  signal ctrl0_m_axis_tvalid : std_logic;
  signal ctrl0_s_axis_tdata  : std_logic_vector(0 to 31);
  signal ctrl0_s_axis_tready : std_logic;
  signal ctrl0_s_axis_tvalid : std_logic;
  signal ctrl1_m_axis_tdata  : std_logic_vector(0 to 31);
  signal ctrl1_m_axis_tready : std_logic;
  signal ctrl1_m_axis_tvalid : std_logic;
  signal ctrl1_s_axis_tdata  : std_logic_vector(0 to 31);
  signal ctrl1_s_axis_tready : std_logic;
  signal ctrl1_s_axis_tvalid : std_logic;
  
begin  -- architecture rtl

  aclk <= clk;
  areset_n <= not reset;

  f2h_busy <= '0';
  h2f_busy <= '0';

  
  -- Map full width data channel to single data streams
  data_m_axis_tdata <= h2f_fifo_data;
  data_m_axis_tvalid <= not h2f_fifo_empty;
  h2f_fifo_radv <= (not h2f_fifo_empty) and data_m_axis_tready;
  
  f2h_fifo_data <= data_s_axis_tdata;
  f2h_fifo_wadv <= data_s_axis_tvalid and (not f2h_fifo_nfull);
  data_s_axis_tready <= not f2h_fifo_nfull;

  -- Map 2 control streams to IF Control and IF Status registers
  ctrl0_m_axis_tdata <= if_ctrl(0 to 31);
  ctrl0_m_axis_tvalid <= if_ctrl_wr(0);
  if_status(0 to 31) <= ctrl0_s_axis_tdata;
  ctrl0_s_axis_tready <=if_status_rd(0);

  ctrl1_m_axis_tdata <= if_ctrl(32 to 63);
  ctrl1_m_axis_tvalid <= if_ctrl_wr(1);
  if_status(32 to 63) <= ctrl1_s_axis_tdata;
  ctrl1_s_axis_tready <= if_status_rd(1);

  -- N.B. m_axis_tvalid and s_axis_tready ignored on register control
  -- interfaces, i.e. FPGA cannot flow control these signals, must
  -- always accept data, and cannot stall reads.
  
  
  axi_example_single_stream_1: axi_stream_cnn
    port map (
      aclk                => aclk,
      areset_n            => areset_n,
      data_m_axis_tdata   => data_m_axis_tdata,
      data_m_axis_tready  => data_m_axis_tready,
      data_m_axis_tvalid  => data_m_axis_tvalid,
      data_s_axis_tdata   => data_s_axis_tdata,
      data_s_axis_tready  => data_s_axis_tready,
      data_s_axis_tvalid  => data_s_axis_tvalid,
      ctrl0_m_axis_tdata  => ctrl0_m_axis_tdata,
      ctrl0_m_axis_tready => ctrl0_m_axis_tready,
      ctrl0_m_axis_tvalid => ctrl0_m_axis_tvalid,
      ctrl0_s_axis_tdata  => ctrl0_s_axis_tdata,
      ctrl0_s_axis_tready => ctrl0_s_axis_tready,
      ctrl0_s_axis_tvalid => ctrl0_s_axis_tvalid,
      ctrl1_m_axis_tdata  => ctrl1_m_axis_tdata,
      ctrl1_m_axis_tready => ctrl1_m_axis_tready,
      ctrl1_m_axis_tvalid => ctrl1_m_axis_tvalid,
      ctrl1_s_axis_tdata  => ctrl1_s_axis_tdata,
      ctrl1_s_axis_tready => ctrl1_s_axis_tready,
      ctrl1_s_axis_tvalid => ctrl1_s_axis_tvalid,
      wed_q_waiting  => wed_q_waiting,
      wed_q_continue => wed_q_continue,
      user_ctrl           => user_ctrl,
      user_ctrl_wr        => user_ctrl_wr,
      user_status         => user_status,
      user_status_rd      => user_status_rd);
  
  

end architecture rtl;
