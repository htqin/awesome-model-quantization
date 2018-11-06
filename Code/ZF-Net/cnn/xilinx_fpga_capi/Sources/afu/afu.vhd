
--------------------------------------------------------------------------------
--
-- Module Name      : afu
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
-- Description      : Top Level AFU for interfacing between CAPI
--                    PSL interface either Streaming Type AXIS interfaces
--                    or Memory Mapped AXI4 interfaces depending on the
--                    chosen wrapper interface sub module
--                     
--                    Allows a WED Queue to push chunks or data to and from
--                    the submodule.  WED optionally contains AXI4 address
--                    to be used by sub-module.
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


entity afu is

    port (
        -- Command Interface
        ah_cvalid  : out std_logic;
        ah_ctag    : out std_logic_vector(0 to 7);
        ah_ctagpar : out std_logic;
        ah_com     : out std_logic_vector(0 to 12);
        ah_compar  : out std_logic;
        ah_cabt    : out std_logic_vector(0 to 2);
        ah_cea     : out unsigned(0 to 63);
        ah_ceapar  : out std_logic;
        ah_cch     : out std_logic_vector(0 to 15);
        ah_csize   : out unsigned(0 to 11);
        ha_croom   : in  unsigned(0 to 7);

        -- Response Interface
        ha_rvalid      : in std_logic;
        ha_rtag        : in std_logic_vector(0 to 7);
        ha_rtagpar     : in std_logic;
        ha_response    : in std_logic_vector(0 to 7);
        ha_rcredits    : in signed(0 to 8);
        ha_rcachestate : in std_logic_vector(0 to 1);
        ha_rcachepos   : in std_logic_vector(0 to 12);

        -- Buffer Interface
        ha_brvalid  : in  std_logic;
        ha_brtag    : in  std_logic_vector(0 to 7);
        ha_brtagpar : in  std_logic;
        ha_brad     : in  unsigned(0 to 5);
        ah_brlat    : out std_logic_vector(0 to 3);
        ah_brdata   : out std_logic_vector(0 to 511);
        ah_brpar    : out std_logic_vector(0 to 7);
        ha_bwvalid  : in  std_logic;
        ha_bwtag    : in  std_logic_vector(0 to 7);
        ha_bwtagpar : in  std_logic;
        ha_bwad     : in  unsigned(0 to 5);
        ha_bwdata   : in  std_logic_vector(0 to 511);
        ha_bwpar    : in  std_logic_vector(0 to 7);

        -- MMIO Interface
        ha_mmval     : in  std_logic;
        ha_mmcfg     : in  std_logic;
        ha_mmrnw     : in  std_logic;
        ha_mmdw      : in  std_logic;
        ha_mmad      : in  unsigned(0 to 23);
        ha_mmadpar   : in  std_logic;
        ha_mmdata    : in  std_logic_vector(0 to 63);
        ha_mmdatapar : in  std_logic;
        ah_mmack     : out std_logic;
        ah_mmdata    : out std_logic_vector(0 to 63);
        ah_mmdatapar : out std_logic;

        -- Control Interface
        ha_jval : in std_logic;
        ha_jcom : in std_logic_vector(0 to 7);
        ha_jcompar : in std_logic;
        ha_jea : in unsigned(0 to 63);
        ha_jeapar : in std_logic;
        ah_jrunning : out std_logic := '0';
        ah_jdone : out std_logic := '0';
        ah_jcack : out std_logic := '0';
        ah_jerror : out std_logic_vector(0 to 63) := (others=>'0');
        ah_jyield : out std_logic := '0';
        ah_tbreq  : out std_logic := '0';
        ah_paren  : out std_logic := '1';
        ha_pclock : in std_logic
        );

end entity afu;

architecture rtl of afu is

 
  
  signal reset  : std_logic := '0';
  signal start : std_logic  := '0';

  signal ah_cvalid_i : std_logic;
  signal ah_ctag_i   : std_logic_vector(ah_ctag'range);
  signal ah_ctagpar_i   : std_logic;
  signal ah_com_i    : std_logic_vector(ah_com'range);
  signal ah_compar_i    : std_logic;
  signal ah_cea_i    : unsigned(ah_cea'range);
  signal ah_ceapar_i    : std_logic;
  signal ah_csize_i  : unsigned(ah_csize'range);

  signal ah_brdata_i   : std_logic_vector(0 to 511);
  signal ah_brpar_i    : std_logic_vector(0 to 7);
  
  signal timer : unsigned(0 to 63);

  signal wed_base_addr : unsigned(0 to 63);

  signal return_address : unsigned(0 to 63);
  
  signal ah_jdone_next    : std_logic;

  signal wqueue_done      : std_logic;
  signal wqueue_done_last : std_logic;


  signal mmack : std_logic;
  signal mmval : std_logic;
  signal mmdata : std_logic_vector(0 to 63);
  signal mmdata_i : std_logic_vector(0 to 63);
  signal mmad : unsigned(0 to 23);
  
  signal cfg_rdata : std_logic_vector(0 to 63);
  
  signal cfg_read    : std_logic;
  signal cfg_read_d  : std_logic;
  signal cfg_write   : std_logic;
  signal mmio_read   : std_logic;
  signal mmio_read_d   : std_logic;
  signal mmio_write  : std_logic;
  signal mmdw     : std_logic;
  signal mmdw_d   : std_logic;
  
  signal ha_brvalid_r1,ha_brvalid_r2 : std_logic;
  
  function calc_parity (
    x : std_logic_vector)
    return std_logic
  is
    variable ret : std_logic := '0';
  begin
    ret := '1';
    for i in x'range loop
      ret := ret xor x(i);
    end loop;
    return ret;
  end function;

  function calc_parity (
    x : unsigned)
    return std_logic
  is
  begin
    return calc_parity(std_logic_vector(x));
  end function;

  function endian_byteswap64 (
    x : std_logic_vector(0 to 63))
    return std_logic_vector(0 to 63)
  is
    variable y : std_logic_vector(0 to 63);
  begin
    for i in 0 to 7 loop
      y(i*8 to i*8+7) := x((7-i)*8 to (7-i)*8+7);
    end loop;  -- i  
    return y;
  end function;
  

 
  signal clk : std_logic;
 
   
  constant PSL_CTRL_CMD_START : std_logic_vector(0 to 7) := x"90";
  constant PSL_CTRL_CMD_RESET : std_logic_vector(0 to 7) := x"80";


  signal wed_tag,rd_data_tag,wr_data_tag,wr_status_tag : unsigned(0 to 4);
  signal cmd_queue_full : std_logic := '0';
  signal cmd_sent,cmd_sent_r1 : std_logic;
  signal credits : unsigned(0 to 7);
  signal ha_croom_latched : unsigned(0 to 7);
  signal wed_cmd_sent,rdd_cmd_sent,wrd_cmd_sent,wst_cmd_sent : std_logic := '0';
  

  signal rd_data_addr,wr_data_addr,wr_status_addr,wed_next_addr : unsigned(0 to 63);
  
  signal cmd_error : std_logic;
  signal cmd_error_response : std_logic_vector(0 to 7);
  signal cmd_error_tag : std_logic_vector(0 to 7);
  
  signal wed_pending : std_logic := '0';
  signal wed_pending_q : std_logic := '0';
  signal wed_valid : std_logic := '0';
  signal wed_double_wed  : std_logic := '0';
  signal wed_host_addr,wed_axi4_addr : unsigned(0 to 63);
  signal wed_direction : std_logic := '0';
  signal wed_enb_status : std_logic := '0';
  signal wed_last_desc : std_logic := '0';
  signal wed_size_lines : std_logic_vector(0 to 23) := (others => '0');
  signal wed_seq_id : std_logic_vector(0 to 31) := (others => '0');
  signal second_wed : std_logic_vector(0 to 255) := (others => '0');

  signal rd_full,wr_full : std_logic;

  signal host_rd_addr,axi4_wr_addr,host_wr_addr,axi4_rd_addr : unsigned(0 to 63);
  signal host_rd_size,host_wr_size : std_logic_vector(0 to 23);
  signal axi4_rd_size,axi4_wr_size : unsigned(0 to 23);
  signal h2f_valid,f2h_valid : std_logic;
  signal h2f_busy,f2h_busy : std_logic;
  signal f2h_seq_id,h2f_seq_id : std_logic_vector(0 to 31);

  signal wed_waiting_on_afu : std_logic := '0';
  signal wed_afu_wait : std_logic := '0';
  signal wed_afu_continue : std_logic := '0';
  

   component small_sfifo64
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
  end component;


   component dpram_sfifo_level
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
  end component;

  
  signal rqueue_wadv,rqueue_radv,rqueue_empty,rqueue_full : std_logic := '0';
  signal rqueue_wdata,rqueue_rdata : std_logic_vector(0 to 119);
  
  signal rqueue_words_sent : unsigned(0 to 23);
  signal rqueue_addr_offset : unsigned(0 to 31);
  signal rqueue_host_id : std_logic_vector(0 to 31);
  signal rqueue_words_committed : unsigned(0 to 5);

  
  signal crr_fifo_wadv,crr_fifo_radv,crr_fifo_empty,crr_fifo_nfull : std_logic;
  signal crr_fifo_data : std_logic_vector(0 to 511);
  signal crr_fifo_level : std_logic_vector(0 to 9);


  signal wqueue_wadv,wqueue_radv,wqueue_empty,wqueue_full : std_logic := '0';
  signal wqueue_wdata,wqueue_rdata : std_logic_vector(0 to 119);
  
  signal wqueue_words_sent : unsigned(0 to 23);
  signal wqueue_addr_offset : unsigned(0 to 31);
  signal wqueue_words_committed : unsigned(0 to 9);

  signal wqueue_host_id : std_logic_vector(0 to 31);
  
  signal arr_fifo_wadv,arr_fifo_radv,arr_fifo_empty,arr_fifo_nfull : std_logic;
  signal arr_fifo_data : std_logic_vector(0 to 511);
  signal arr_fifo_wdata : std_logic_vector(0 to 511);
  signal arr_fifo_level : std_logic_vector(0 to 9);

  signal wstatus : std_logic_vector(0 to 511);
  signal wed_wlog,wed_rlog, rcmd_log,wcmd_log : std_logic_vector(0 to 127) := (others => '0');

  signal wr_data_pending  : std_logic := '0';
  signal rd_data_pending  : std_logic := '0';
  signal wr_status_pending  : std_logic := '0';
  signal wstatus_resp : std_logic := '0';



  -- MMIO Registers
  -- User control registers, passed thorugh to user application
  signal user_ctrl : std_logic_vector(0 to 127);
  signal user_ctrl_wr : std_logic_vector(0 to 3);
  signal user_status : std_logic_vector(0 to 127);
  signal user_status_rd : std_logic_vector(0 to 3);

  -- AFU control registers, used in this module 
  signal afu_ctrl : std_logic_vector(0 to 63);
  signal afu_ctrl_wr : std_logic_vector(0 to 1);
  signal afu_status : std_logic_vector(0 to 63);
  signal afu_status_rd : std_logic_vector(0 to 1);

  -- Interface Control registers, to be used to control
  -- the Interface Sub module.
  signal if_ctrl : std_logic_vector(0 to 63);
  signal if_ctrl_wr : std_logic_vector(0 to 1);
  signal if_status : std_logic_vector(0 to 63);
  signal if_status_rd : std_logic_vector(0 to 1);



  signal enb_status : std_logic := '0'; 
  signal enable_finish : std_logic := '0';
  signal enable_afu : std_logic := '0';
  signal force_status_wb : std_logic := '0';
  signal wed_q_active : std_logic := '0';
  

  signal last_wed : std_logic_vector(0 to 511);
  
  component axi_wrapper_if
    port (
      -- Clock and Reset
      clk    : in  std_logic;
      reset  : in  std_logic;
      -- AFU Pause WED Fetch
      wed_q_waiting : in std_logic;
      wed_q_continue : out std_logic;
      -- Interface Control
      if_ctrl : in std_logic_vector(0 to 63);
      if_ctrl_wr : in std_logic_vector(0 to 1);
      if_status : out std_logic_vector(0 to 63);
      if_status_rd : in std_logic_vector(0 to 1);
      -- User Control
      user_ctrl : in std_logic_vector(0 to 127);
      user_ctrl_wr : in std_logic_vector(0 to 3);
      user_status : out std_logic_vector(0 to 127);
      user_status_rd : in std_logic_vector(0 to 3);
      -- H2F Command
      h2f_valid : in std_logic;
      h2f_seq_id : in std_logic_vector(0 to 31);
      h2f_wr_addr : in unsigned(0 to 63);
      h2f_wr_size : in unsigned(0 to 23);
      h2f_busy : out std_logic;
      -- H2F Data
      h2f_fifo_data : in std_logic_vector(0 to 511);
      h2f_fifo_radv : out std_logic;
      h2f_fifo_level : in std_logic_vector(0 to 9);
      h2f_fifo_empty : in std_logic;
      -- F2H Command
      f2h_valid : in std_logic;
      f2h_seq_id : in std_logic_vector(0 to 31);
      f2h_rd_addr : in unsigned(0 to 63);
      f2h_rd_size : in unsigned(0 to 23);
      f2h_busy : out std_logic;
      -- F2H Data
      f2h_fifo_data : out std_logic_vector(0 to 511);
      f2h_fifo_wadv : out std_logic;
      f2h_fifo_nfull : in std_logic);
  end component;

  signal dbg_count0,dbg_count1 : unsigned(0 to 7);

  signal rtag_wadv,rtag_radv,rtag_empty,rtag_ad : std_logic;
  signal rtag_wdata,rtag_rdata : std_logic_vector(4 downto 0);

  type reorder_memory_type is array(0 to 63) of std_logic_vector(0 to 511);
  signal reorder_memory : reorder_memory_type;
  signal reorder_full : std_logic_vector(0 to 63);
  signal reorder_data_out : std_logic_vector(0 to 511);

  signal wreorder_memory : reorder_memory_type;
  signal wreorder_data_out : std_logic_vector(0 to 511);

  signal wrd_cmd_sent_reg : std_logic;
  signal wrd_tag_reg : std_logic_vector(0 to 4);
  signal wreorder_buffer_radv, wreorder_buffer_radv_r1 : std_logic;
  signal wreorder_raddr : unsigned(0 to 5);
  
begin  -- architecture rtl
  
  ah_cvalid <= ah_cvalid_i;
  ah_ctag   <= ah_ctag_i;
  ah_ctagpar   <= ah_ctagpar_i;
  ah_com    <= ah_com_i;
  ah_compar    <= ah_compar_i;
  ah_cea    <= ah_cea_i;
  ah_ceapar    <= ah_ceapar_i;
  ah_csize  <= ah_csize_i;

  JOB: process (ha_pclock) is
  begin
    if rising_edge(ha_pclock) then
          start <= '0';

          ah_jdone_next <= '0';
          ah_jdone      <= ah_jdone_next;
          
          if reset = '1' then
            ah_jrunning <= '0';
            reset       <= '0';
          end if;

          wqueue_done_last <= wqueue_done and enable_finish;
          if wqueue_done = '1' and wqueue_done_last = '0' and enable_finish = '1' then
            ah_jrunning   <= '0';
            ah_jdone_next <= '1';
          end if;

          if ha_jval = '1' then
            case ha_jcom is
              when PSL_CTRL_CMD_START =>
                ah_jrunning   <= '1';
                wed_base_addr <= unsigned(ha_jea);
                start         <= '1';
              when PSL_CTRL_CMD_RESET =>
                ah_jrunning   <= '0';
                reset         <= '1';
                ah_jdone_next <= '1';
              when others =>
                --report "Unsupported control command: " & to_hstring(ha_jcom)
                --  severity WARNING;
                null;
            end case;
          end if;
    end if;
  end process JOB;

  TIMER_P: process (ha_pclock) is
  begin
    if rising_edge(ha_pclock) then
      if reset = '1' then
        timer <= (others=>'0');
      else
        timer <= timer + 1;
      end if;
    end if;
  end process TIMER_P;
  

  mmio: process (ha_pclock) is
    variable mmdata_half : std_logic_vector(0 to 31);
  begin  -- process mmio
    if rising_edge(ha_pclock) then      -- rising clock edge
      mmdata_half := (others => '0');
      mmdata_i <= ha_mmdata;
      mmad <= ha_mmad;
      mmval <= ha_mmval;
        
      if ha_mmval = '1' then
        cfg_read   <= ha_mmval and ha_mmcfg and ha_mmrnw;
        cfg_write  <= ha_mmval and ha_mmcfg and not ha_mmrnw;
        mmio_read  <= ha_mmval and not ha_mmcfg and ha_mmrnw;
        mmio_write <= ha_mmval and not ha_mmcfg and not ha_mmrnw;
        mmdw    <= ha_mmdw;
      else
        cfg_read  <= '0';
        cfg_write  <= '0';
        mmio_read  <= '0';
        mmio_write <= '0';
      end if;

      cfg_read_d  <= cfg_read;
      mmio_read_d  <= mmio_read;
      mmack <= '0';
      mmdata <= (others=>'0');


      user_ctrl_wr <= "0000";
      afu_ctrl_wr <= "00";
      if_ctrl_wr <= "00";
      
      if mmio_write = '1' then
        if mmdw = '1' then
          case mmad(19 to 22) is
            when "0000" =>
              user_ctrl(0 to 63) <= mmdata_i;
              user_ctrl_wr(0 to 1) <= "11";
            when "0001" =>
              user_ctrl(64 to 127) <= mmdata_i;
              user_ctrl_wr(2 to 3) <= "11";
            --  "0010", "0011" user status, read only
            when "0100" =>
              afu_ctrl <= mmdata_i;
              afu_ctrl_wr <= "11";
            -- "0101" afu_status, read only
            when "0110" =>
              if_ctrl <= mmdata_i;
              if_ctrl_wr <= "11";
            -- "0111" if_status, read only
            -- "1xxx" wstatus, read only
            when others =>
              null;
          end case;
        else
          case mmad(19 to 23) is
            when "00000" =>
              user_ctrl(0 to 31) <= mmdata_i(0 to 31);
              user_ctrl_wr(0) <= '1';
            when "00001" =>
              user_ctrl(32 to 63) <= mmdata_i(32 to 63);
              user_ctrl_wr(1) <= '1';
            when "00010" =>
              user_ctrl(64 to 95) <= mmdata_i(0 to 31);
              user_ctrl_wr(2) <= '1';
            when "00011" =>
              user_ctrl(96 to 127) <= mmdata_i(32 to 63);
              user_ctrl_wr(3) <= '1';
            --  "0010x", "0011x" user status, read only
            when "01000" =>
              afu_ctrl(0 to 31) <= mmdata_i(0 to 31);
              afu_ctrl_wr(0) <= '1';
            when "01001" =>
              afu_ctrl(32 to 63) <= mmdata_i(32 to 63);
              afu_ctrl_wr(1) <= '1';
            -- "0101x" afu_status, read only
            when "01100" =>
              if_ctrl(0 to 31) <= mmdata_i(0 to 31);
              if_ctrl_wr(0) <= '1';
            when "01101" =>
              if_ctrl(32 to 63) <= mmdata_i(32 to 63);
              if_ctrl_wr(1) <= '1';
            -- "0111x" if_status, read only
            -- "1xxxx" wstatus, read only
            when others =>
              null;
          end case;
        end if;    
      end if;

      user_status_rd <= "0000";
      afu_status_rd <= "00";
      if_status_rd <= "00";
      
      mmack <= '0';
      mmdata <= (others=>'0');
      if cfg_read_d = '1' then
        if mmdw = '1' then
          mmdata <= cfg_rdata;
        elsif mmad(23) = '1' then
          mmdata <= cfg_rdata(0 to 31) & cfg_rdata(0 to 31);
        else
          mmdata <= cfg_rdata(32 to 63) & cfg_rdata(32 to 63);
        end if;
        mmack <= '1';
      elsif mmio_read_d = '1' then
        if mmdw = '1' then
          case mmad(19 to 22) is
            when "0000" =>
               mmdata <= user_ctrl(0 to 63);               
             when "0001" =>
               mmdata <= user_ctrl(64 to 127);
             when "0010" =>
               mmdata <= user_status(0 to 63);
               user_status_rd(0 to 1) <= "11";
            when "0011" =>
               mmdata <= user_status(64 to 127);
               user_status_rd(2 to 3) <= "11";
            when "0100" =>
               mmdata <= afu_ctrl;
            when "0101" =>
               mmdata <= afu_status;
               afu_status_rd <= "11";
            when "0110" =>
               mmdata <= if_ctrl;
            when "0111" =>
               mmdata <= if_status;
               if_status_rd <= "11";
            when "1000" =>
               mmdata <= wstatus(0 to 63);
            when "1001" =>
               mmdata <= wstatus(64 to 127);
            when "1010" =>
               mmdata <= wstatus(128 to 191);
            when "1011" =>
               mmdata <= wstatus(192 to 255);
            when "1100" =>
               mmdata <= wstatus(256 to 319);
            when "1101" =>
               mmdata <= wstatus(320 to 383);
            when "1110" =>
               mmdata <= wstatus(384 to 447);
            when "1111" =>
               mmdata <= wstatus(448 to 511);
            when others => null;
          end case;
        else
          case mmad(19 to 23) is
            when "00000" =>
               mmdata_half := user_ctrl(0 to 31);
            when "00001" =>
               mmdata_half := user_ctrl(32 to 63);
            when "00010" =>
               mmdata_half := user_ctrl(64 to 95);
            when "00011" =>
               mmdata_half := user_ctrl(96 to 127);
            when "00100" =>
               mmdata_half := user_status(0 to 31);
               user_status_rd(0) <= '1';
            when "00101" =>
               mmdata_half := user_status(32 to 63);
               user_status_rd(1) <= '1';
            when "00110" =>
               mmdata_half := user_status(64 to 95);
               user_status_rd(2) <= '1';
            when "00111" =>
               mmdata_half := user_status(96 to 127);
               user_status_rd(3) <= '1';
            when "01000" =>
               mmdata_half := afu_ctrl(0 to 31);
            when "01001" =>
               mmdata_half := afu_ctrl(32 to 63);
            when "01010" =>
               mmdata_half := afu_status(0 to 31);
               afu_status_rd(0) <= '1';
            when "01011" =>
               mmdata_half := afu_status(32 to 63);
               afu_status_rd(1) <= '1';
            when "01100" =>
               mmdata_half := if_ctrl(0 to 31);
            when "01101" =>
               mmdata_half := if_ctrl(32 to 63);
            when "01110" =>
               mmdata_half := if_status(0 to 31);
               if_status_rd(0) <= '1';
            when "01111" =>
               mmdata_half := if_status(32 to 63);
               if_status_rd(0) <= '1';
            when "10000" =>
               mmdata_half := wstatus(0 to 31);
            when "10001" =>
               mmdata_half := wstatus(32 to 63);
            when "10010" =>
               mmdata_half := wstatus(64 to 95);
            when "10011" =>
               mmdata_half := wstatus(96 to 127);
            when "10100" =>
               mmdata_half := wstatus(128 to 159);
            when "10101" =>
               mmdata_half := wstatus(160 to 191);
            when "10110" =>
               mmdata_half := wstatus(192 to 223);
            when "10111" =>
               mmdata_half := wstatus(224 to 255);
            when "11000" =>
               mmdata_half := wstatus(256 to 287);
            when "11001" =>
               mmdata_half := wstatus(288 to 319);
            when "11010" =>
               mmdata_half := wstatus(320 to 351);
            when "11011" =>
               mmdata_half := wstatus(352 to 383);
            when "11100" =>
              mmdata_half := wstatus(384 to 415);
            when "11101" =>
              mmdata_half := wstatus(416 to 447);
            when "11110" =>
               mmdata_half := wstatus(448 to 479);
            when "11111" =>
               mmdata_half := wstatus(480 to 511);
            when others => null;
          end case;
          mmdata <= mmdata_half & mmdata_half;
        end if;      
        mmack <= '1';
      elsif cfg_write = '1' then
        mmack <= '1';
      elsif mmio_write = '1' then
        mmack <= '1';
      end if;
   
      ah_mmdata <= mmdata;
      ah_mmdatapar <= calc_parity(mmdata);
      ah_mmack     <= mmack;
      
      if mmval = '1' then
        -- AFU descriptor
        -- Offset 0x00(0), bit 31 -> AFU supports only 1 process at a time
        -- Offset 0x00(0), bit 59 -> AFU supports dedicated process
        -- Offset 0x30(6), bit 07 -> AFU Problem State Area Required
        case to_integer(mmad(0 to 22)) is
          when 0      => cfg_rdata <= (31=>'1', 59=>'1', others=>'0');
          when 6      => cfg_rdata <= (7=>'1', others=>'0');
          when others => cfg_rdata <= (others=>'0');
        end case;
      end if;
      if reset = '1' then
        --control_regs_in <= (others => '0');
        mmdw <= '0';     
      end if;
    end if;
  end process mmio;


  clk <= ha_pclock;
  

  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Command Queue Process
  -- Controls the transfer of AFU commands presented to the PSL
  -- Interfaces between the WED parser, the Read FSM, the write FSM and the
  -- Status FSM
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  cmd_queue0: process (clk) is
    variable next_tag : std_logic_vector(0 to 7) := "00000000";
  begin  -- process cmd_queue0
    if rising_edge(clk) then            -- rising clock edge
      if credits < X"40" and credits < ha_croom_latched then
        cmd_queue_full <= '0';
      else
        cmd_queue_full <= '1';
      end if;

      if start = '1' then
        ha_croom_latched <= ha_croom;
      end if;
      
      cmd_sent_r1 <= cmd_sent;
      cmd_sent <= '0';      
      ah_cvalid_i <= '0';
      wed_cmd_sent <= '0';
      rdd_cmd_sent <= '0';
      wrd_cmd_sent <= '0';
      wst_cmd_sent <= '0';
      -- Send commands only every 3 clock cycles
      if cmd_queue_full = '0' and cmd_sent = '0' and cmd_sent_r1 = '0' then
        if wed_pending = '1' then
          ah_com_i <= '0' & X"A00";
          ah_compar_i <= '1';
          ah_cvalid_i <= '1';
          ah_cea_i <= wed_next_addr;
          ah_ceapar_i <= calc_parity(wed_next_addr);
          ah_csize_i <= X"080";
          next_tag := "000" & std_logic_vector(wed_tag);
          ah_ctag_i <= next_tag;
          ah_ctagpar_i <= calc_parity(next_tag);
          cmd_sent <= '1';
          wed_tag <= wed_tag+1;
          wed_cmd_sent <= '1';
        elsif rd_data_pending = '1' then
          ah_com_i <= '0' & X"A00";
          ah_compar_i <= '1';
          ah_cvalid_i <= '1';
          ah_cea_i <= rd_data_addr;
          ah_ceapar_i <= calc_parity(rd_data_addr);
          ah_csize_i <= X"080";
          next_tag := "001" & std_logic_vector(rd_data_tag);
          ah_ctag_i <= next_tag;
          ah_ctagpar_i <= calc_parity(next_tag);
          cmd_sent <= '1';
          rd_data_tag <= rd_data_tag+1;
          rdd_cmd_sent <= '1';
        elsif wr_data_pending = '1' then
          ah_com_i <= '0' & X"D00";
          ah_compar_i <= '0';
          ah_cvalid_i <= '1';
          ah_cea_i <= wr_data_addr;
          ah_ceapar_i <= calc_parity(wr_data_addr);
          ah_csize_i <= X"080";
          next_tag := "010" & std_logic_vector(wr_data_tag);
          ah_ctag_i <= next_tag;
          ah_ctagpar_i <= calc_parity(next_tag);
          cmd_sent <= '1';
          wr_data_tag <= wr_data_tag+1;
          wrd_cmd_sent <= '1';
        elsif wr_status_pending = '1' then
          ah_com_i <= '0' & X"D60";
          ah_compar_i <= '0';
          ah_cvalid_i <= '1';
          ah_cea_i <= wr_status_addr;
          ah_ceapar_i <= calc_parity(wr_status_addr);
          ah_csize_i <= X"080";
          next_tag := "011" & std_logic_vector(wr_status_tag);
          ah_ctag_i <= next_tag;
          ah_ctagpar_i <= calc_parity(next_tag);
          cmd_sent <= '1';
          wr_status_tag <= wr_status_tag+1;
          wst_cmd_sent <= '1';
        end if;
      end if;

      if ha_rvalid = '1' then
        if cmd_sent = '0' then
          credits <= credits -1;
        end if;
        if ha_response /= X"00" then
          cmd_error <= '1';
          cmd_error_response <= ha_response;
          cmd_error_tag <= ha_rtag;
        end if;
      else
        if cmd_sent = '1' then
          credits <= credits +1;
        end if;
      end if;
      
      if reset = '1' then
        credits <= (others => '0');
        wed_tag <= (others => '0');
        rd_data_tag <= (others => '0');
        wr_data_tag <= (others => '0');
        wr_status_tag <= (others => '0');
        cmd_error <= '0';
      end if;
    end if;
  end process cmd_queue0;
  
   -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Work Element parsing Process
  -- Controls the reading of WED and passing on commands to Read
  -- and Write engines
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- WED Format:
  -- 0:63     host_addr - must be 128 byte aligned
  -- 64:127   axi4_addr - must be 128 byte aligned
  -- 128      direction : 0 Host to FPGA, 1 FPGA to Host
  -- 129      enable status updates
  -- 130      double WED
  -- 131      last descriptor
  -- 136:159  size in 128 byte blocks
  -- 160:191  sequence ID
  -- 192:255  next_wed  
  -- Optional second WED in second 64 bytes of block
  -- 256:319  host_addr - must be 128 byte aligned
  -- 320:383  axi4_addr - must be 128 byte aligned
  -- 384      direction : 0 Host to FPGA, 1 FPGA to Host
  -- 385      enable status updates
  -- 387      last descriptor
  -- 392:415  size in 128 byte blocks
  -- 416:447  sequence ID
  -- 448:511  next_wed
  
  wed_fsm0: process (clk) is
    variable wed_info_word : std_logic_vector(0 to 63);
  begin  -- process wed_fsm0
    if rising_edge(clk) then            -- rising clock edge
      if start = '1' then
        wed_next_addr <= wed_base_addr;
        wed_pending <= '1';
        
      else
        if wed_pending = '1' and wed_cmd_sent = '1' then
          wed_pending <= '0';
        end if;
        
        if wed_pending_q = '1' and rd_full = '0' and wr_full = '0' and wed_waiting_on_afu = '0' then
          wed_pending <= '1';
        end if;               
      end if;

      rd_full <= rqueue_full or crr_fifo_nfull or h2f_busy;
      wr_full <= wqueue_full or arr_fifo_nfull or f2h_busy;
          
      wed_valid <= '0';
      wed_double_wed <= '0';
      wed_afu_wait  <= '0';
      if ha_bwvalid = '1' and ha_bwtag(0 to 2) = "000" and ha_brad(5) = '0' then
        wed_host_addr <=  unsigned(endian_byteswap64(ha_bwdata(0 to 63)));
        wed_axi4_addr <=  unsigned(endian_byteswap64(ha_bwdata(64 to 127)));
        wed_info_word :=  endian_byteswap64(ha_bwdata(128 to 191));
        wed_direction <= wed_info_word(63);
        wed_enb_status <= wed_info_word(62);
        wed_double_wed <= wed_info_word(61);
        wed_last_desc <= wed_info_word(60);
        wed_afu_wait  <= wed_info_word(59);
        wed_size_lines <= wed_info_word(32 to 55);
        wed_seq_id <= wed_info_word(0 to 31);
        wed_next_addr <= unsigned(endian_byteswap64(ha_bwdata(192 to 255)));  
        second_wed <= ha_bwdata(256 to 511);
        wed_valid <='1';
        last_wed <= ha_bwdata;
      end if;
      
      if wed_double_wed = '1' then
        wed_host_addr <=  unsigned(endian_byteswap64(second_wed(0 to 63)));
        wed_axi4_addr <=  unsigned(endian_byteswap64(second_wed(64 to 127)));
        wed_info_word :=  endian_byteswap64(second_wed(128 to 191));
        wed_direction <= wed_info_word(63);
        wed_enb_status <= wed_info_word(62);
        wed_double_wed <= '0';
        wed_last_desc <= wed_info_word(60);
        wed_afu_wait  <= wed_info_word(59);
        wed_size_lines <= wed_info_word(32 to 55);
        wed_seq_id <= wed_info_word(0 to 31);
        wed_next_addr <= unsigned(endian_byteswap64(second_wed(192 to 255))); 
        wed_valid <='1';
      end if;

      if wed_valid = '1' and wed_last_desc = '0' and wed_double_wed = '0' then
        wed_pending_q <= '1';
      elsif rd_full = '0' and wr_full = '0' and wed_waiting_on_afu = '0' then
        wed_pending_q <= '0';        
      end if;

      h2f_valid <= '0';
      f2h_valid <= '0';
      if wed_valid = '1' then
        if wed_direction = '0' then
          host_rd_addr <= wed_host_addr;
          axi4_wr_addr <= wed_axi4_addr;
          host_rd_size <= wed_size_lines;
          axi4_wr_size <= unsigned(wed_size_lines);
          h2f_valid <= '1';
          h2f_seq_id <= wed_seq_id;
        else
          host_wr_addr <= wed_host_addr;
          axi4_rd_addr <= wed_axi4_addr;
          host_wr_size <= wed_size_lines;
          axi4_rd_size <= unsigned(wed_size_lines);
          f2h_valid <= '1';
          f2h_seq_id <= wed_seq_id;
        end if;
      end if;
     

      if start = '1' then
        wed_q_active <= '1';
      elsif wed_last_desc = '1' and wed_valid = '1' then
        wed_q_active <= '0';
      end if;

      if wed_afu_wait = '1' then
        wed_waiting_on_afu <= '1';
      else
        if wed_afu_continue = '1' then
          wed_waiting_on_afu <= '0';
        end if;
      end if;
      
      if reset = '1' then
        wed_q_active <= '0';
        wed_pending <= '0';
        wed_pending_q <= '0';
        wed_enb_status <= '0';
        wed_waiting_on_afu <= '0';
      end if;
    end if;
  end process wed_fsm0;


  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- CAPI Read Queue
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  rqueue_wadv <= h2f_valid;
  rqueue_wdata <= std_logic_vector(host_rd_addr) & host_rd_size & h2f_seq_id;
  
  capi_rqueue_sfifo0 : small_sfifo64
    generic map (
      width => 64+24+32)
    port map (
      clk    => clk,
      rst    => reset,
      wadv   => rqueue_wadv,
      wdata  => rqueue_wdata,
      nfull  => rqueue_full,
      radv   => rqueue_radv,
      rempty => rqueue_empty,
      rdata  => rqueue_rdata);

  rqueue_fsm0: process (clk) is
    variable host_addr : unsigned(0 to 63) := (others => '0');
    variable host_size : unsigned(0 to 23);
    variable host_id : std_logic_vector(0 to 31);
  begin  -- process rqueue_fsm0
    if rising_edge(clk) then            -- rising clock edge
      host_addr(0 to 56) := unsigned(rqueue_rdata(0 to 56));
      host_size := unsigned(rqueue_rdata(64 to 87));
      host_id := rqueue_rdata(88 to 119);

      rqueue_host_id <= host_id;
      
      rqueue_radv <= '0';
      rd_data_pending <= '0';
      if rqueue_empty = '0' and rqueue_radv = '0' then
        if rqueue_words_sent = host_size then
          rqueue_radv <= '1';
          rqueue_words_sent <= (others => '0');
          rqueue_addr_offset <= (others => '0');
        else
          if rqueue_words_committed < 48 then         
            rd_data_pending <= not crr_fifo_nfull;       
          end if;
          rd_data_addr <= host_addr+resize(rqueue_addr_offset,64);
          if rdd_cmd_sent = '1' then
            rqueue_addr_offset <= rqueue_addr_offset+128;
            rqueue_words_sent <= rqueue_words_sent+1;
          end if;          
        end if;     
      end if;

      if rdd_cmd_sent = '1' and crr_fifo_wadv = '0' then
        rqueue_words_committed <= rqueue_words_committed +2;
      elsif rdd_cmd_sent = '1' and crr_fifo_wadv  = '1' then
        rqueue_words_committed <= rqueue_words_committed +1;
      elsif rdd_cmd_sent = '0' and crr_fifo_wadv = '1' then
        rqueue_words_committed <= rqueue_words_committed -1;      
      end if;
      
      if reset = '1' then
        rqueue_words_sent <= (others => '0');
        rqueue_addr_offset <= (others => '0');
        rqueue_words_committed <= (others => '0');
      end if;
    end if;
  end process rqueue_fsm0;

  
  rtag_wadv <= rdd_cmd_sent;
  rtag_wdata <= ah_ctag_i(3 to 7);

  capi_rtag_sfifo0 : small_sfifo64
    generic map (
      width => 5)
    port map (
      clk    => clk,
      rst    => reset,
      wadv   => rtag_wadv,
      wdata  => rtag_wdata,
      nfull  => open,
      radv   => rtag_radv,
      rempty => rtag_empty,
      rdata  => rtag_rdata);
  
  -- CAPI Read response buffer
  capi_read_reorder_buffer: process (clk) is
    variable reorder_waddr : unsigned(0 to 5);
    variable reorder_raddr : unsigned(0 to 5);
    
  begin  -- process capi_read_reorder_buffer
    if rising_edge(clk) then            -- rising clock edge
      reorder_waddr := unsigned(ha_bwtag(3 to 7) & ha_bwad(5));
      reorder_raddr := unsigned(rtag_rdata & rtag_ad);
      if ha_bwvalid = '1' and ha_bwtag(0 to 2) = "001" then
        reorder_memory(to_integer(reorder_waddr)) <= ha_bwdata;
        reorder_full(to_integer(reorder_waddr)) <='1';
      end if;
      
      reorder_data_out <= reorder_memory(to_integer(reorder_raddr));

      crr_fifo_wadv <= '0';
      if reorder_full(to_integer(reorder_raddr)) = '1' and rtag_empty = '0' then
        rtag_ad <= not rtag_ad;
        crr_fifo_wadv <= '1';
        reorder_full(to_integer(reorder_raddr)) <= '0';
      end if;
            
      if reset = '1' then
        rtag_ad <= '0';
        reorder_full <= (others => '0');
      end if;
    end if;
  end process capi_read_reorder_buffer;

  rtag_radv <= reorder_full(to_integer(unsigned(rtag_rdata & rtag_ad))) and rtag_ad and not rtag_empty;

  
  capi_read_resp_fifo_1 : dpram_sfifo_level
      generic map (
        width => 512)
      port map (
        clk    => clk,
        rst    => reset,
        wadv   => crr_fifo_wadv,
        wdata  => reorder_data_out,
        nfull  => crr_fifo_nfull,
        radv   => crr_fifo_radv,
        rempty => crr_fifo_empty,
        rdata  => crr_fifo_data,
        rlevel => crr_fifo_level);    




   -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- CAPI Write Queue
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  wqueue_wadv <= f2h_valid;
  wqueue_wdata <= std_logic_vector(host_wr_addr) & host_wr_size & f2h_seq_id;
  
  capi_wqueue_sfifo0 : small_sfifo64
    generic map (
      width => 64+24+32)
    port map (
      clk    => clk,
      rst    => reset,
      wadv   => wqueue_wadv,
      wdata  => wqueue_wdata,
      nfull  => wqueue_full,
      radv   => wqueue_radv,
      rempty => wqueue_empty,
      rdata  => wqueue_rdata);

  wqueue_fsm0: process (clk) is
    variable host_addr : unsigned(0 to 63):= (others => '0');
    variable host_size : unsigned(0 to 23);
    variable host_id : std_logic_vector(0 to 31);
  begin  -- process wqueue_fsm0
    if rising_edge(clk) then       
      host_addr(0 to 56) := unsigned(wqueue_rdata(0 to 56));
      host_size := unsigned(wqueue_rdata(64 to 87));
      host_id := wqueue_rdata(88 to 119);

      wqueue_host_id <= host_id;
      
      wqueue_radv <= '0';
      wr_data_pending <= '0';
      if wqueue_empty = '0' and wqueue_radv = '0' then
        if wqueue_words_sent = host_size then
          wqueue_radv <= '1';
          wqueue_words_sent <= (others => '0');
          wqueue_addr_offset <= (others => '0');
        else
          if ((unsigned(arr_fifo_level)>3) or ((unsigned(arr_fifo_level)>1) and (arr_fifo_radv = '0'))) and (wqueue_words_committed <48) then
            wr_data_pending <= '1';
          else
            wr_data_pending <= '0';
          end if;
          
          wr_data_addr <= host_addr+resize(wqueue_addr_offset,64);
          if wrd_cmd_sent = '1' then
            wqueue_addr_offset <= wqueue_addr_offset+128;
            wqueue_words_sent <= wqueue_words_sent+1;
          end if;          
        end if;     
      end if;

      if wrd_cmd_sent = '1' and wreorder_buffer_radv = '0' then
        wqueue_words_committed <= wqueue_words_committed +2;
      elsif wrd_cmd_sent = '1' and wreorder_buffer_radv = '1' then
        wqueue_words_committed <= wqueue_words_committed +1;
      elsif wrd_cmd_sent = '0' and wreorder_buffer_radv = '1' then
        wqueue_words_committed <= wqueue_words_committed -1;      
      end if;

      if start = '1' then
        wqueue_done <= '0';
      else
        if wed_q_active = '0' and wqueue_empty = '1' and arr_fifo_empty = '1' and wqueue_words_committed = 0 and crr_fifo_empty = '1' and rqueue_empty = '1' and credits = 0 then
          wqueue_done <= '1';
        end if;
      end if;
      
      
      
      if reset = '1' then
        wqueue_words_sent <= (others => '0');
        wqueue_addr_offset <= (others => '0');
        wqueue_words_committed <= (others => '0');
      end if;
    end if;
  end process wqueue_fsm0;


  -- AXI4 Read response buffer

  axi4_read_resp_fifo_1 : dpram_sfifo_level
      generic map (
        width => 512)
      port map (
        clk    => clk,
        rst    => reset,
        wadv   => arr_fifo_wadv,
        wdata  => arr_fifo_wdata,
        nfull  => arr_fifo_nfull,
        radv   => arr_fifo_radv,
        rempty => arr_fifo_empty,
        rdata  => arr_fifo_data,
        rlevel => arr_fifo_level);    

  ah_brlat <= "0011";
  
  output_ah_data: process (clk) is
    variable wreorder_waddr : unsigned(0 to 5);  
  begin  -- process output_hr_data
    if rising_edge(clk) then            -- rising clock edge
      wrd_cmd_sent_reg <= wrd_cmd_sent;
      if wrd_cmd_sent = '1' then
        wrd_tag_reg <= ah_ctag_i(3 to 7);
      end if;
      arr_fifo_radv <= wrd_cmd_sent or wrd_cmd_sent_reg;

      wreorder_waddr := unsigned(wrd_tag_reg & (not wrd_cmd_sent_reg));
      if arr_fifo_radv = '1' then
        wreorder_memory(to_integer(wreorder_waddr)) <= arr_fifo_data;
      end if;
      
      wreorder_raddr <= unsigned(ha_brtag(3 to 7) & ha_brad(5));
      
      wreorder_data_out <= wreorder_memory(to_integer(wreorder_raddr));
      
      
      wstatus_resp <= '0';
      wreorder_buffer_radv <= '0';
      if ha_brtag(0 to 2) = "010"  then
        wreorder_buffer_radv <= ha_brvalid;
      elsif ha_brtag(0 to 2) = "011" then
        wstatus_resp <= '1';
      end if;
      
      wreorder_buffer_radv_r1 <= wreorder_buffer_radv;
      if wreorder_buffer_radv_r1 = '1' then
        ah_brdata_i <= wreorder_data_out;
        for i in 0 to 7 loop
          ah_brpar_i(i) <= calc_parity(wreorder_data_out(64*i to 64*i+63));
        end loop;  -- i       
      elsif wstatus_resp = '1' then
        ah_brdata_i <= wstatus;
        for i in 0 to 7 loop
          ah_brpar_i(i) <= calc_parity(wstatus(64*i to 64*i+63));
        end loop;  -- i  
      end if;

      ah_brdata <= ah_brdata_i;
      ah_brpar <= ah_brpar_i;
      
    end if;
  end process output_ah_data;


  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Status Management block
  -- Logs progress of WED operations
  -- Readable via MMAP interface
  -- Optionally can write back to host address
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------

  
  status_management0: process (clk) is
  begin  -- process status_management0
    if rising_edge(clk) then            -- rising clock edge
      --if f2h_valid = '1' then
      --  wed_wlog <= wed_wlog(64 to 127) & std_logic_vector(host_wr_addr);
      --end if;
      --if h2f_valid = '1' then
      --  wed_rlog <= wed_rlog(64 to 127) & std_logic_vector(host_rd_addr);
      --end if;
      --if f2h_valid = '1' then
      --  wed_wlog <= wed_wlog(32 to 127) & f2h_seq_id;
      --end if;
      --if h2f_valid = '1' then
      --  wed_rlog <= wed_rlog(32 to 127) & h2f_seq_id;
      --end if;


      
      --if rqueue_radv = '1' then
      --  rcmd_log <= rcmd_log(32 to 127) & rqueue_host_id;
      --end if;
      --if wqueue_radv = '1' then
      --  wcmd_log <= wcmd_log(32 to 127) & wqueue_host_id;
      --end if;
      --if reset = '1' then
      --  wcmd_log <= (others => '0');
      --else
      --  if ah_cvalid_i = '1' then
      --    wcmd_log <= wcmd_log(64 to 127) & std_logic_vector(ah_cea_i);
      --  end if;  
      --end if;
      --if reset = '1' then
      --  rcmd_log <= (others => '0');
      --else
      --  if cmd_sent = '1' then
      --    rcmd_log <= rcmd_log(8 to 127) & ah_ctag_i;
      --  end if;  
      --end if;
      --if reset = '1' then
      --  wed_rlog <= (others => '0');
      --else
      --  if ha_brvalid = '1' then
      --    wed_rlog <= wed_rlog(8 to 127) & ha_brtag;
      --  end if;  
      --end if;
      --if reset = '1' then
      --  wed_wlog <= (others => '0');
      --else
      --  if rtag_radv = '1' then
      --    wed_wlog <= wed_wlog(4 to 127) & rtag_rdata;
      --  end if;  
      --end if;


      if reset = '1' then
        wstatus <= (others => '0');
      else
        if ah_cvalid_i = '1' then
          wstatus <= wstatus(64 to 511) & std_logic_vector(ah_cea_i);
        end if;  
      end if;
      
      if (wed_enb_status = '1' and enb_status = '1' and (rqueue_radv = '1' or wqueue_radv = '1')) or force_status_wb = '1'  then
        
        wr_status_pending <= '1';
      elsif wst_cmd_sent = '1' then
        wr_status_pending <= '0';
      end if;

      if reset = '1' then
        wr_status_pending <= '0';
      end if;

      --wstatus <= wcmd_log & rcmd_log & wed_wlog & wed_rlog;
      
    end if;
  end process status_management0;


  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- AFU Control and Stutus Regs
  -- Enables, extra status and control for this module
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  afu_ctrl_proc0: process (clk) is
  begin  -- process afu_ctrl
    if rising_edge(clk) then            -- rising clock edge
      enable_afu <= afu_ctrl(31);
      enable_finish <= afu_ctrl(30);
      enb_status <= afu_ctrl(29);
      force_status_wb <= afu_ctrl(28);
      
      afu_status <= (others => '0');
      --afu_status(0 to 15) <= std_logic_vector(wed_tag) & std_logic_vector(rd_data_tag) & std_logic_vector(wr_data_tag) & '0';
      afu_status(0 to 15) <= std_Logic_vector(dbg_count0) & std_logic_vector(dbg_count1);
      afu_status(16) <= wqueue_done;
      afu_status(17) <= wed_q_active;
      afu_status(18) <= wqueue_empty;
      afu_status(19) <= rqueue_empty;
      afu_status(20) <= cmd_error;
      afu_status(21) <= wed_direction;
      afu_status(22) <= wed_double_wed;
      afu_status(23) <= wed_last_desc;
      if cmd_error = '0' then
        afu_status(24 to 31) <= std_logic_vector(ha_croom_latched);
      else
        afu_status(24 to 31) <= cmd_error_response;
      end if; 
      afu_status(32 to 39) <= cmd_error_tag;
      afu_status(40) <= arr_fifo_empty;
      afu_status(41) <= arr_fifo_nfull;
      afu_status(42) <= crr_fifo_empty;
      afu_status(43) <= crr_fifo_nfull;
      --afu_status(44 to 53) <= rqueue_words_sent(4 to 23);
      afu_status(44 to 53) <= arr_fifo_level;
      afu_status(54 to 63) <= crr_fifo_level;
      --afu_status(32 to 63) <= reorder_full;
      --afu_status(24 to 31) <= rtag_rdata & rtag_empty & rtag_ad & "00";

      if start = '1' then
        dbg_count0 <= (others => '0');
      elsif rqueue_radv = '1' then
        dbg_count0 <= dbg_count0 +1;
      end if;

      if start = '1' then
        dbg_count1 <= (others => '0');
      elsif rqueue_wadv = '1' then
        dbg_count1 <= dbg_count1 +1;
      end if;
      
      
    end if;
  end process afu_ctrl_proc0;



  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- Interfacing Sub-Module
  -----------------------------------------------------------------------------
  -- Streaming or AXI4 conversion wrapper goes here
  -----------------------------------------------------------------------------
  -- Interfaces:
  -- H2F Commands:
  -- h2f_valid
  -- h2f_seq_id
  -- axi4_wr_addr - use as channel ID for streaming
  -- axi4_wr_size
  --
  -- H2F Data:
  -- crr_fifo_data
  -- crr_fifo_radv
  -- crr_fifo_level
  -- crr_fifo_empty
  --
  -- F2H Commands:
  -- f2h_valid
  -- f2h_seq_id
  -- axi4_rd_addr - use as channel ID for streaming
  -- axi4_rd_size
  --
  -- F2H Data:
  -- arr_fifo_wadv
  -- arr_fifo_wdata
  -- arr_fifo_nfull
  --
  -- Interface Control
  -- could be used for a low speed AXI4 Lite bus 
  -- could be used as 2 low perfomance "control" streams
  -- 
  -- if_ctrl
  -- if_ctrl_wr
  -- if_status
  -- if_status_rd
  --
  -- User Control
  -- to be passed direct to user application
  -- user_ctrl
  -- user_ctrl_wr
  -- user_status
  -- user_status_wr

  
  
  axi_wrapper_if_1: axi_wrapper_if
    port map (
      clk            => clk,
      reset          => reset,
      wed_q_waiting  => wed_waiting_on_afu,
      wed_q_continue => wed_afu_continue,
      if_ctrl        => if_ctrl,
      if_ctrl_wr     => if_ctrl_wr,
      if_status      => if_status,
      if_status_rd   => if_status_rd,
      user_ctrl      => user_ctrl,
      user_ctrl_wr   => user_ctrl_wr,
      user_status    => user_status,
      user_status_rd => user_status_rd,
      h2f_valid      => h2f_valid,
      h2f_seq_id     => h2f_seq_id,
      h2f_wr_addr    => axi4_wr_addr,
      h2f_wr_size    => axi4_wr_size,
      h2f_busy       => h2f_busy,
      h2f_fifo_data  => crr_fifo_data,
      h2f_fifo_radv  => crr_fifo_radv,
      h2f_fifo_level => crr_fifo_level,
      h2f_fifo_empty => crr_fifo_empty,
      f2h_valid      => f2h_valid,
      f2h_seq_id     => f2h_seq_id,
      f2h_rd_addr    => axi4_rd_addr,
      f2h_rd_size    => axi4_rd_size,
      f2h_busy       => f2h_busy,
      f2h_fifo_data  => arr_fifo_wdata,
      f2h_fifo_wadv  => arr_fifo_wadv,
      f2h_fifo_nfull => arr_fifo_nfull);
  
  

  
  
end architecture rtl;
