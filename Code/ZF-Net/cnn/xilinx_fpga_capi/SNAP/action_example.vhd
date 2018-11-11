----------------------------------------------------------------------------
----------------------------------------------------------------------------
--
-- Copyright 2016 International Business Machines
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions AND
-- limitations under the License.
--
-- change log:
-- 12/20/2016 R. Rieke fixed case statement issue
----------------------------------------------------------------------------
----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;


entity action_example is
  generic (
    -- Parameters of Axi Master Bus Interface AXI_CARD_MEM0 ; to DDR memory
    C_AXI_CARD_MEM0_ID_WIDTH     : integer := 2;
    C_AXI_CARD_MEM0_ADDR_WIDTH   : integer := 33;
    C_AXI_CARD_MEM0_DATA_WIDTH   : integer := 512;
    C_AXI_CARD_MEM0_AWUSER_WIDTH : integer := 1;
    C_AXI_CARD_MEM0_ARUSER_WIDTH : integer := 1;
    C_AXI_CARD_MEM0_WUSER_WIDTH  : integer := 1;
    C_AXI_CARD_MEM0_RUSER_WIDTH  : integer := 1;
    C_AXI_CARD_MEM0_BUSER_WIDTH  : integer := 1;

    -- Parameters of Axi Slave Bus Interface AXI_CTRL_REG
    C_AXI_CTRL_REG_DATA_WIDTH : integer := 32;
    C_AXI_CTRL_REG_ADDR_WIDTH : integer := 32;

    -- Parameters of Axi Master Bus Interface AXI_HOST_MEM ; to Host memory
    C_AXI_HOST_MEM_ID_WIDTH     : integer := 2;
    C_AXI_HOST_MEM_ADDR_WIDTH   : integer := 64;
    C_AXI_HOST_MEM_DATA_WIDTH   : integer := 512;
    C_AXI_HOST_MEM_AWUSER_WIDTH : integer := 1;
    C_AXI_HOST_MEM_ARUSER_WIDTH : integer := 1;
    C_AXI_HOST_MEM_WUSER_WIDTH  : integer := 1;
    C_AXI_HOST_MEM_RUSER_WIDTH  : integer := 1;
    C_AXI_HOST_MEM_BUSER_WIDTH  : integer := 1;
    INT_BITS                    : integer := 3;
    CONTEXT_BITS                : integer := 8
    );
  port (
    action_clk   : in  std_logic;
    action_rst_n : in  std_logic;
    int_req_ack  : in  std_logic;
    int_req      : out std_logic;
    int_src      : out std_logic_vector(INT_BITS-2 downto 0);
    int_ctx      : out std_logic_vector(CONTEXT_BITS-1 downto 0);

    --

    -- Ports of Axi Slave Bus Interface AXI_CTRL_REG
    axi_ctrl_reg_awaddr  : in  std_logic_vector(C_AXI_CTRL_REG_ADDR_WIDTH-1 downto 0);
    -- axi_ctrl_reg_awprot : in std_logic_vector(2 downto 0);
    axi_ctrl_reg_awvalid : in  std_logic;
    axi_ctrl_reg_awready : out std_logic;
    axi_ctrl_reg_wdata   : in  std_logic_vector(C_AXI_CTRL_REG_DATA_WIDTH-1 downto 0);
    axi_ctrl_reg_wstrb   : in  std_logic_vector((C_AXI_CTRL_REG_DATA_WIDTH/8)-1 downto 0);
    axi_ctrl_reg_wvalid  : in  std_logic;
    axi_ctrl_reg_wready  : out std_logic;
    axi_ctrl_reg_bresp   : out std_logic_vector(1 downto 0);
    axi_ctrl_reg_bvalid  : out std_logic;
    axi_ctrl_reg_bready  : in  std_logic;
    axi_ctrl_reg_araddr  : in  std_logic_vector(C_AXI_CTRL_REG_ADDR_WIDTH-1 downto 0);
    -- axi_ctrl_reg_arprot  : in std_logic_vector(2 downto 0);
    axi_ctrl_reg_arvalid : in  std_logic;
    axi_ctrl_reg_arready : out std_logic;
    axi_ctrl_reg_rdata   : out std_logic_vector(C_AXI_CTRL_REG_DATA_WIDTH-1 downto 0);
    axi_ctrl_reg_rresp   : out std_logic_vector(1 downto 0);
    axi_ctrl_reg_rvalid  : out std_logic;
    axi_ctrl_reg_rready  : in  std_logic;

    -- Ports of Axi Master Bus Interface AXI_HOST_MEM
    -- to HOST memory
    axi_host_mem_awaddr   : out std_logic_vector(C_AXI_HOST_MEM_ADDR_WIDTH-1 downto 0);
    axi_host_mem_awlen    : out std_logic_vector(7 downto 0);
    axi_host_mem_awsize   : out std_logic_vector(2 downto 0);
    axi_host_mem_awburst  : out std_logic_vector(1 downto 0);
    axi_host_mem_awlock   : out std_logic_vector(0 downto 0);
    axi_host_mem_awcache  : out std_logic_vector(3 downto 0);
    axi_host_mem_awprot   : out std_logic_vector(2 downto 0);
    axi_host_mem_awregion : out std_logic_vector(3 downto 0);
    axi_host_mem_awqos    : out std_logic_vector(3 downto 0);
    axi_host_mem_awvalid  : out std_logic;
    axi_host_mem_awready  : in  std_logic;
    axi_host_mem_wdata    : out std_logic_vector(C_AXI_HOST_MEM_DATA_WIDTH-1 downto 0);
    axi_host_mem_wstrb    : out std_logic_vector(C_AXI_HOST_MEM_DATA_WIDTH/8-1 downto 0);
    axi_host_mem_wlast    : out std_logic;
    axi_host_mem_wvalid   : out std_logic;
    axi_host_mem_wready   : in  std_logic;
    axi_host_mem_bresp    : in  std_logic_vector(1 downto 0);
    axi_host_mem_bvalid   : in  std_logic;
    axi_host_mem_bready   : out std_logic;
    axi_host_mem_araddr   : out std_logic_vector(C_AXI_HOST_MEM_ADDR_WIDTH-1 downto 0);
    axi_host_mem_arlen    : out std_logic_vector(7 downto 0);
    axi_host_mem_arsize   : out std_logic_vector(2 downto 0);
    axi_host_mem_arburst  : out std_logic_vector(1 downto 0);
    axi_host_mem_arlock   : out std_logic_vector(0 downto 0);
    axi_host_mem_arcache  : out std_logic_vector(3 downto 0);
    axi_host_mem_arprot   : out std_logic_vector(2 downto 0);
    axi_host_mem_arregion : out std_logic_vector(3 downto 0);
    axi_host_mem_arqos    : out std_logic_vector(3 downto 0);
    axi_host_mem_arvalid  : out std_logic;
    axi_host_mem_arready  : in  std_logic;
    axi_host_mem_rdata    : in  std_logic_vector(C_AXI_HOST_MEM_DATA_WIDTH-1 downto 0);
    axi_host_mem_rresp    : in  std_logic_vector(1 downto 0);
    axi_host_mem_rlast    : in  std_logic;
    axi_host_mem_rvalid   : in  std_logic;
    axi_host_mem_rready   : out std_logic;
--      axi_host_mem_error    : out std_logic;
    axi_host_mem_arid     : out std_logic_vector(C_AXI_HOST_MEM_ID_WIDTH-1 downto 0);
    axi_host_mem_aruser   : out std_logic_vector(C_AXI_HOST_MEM_ARUSER_WIDTH-1 downto 0);
    axi_host_mem_awid     : out std_logic_vector(C_AXI_HOST_MEM_ID_WIDTH-1 downto 0);
    axi_host_mem_awuser   : out std_logic_vector(C_AXI_HOST_MEM_AWUSER_WIDTH-1 downto 0);
    axi_host_mem_bid      : in  std_logic_vector(C_AXI_HOST_MEM_ID_WIDTH-1 downto 0);
    axi_host_mem_buser    : in  std_logic_vector(C_AXI_HOST_MEM_BUSER_WIDTH-1 downto 0);
    axi_host_mem_rid      : in  std_logic_vector(C_AXI_HOST_MEM_ID_WIDTH-1 downto 0);
    axi_host_mem_ruser    : in  std_logic_vector(C_AXI_HOST_MEM_RUSER_WIDTH-1 downto 0);
    axi_host_mem_wuser    : out std_logic_vector(C_AXI_HOST_MEM_WUSER_WIDTH-1 downto 0)
    );
end action_example;

architecture action_example of action_example is



  type fsm_app_t is (IDLE, WAIT_FOR_WEIGHT_DONE, WAIT_FOR_CONV_DONE);

  signal fsm_app_q  : fsm_app_t;
  
  signal reg_0x20  : std_logic_vector(31 downto 0);
  signal reg_0x30  : std_logic_vector(31 downto 0);
  signal reg_0x34  : std_logic_vector(31 downto 0);
  signal reg_0x38  : std_logic_vector(31 downto 0);
  signal reg_0x3c  : std_logic_vector(31 downto 0);
  signal reg_0x40  : std_logic_vector(31 downto 0);
  signal reg_0x44  : std_logic_vector(31 downto 0);
  signal app_start : std_logic;
  signal app_done  : std_logic;
  signal app_ready : std_logic;
  signal app_idle  : std_logic;

  signal dma_rd_req        : std_logic;
  signal dma_rd_req_ack    : std_logic;
  signal rd_addr_slv       : std_logic_vector(63 downto 0);
  signal rd_addr           : unsigned(63 downto 0);
  signal rd_len            : unsigned(7 downto 0);
  signal rd_len_slv        : std_logic_vector(7 downto 0);
  signal dma_rd_data       : std_logic_vector(511 downto 0);
  signal dma_rd_data_valid : std_logic;
  signal dma_rd_data_taken : std_logic;

  signal dma_wr_req         : std_logic;
  signal dma_wr_req_ack     : std_logic;
  signal wr_addr            : unsigned(63 downto 0);
  signal wr_addr_slv        : std_logic_vector(63 downto 0);
  signal wr_len             : unsigned(7 downto 0);
  signal wr_len_slv         : std_logic_vector(7 downto 0);
  signal wr_data            : std_logic_vector(511 downto 0);
  signal dma_wr_data_strobe : std_logic_vector(63 downto 0);
  signal dma_wr_data_valid  : std_logic;
  signal dma_wr_data_last   : std_logic;
  signal dma_wr_ready       : std_logic;
  signal dma_wr_bready      : std_logic;
  signal dma_wr_done        : std_logic;

  signal start_read  : std_logic;
  signal start_write : std_logic;
  signal set_weights : std_logic;

  signal int_enable      : std_logic;
  signal last_read_done  : std_logic;
  signal last_write_done : std_logic;

  signal reading, read_waiting, writing, write_waiting : std_logic;
  signal blocks_to_read, blocks_to_write : unsigned(23 downto 0);
  signal wr_done_count, wr_req_count : unsigned(17 downto 0);

  signal total_write_lines, write_count : unsigned(23 downto 0);
  
  function or_reduce (signal arg : unsigned) return std_logic is
    variable result : std_logic;
    variable tmp : std_logic_vector(arg'high downto arg'low);
  begin
    tmp := std_logic_vector(arg);
    result := '0';
    for i in arg'low to arg'high loop
      result := result or arg(i);
    end loop;  -- i
    return result;
  end or_reduce;



  signal data_m_axis_tdata    : std_logic_vector(511 downto 0);
  signal data_m_axis_tready   : std_logic;
  signal data_m_axis_tvalid   : std_logic;
  signal data_s_axis_tdata    : std_logic_vector(511 downto 0);
  signal data_s_axis_tready   : std_logic;
  signal data_s_axis_tvalid   : std_logic;
  signal weight_m_axis_tdata  : std_logic_vector(511 downto 0);
  signal weight_m_axis_tready : std_logic;
  signal weight_m_axis_tvalid : std_logic;
  signal user_status          : std_logic_vector(127 downto 0);

begin

  int_ctx <= reg_0x20(CONTEXT_BITS - 1 downto 0);
  int_src <= "00";


-- Instantiation of Axi Bus Interface AXI_CTRL_REG
  action_axi_slave_inst : entity work.action_axi_slave
    generic map (
      C_S_AXI_DATA_WIDTH => C_AXI_CTRL_REG_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH => C_AXI_CTRL_REG_ADDR_WIDTH
      )
    port map (
      -- config reg ; bit 0 => disable dma and
      -- just count down the length regsiter
      int_enable_o  => int_enable,
      reg_0x10_i    => x"1014_0000",    -- action type
      reg_0x14_i    => x"0000_0000",    -- action version
      reg_0x20_o    => reg_0x20,
      reg_0x30_o    => reg_0x30,
      -- low order source address
      reg_0x34_o    => reg_0x34,
      -- high order source  address
      reg_0x38_o    => reg_0x38,
      -- low order destination address
      reg_0x3c_o    => reg_0x3c,
      -- high order destination address
      reg_0x40_o    => reg_0x40,
      -- number of bytes to copy
      reg_0x44_o    => reg_0x44,
      app_start_o   => app_start,
      app_done_i    => app_done,
      app_ready_i   => app_ready,
      app_idle_i    => app_idle,
      -- User ports ends
      S_AXI_ACLK    => action_clk,
      S_AXI_ARESETN => action_rst_n,
      S_AXI_AWADDR  => axi_ctrl_reg_awaddr,
      -- S_AXI_AWPROT    => axi_ctrl_reg_awprot,
      S_AXI_AWVALID => axi_ctrl_reg_awvalid,
      S_AXI_AWREADY => axi_ctrl_reg_awready,
      S_AXI_WDATA   => axi_ctrl_reg_wdata,
      S_AXI_WSTRB   => axi_ctrl_reg_wstrb,
      S_AXI_WVALID  => axi_ctrl_reg_wvalid,
      S_AXI_WREADY  => axi_ctrl_reg_wready,
      S_AXI_BRESP   => axi_ctrl_reg_bresp,
      S_AXI_BVALID  => axi_ctrl_reg_bvalid,
      S_AXI_BREADY  => axi_ctrl_reg_bready,
      S_AXI_ARADDR  => axi_ctrl_reg_araddr,
      -- S_AXI_ARPROT    => axi_ctrl_reg_arprot,
      S_AXI_ARVALID => axi_ctrl_reg_arvalid,
      S_AXI_ARREADY => axi_ctrl_reg_arready,
      S_AXI_RDATA   => axi_ctrl_reg_rdata,
      S_AXI_RRESP   => axi_ctrl_reg_rresp,
      S_AXI_RVALID  => axi_ctrl_reg_rvalid,
      S_AXI_RREADY  => axi_ctrl_reg_rready
      );

-- Instantiation of Axi Bus Interface AXI_HOST_MEM
  action_dma_axi_master_inst : entity work.action_axi_master
    generic map (

      C_M_AXI_ID_WIDTH     => C_AXI_HOST_MEM_ID_WIDTH,
      C_M_AXI_ADDR_WIDTH   => C_AXI_HOST_MEM_ADDR_WIDTH,
      C_M_AXI_DATA_WIDTH   => C_AXI_HOST_MEM_DATA_WIDTH,
      C_M_AXI_AWUSER_WIDTH => C_AXI_HOST_MEM_AWUSER_WIDTH,
      C_M_AXI_ARUSER_WIDTH => C_AXI_HOST_MEM_ARUSER_WIDTH,
      C_M_AXI_WUSER_WIDTH  => C_AXI_HOST_MEM_WUSER_WIDTH,
      C_M_AXI_RUSER_WIDTH  => C_AXI_HOST_MEM_RUSER_WIDTH,
      C_M_AXI_BUSER_WIDTH  => C_AXI_HOST_MEM_BUSER_WIDTH
      )
    port map (

      dma_rd_req_i        => dma_rd_req,
      dma_rd_addr_i       => rd_addr_slv,
      dma_rd_len_i        => rd_len_slv,
      dma_rd_req_ack_o    => dma_rd_req_ack,
      dma_rd_data_o       => dma_rd_data,
      dma_rd_data_valid_o => dma_rd_data_valid,
      dma_rd_data_taken_i => dma_rd_data_taken,
      dma_rd_context_id   => reg_0x20(C_AXI_HOST_MEM_ARUSER_WIDTH - 1 downto 0),

      dma_wr_req_i         => dma_wr_req,
      dma_wr_addr_i        => wr_addr_slv,
      dma_wr_len_i         => wr_len_slv,
      dma_wr_req_ack_o     => dma_wr_req_ack,
      dma_wr_data_i        => wr_data,
      dma_wr_data_strobe_i => dma_wr_data_strobe,
      dma_wr_data_last_i   => dma_wr_data_last,
      dma_wr_ready_o       => dma_wr_ready,
      dma_wr_bready_i      => dma_wr_bready,
      dma_wr_done_o        => dma_wr_done,
      dma_wr_context_id    => reg_0x20(C_AXI_HOST_MEM_AWUSER_WIDTH - 1 downto 0),


      M_AXI_ACLK    => action_clk,
      M_AXI_ARESETN => action_rst_n,
      M_AXI_AWID    => axi_host_mem_awid,
      M_AXI_AWADDR  => axi_host_mem_awaddr,
      M_AXI_AWLEN   => axi_host_mem_awlen,
      M_AXI_AWSIZE  => axi_host_mem_awsize,
      M_AXI_AWBURST => axi_host_mem_awburst,
      M_AXI_AWLOCK  => axi_host_mem_awlock(0),
      M_AXI_AWCACHE => axi_host_mem_awcache,
      M_AXI_AWPROT  => axi_host_mem_awprot,
      M_AXI_AWQOS   => axi_host_mem_awqos,
      M_AXI_AWUSER  => axi_host_mem_awuser,
      M_AXI_AWVALID => axi_host_mem_awvalid,
      M_AXI_AWREADY => axi_host_mem_awready,
      M_AXI_WDATA   => axi_host_mem_wdata,
      M_AXI_WSTRB   => axi_host_mem_wstrb,
      M_AXI_WLAST   => axi_host_mem_wlast,
      M_AXI_WUSER   => axi_host_mem_wuser,
      M_AXI_WVALID  => axi_host_mem_wvalid,
      M_AXI_WREADY  => axi_host_mem_wready,
      M_AXI_BID     => axi_host_mem_bid,
      M_AXI_BRESP   => axi_host_mem_bresp,
      M_AXI_BUSER   => axi_host_mem_buser,
      M_AXI_BVALID  => axi_host_mem_bvalid,
      M_AXI_BREADY  => axi_host_mem_bready,
      M_AXI_ARID    => axi_host_mem_arid,
      M_AXI_ARADDR  => axi_host_mem_araddr,
      M_AXI_ARLEN   => axi_host_mem_arlen,
      M_AXI_ARSIZE  => axi_host_mem_arsize,
      M_AXI_ARBURST => axi_host_mem_arburst,
      M_AXI_ARLOCK  => axi_host_mem_arlock(0),
      M_AXI_ARCACHE => axi_host_mem_arcache,
      M_AXI_ARPROT  => axi_host_mem_arprot,
      M_AXI_ARQOS   => axi_host_mem_arqos,
      M_AXI_ARUSER  => axi_host_mem_aruser,
      M_AXI_ARVALID => axi_host_mem_arvalid,
      M_AXI_ARREADY => axi_host_mem_arready,
      M_AXI_RID     => axi_host_mem_rid,
      M_AXI_RDATA   => axi_host_mem_rdata,
      M_AXI_RRESP   => axi_host_mem_rresp,
      M_AXI_RLAST   => axi_host_mem_rlast,
      M_AXI_RUSER   => axi_host_mem_ruser,
      M_AXI_RVALID  => axi_host_mem_rvalid,
      M_AXI_RREADY  => axi_host_mem_rready
      );


  rd_addr_slv <= std_logic_vector(rd_addr);
  wr_addr_slv <= std_logic_vector(wr_addr);
  rd_len_slv <= std_logic_vector(rd_len);
  wr_len_slv <= std_logic_vector(wr_len);
  
  
  process(action_clk) is
  begin
    if (rising_edge (action_clk)) then
      start_read  <= '0';
      start_write <= '0';
      if reg_0x30(3 downto 0) = x"2" then
        set_weights <= '1';
      else
        set_weights <= '0';
      end if;
      if (action_rst_n = '0') then
        fsm_app_q <= IDLE;
        app_ready <= '0';
        app_idle  <= '0';
      else
        app_done  <= '0';
        app_idle  <= '0';
        app_ready <= '1';
        case fsm_app_q is
          when IDLE =>
            app_idle <= '1';
            int_req  <= '0';

            if app_start = '1' then
              case reg_0x30(3 downto 0) is
                when x"2" =>
                  -- set up layer weights
                  fsm_app_q  <= WAIT_FOR_WEIGHT_DONE;
                  start_read <= '1';
                when x"3" =>
                  -- push weight data through
                  start_read  <= '1';
                  start_write <= '1';
                  fsm_app_q   <= WAIT_FOR_CONV_DONE;
                when others =>
                  app_done <= '1';
              end case;
            end if;
            
          when WAIT_FOR_WEIGHT_DONE =>
            if last_read_done = '1' then
              app_done  <= '1';
              int_req   <= '1' and int_enable;
              fsm_app_q <= IDLE;
            end if;

          when WAIT_FOR_CONV_DONE =>
            if last_write_done = '1' then
              app_done  <= '1';
              int_req   <= '1' and int_enable;
              fsm_app_q <= IDLE;
            end if;


          when others => null;
        end case;
      end if;
    end if;
  end process;


  reader_fsm : process(action_clk)
  begin
    if rising_edge(action_clk) then
      if reading = '0' and read_waiting = '0' then
        if start_read = '1' then
          reading <= '1';
          if set_weights = '1' then
            blocks_to_read <= to_unsigned(288,24);
          else
            blocks_to_read <= to_unsigned(2354,13)*unsigned(reg_0x44(10 downto 0));
          end if;
        end if;
      else
        if dma_rd_req_ack = '1' and or_reduce(blocks_to_read) = '1' then
          rd_addr          <= rd_addr + 4096;
          if blocks_to_read > 64 then
            rd_len         <= to_unsigned(63,8);
            blocks_to_read <= blocks_to_read - 64;
          else
            rd_len         <= blocks_to_read(7 downto 0) - 1;
            blocks_to_read <= (others => '0');
          end if;
        end if;
        if dma_rd_req_ack = '1' and or_reduce(blocks_to_read) = '0' then
          reading <= '0';
          read_waiting <= '1';
        end if;

        -- Detect end of read data
        -- TO FIX: should count words
        if read_waiting = '1' and dma_rd_data_valid = '0' then
          read_waiting <= '0';
        end if;
      end if;
      if action_rst_n = '0' then
        reading <= '0';
        read_waiting <= '0';
      end if;
    end if;
  end process;

  writer_fsm : process(action_clk)
  begin
    if rising_edge(action_clk) then
      if writing = '0' and write_waiting = '0' then
        if start_write = '1' then
          writing <= '1';        
          blocks_to_write <= to_unsigned(4538,13)*unsigned(reg_0x44(10 downto 0));
          dma_wr_bready <= '1';
          total_write_lines <= to_unsigned(4538,13)*unsigned(reg_0x44(10 downto 0));
        end if;
        wr_done_count <= to_unsigned(0,18);
        wr_req_count <= to_unsigned(0,18);
        write_count <= to_unsigned(1,24);
      else
        if dma_wr_req_ack = '1' and or_reduce(blocks_to_write) = '1' then
          wr_addr          <= wr_addr + 4096;
          if blocks_to_write > 64 then
            wr_len         <= to_unsigned(63,8);
            blocks_to_write <= blocks_to_write - 64;
          else
            wr_len         <= blocks_to_write(7 downto 0) - 1;
            blocks_to_write <= (others => '0');
          end if;
        end if;
        if dma_wr_req_ack = '1' and or_reduce(blocks_to_write) = '0' then
          writing <= '0';
          write_waiting <= '1';
        end if;

        if dma_wr_done = '1' then
          wr_done_count <= wr_done_count + 1;
        end if;
        if dma_wr_req = '1' and dma_wr_req_ack = '1' then
          wr_req_count <= wr_req_count + 1;
        end if;

        if write_waiting = '1' then
          if wr_req_count = wr_done_count then
            last_write_done <= '1';
            write_waiting <= '0';
            dma_wr_bready <= '0';
          end if;
        end if;
        if data_s_axis_tvalid = '1' and dma_wr_ready = '1' then
          write_count <= write_count+1;
        end if;
      end if;
      if action_rst_n = '0' then
        writing <= '0';
        write_waiting <= '0';
        dma_wr_bready <= '0';
      end if;
    end if;
  end process;
  dma_rd_req <= reading;
  dma_wr_req <= writing;


  -- Map DMA to AXI-Streams
  data_m_axis_tdata <= dma_rd_data;
  weight_m_axis_tdata <= dma_rd_data;
  
  data_m_axis_tvalid <= dma_rd_data_valid and not set_weights;
  weight_m_axis_tvalid <= dma_rd_data_valid and set_weights;
  
  dma_rd_data_taken <= (data_m_axis_tready and dma_rd_data_valid and not set_weights) or (weight_m_axis_tready and dma_rd_data_valid and set_weights);

  wr_data <= data_s_axis_tdata;
  dma_wr_data_valid <= data_s_axis_tvalid;
  dma_wr_data_strobe <= (others => dma_wr_data_valid);
  data_s_axis_tready <= dma_wr_ready;
  
  dma_wr_data_last <= '1' when total_write_lines = write_count or write_count(5 downto 0) = "000000" else '0';
  
  

  snap_cnn_layer_1: entity work.snap_cnn_layer
    port map (
      aclk                 => action_clk,
      areset_n             => action_rst_n,
      data_m_axis_tdata    => data_m_axis_tdata,
      data_m_axis_tready   => data_m_axis_tready,
      data_m_axis_tvalid   => data_m_axis_tvalid,
      data_s_axis_tdata    => data_s_axis_tdata,
      data_s_axis_tready   => data_s_axis_tready,
      data_s_axis_tvalid   => data_s_axis_tvalid,
      weight_m_axis_tdata  => weight_m_axis_tdata,
      weight_m_axis_tready => weight_m_axis_tready,
      weight_m_axis_tvalid => weight_m_axis_tvalid,
      user_status          => user_status);
  
end action_example;
