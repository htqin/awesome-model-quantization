--
-- tb_conv_neuron.vhd
-- Testbench for Convolutional Neuron Layer
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all; --  Imports the standard textio package.

entity tb_zfnet_layer0 is
end entity;

architecture test of tb_zfnet_layer0 is

  constant input_feature_width         : natural := 8;
  constant input_no_feature_planes_par : natural := 3;
  constant input_no_feature_planes_ser : natural := 1;
  constant input_feature_plane_width   : natural := 224;
  constant input_feature_plane_height  : natural := 224;
  constant zero_pad_top : natural := 2;
  constant zero_pad_bottom : natural := 1;
  constant zero_pad_left : natural := 2;
  constant zero_pad_right : natural := 1;
  constant zero_padding                : natural := 1;
  constant input_mask_width            : natural := 7;
  constant input_mask_height           : natural := 7;
  constant input_stride                : natural := 2;
  constant narrow_buffer_depth         : natural := 10;
  constant narrow_accept_space         : natural := 256;
  constant no_par_layers               : natural := 1;
  constant layer_size                  : natural := 96;
  constant layer_size_order            : natural := 7;
  constant weight_width                : natural := 8;
  constant weight_mem_order            : natural := 8;
  constant output_width                : natural := 8;
  constant output_shift                : natural := 0;
  constant ReLU                        : boolean := true;
  constant output_par_widen_factor     : natural := 8;
  constant use_maxpool                 : boolean := true;
  constant maxpool_mask_width          : natural := 3;
  constant maxpool_mask_height         : natural := 3;
  constant maxpool_stride              : natural := 2;
  
  constant no_weights : natural := input_no_feature_planes_ser * input_no_feature_planes_par * input_mask_width * input_mask_height;
  
  signal clk            : std_logic := '0';
  signal rst            : std_logic := '0';
  signal feature_stream : std_logic_vector(input_feature_width*input_no_feature_planes_par-1 downto 0):= (others => '0');
  signal feature_valid  : std_logic := '0';
  signal feature_ready   : std_logic := '0';
  signal weight_stream  : std_logic_vector(weight_width-1 downto 0):= (others => '0');
  signal weight_id  : std_logic_vector(layer_size_order-1 downto 0):= (others => '0');
  signal weight_first   : std_logic_vector(no_par_layers-1 downto 0) := (others => '0');
  signal weight_last    : std_logic_vector(no_par_layers-1 downto 0) := (others => '0');
  signal stream_out  : std_Logic_vector(output_width*output_par_widen_factor*no_par_layers-1 downto 0) := (others => '0');
  
  signal stream_out_valid   : std_logic := '0';
  signal stream_out_ready   : std_logic := '1';


  component zfnet_layer is
    generic (
      input_feature_width         : natural;
      input_no_feature_planes_par : natural;
      input_no_feature_planes_ser : natural;
      input_feature_plane_width   : natural;
      input_feature_plane_height  : natural;
       zero_pad_top : natural;
    zero_pad_bottom : natural;
    zero_pad_left : natural;
    zero_pad_right : natural;
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

  
  
  
begin

  clk <= not clk after 2 ns; -- Simulate 250MHz Clock
  
  zfnet_layer_1: zfnet_layer
    generic map (
      input_feature_width         => input_feature_width,
      input_no_feature_planes_par => input_no_feature_planes_par,
      input_no_feature_planes_ser => input_no_feature_planes_ser,
      input_feature_plane_width   => input_feature_plane_width,
      input_feature_plane_height  => input_feature_plane_height,
       zero_pad_top => zero_pad_top,
        zero_pad_bottom => zero_pad_bottom,
        zero_pad_left => zero_pad_left,
        zero_pad_right => zero_pad_right,
      input_mask_width            => input_mask_width,
      input_mask_height           => input_mask_height,
      input_stride                => input_stride,
      narrow_buffer_depth         => narrow_buffer_depth,
      narrow_accept_space         => narrow_accept_space,
      no_par_layers               => no_par_layers,
      layer_size                  => layer_size,
      layer_size_order            => layer_size_order,
      weight_width                => weight_width,
      weight_mem_order            => weight_mem_order,
      output_width                => output_width,
      output_shift                => output_shift,
      ReLU                        => ReLU,
      output_par_widen_factor     => output_par_widen_factor,
      use_maxpool                 => use_maxpool,
      maxpool_mask_width          => maxpool_mask_width,
      maxpool_mask_height         => maxpool_mask_height,
      maxpool_stride              => maxpool_stride)
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



  process
    variable seed1, seed2: positive;
    variable rand: real;
    variable int_rand: integer;
    variable l : line;
  begin
    write (l, string'("Test Bench for Convolutional Neuron"));
    writeline (output, l);
    write (l, string'("Parameters: "));
    writeline (output, l);
    write (l, string'("Feature planes, mask size: "));
    write (l, input_no_feature_planes_ser);
    write (l, string'(" x "));
    write (l, input_no_feature_planes_par);
    write (l, string'(" x "));
    write (l, input_mask_height);
    write (l, string'(" x "));
    write (l, input_mask_width);
    write (l, string'(" = "));
    write (l, no_weights);
    write (l, string'(" weights"));
    writeline (output, l);
    write (l, string'("Feature plane size: "));
    write (l, input_feature_plane_height);
    write (l, string'(" x "));  
    write (l, input_feature_plane_width);
    writeline (output, l);
    write (l, string'("Feature plane stride: "));
    write (l, input_stride);
    writeline (output, l);
    write (l, string'("Feature bit_width: "));
    write (l, input_feature_width);
    writeline (output, l);
    write (l, string'("Weight bit_width: "));
    write (l, weight_width);
    writeline (output, l);
    write (l, string'("Output bit_width: "));
    write (l, output_width);
    writeline (output, l);
    write (l, string'("Output scaling: 2^-"));
    write (l, output_shift);
    writeline (output, l);   
    if ReLU then
      write (l, string'("Using ReLU non-linearity"));   
      writeline (output, l);
    end if;
    write (l, string'("Layer size: "));
    write (l, layer_size);
    writeline (output, l);
    write (l, string'("Output widen factor: "));
    write (l, output_par_widen_factor);
    writeline (output, l);
    if use_maxpool then
      write (l, string'("Maxpool size, stride: "));
      write (l, maxpool_mask_height);
      write (l, string'(" x "));
      write (l, maxpool_mask_width);
      write (l, string'(" , "));
      write (l, maxpool_stride);
      writeline (output, l);
    end if;

    --
    -- Initialize Neurons with weights
    -- 

    wait for 12 ns;

    for n in 1 to layer_size loop
      for pl in 0 to no_par_layers-1 loop
      write (l, string'("Generating weights, for neuron #"));
      write(l,n);
      write (l, string'(" Parallel Layer #"));
      write(l,pl+1);
      writeline (output, l);
      weight_id <= std_Logic_vector(to_unsigned(n,layer_size_order));
      wait until clk = '1';
      wait until clk = '0';
      weight_first(pl) <= '1';
      
      UNIFORM(seed1, seed2, rand);
      int_rand := INTEGER(TRUNC(rand*(2.0**weight_width)));
      weight_stream <= std_logic_vector(to_unsigned(int_rand, weight_width));
      -- First weight is the BIAS
      write (l, string'("Bias: "));
      int_rand := to_integer(signed(std_logic_vector(to_unsigned(int_rand, weight_width))));
      write (l, int_rand);
      writeline (output, l);
      wait until clk = '1';
      wait until clk = '0';
      weight_first(pl) <= '0';    
      for j in 1 to input_mask_height loop
        for k in 1 to input_mask_width loop
          for i in 1 to input_no_feature_planes_par*input_no_feature_planes_ser loop
            UNIFORM(seed1, seed2, rand);
            int_rand := INTEGER(TRUNC(rand*(2.0**weight_width)));
            weight_stream <= std_logic_vector(to_unsigned(int_rand, weight_width));
            if i=input_no_feature_planes_par*input_no_feature_planes_ser and j= input_mask_height and k=input_mask_width then
              weight_last(pl) <= '1';
            end if;
            
            int_rand := to_integer(signed(std_logic_vector(to_unsigned(int_rand, weight_stream'LENGTH))));
            write (l, int_rand);
            write (l, string'(" "));
            wait until clk = '1';
            wait until clk = '0';        
          end loop;
          write (l, string'(" : "));
        end loop;
        writeline (output, l);
      end loop;
      weight_last(pl) <= '0';
      wait until clk = '1';
      wait until clk = '0';
      end loop;
    end loop;
    
    --
    -- Throw image data at layer
    --
    for batch in 1 to 100 loop
      wait until clk = '1';
      wait until clk = '0';
      feature_valid <= '1';
      for i in 1 to input_feature_plane_height loop
        for j in 1 to input_feature_plane_width loop
          for k in 1 to input_no_feature_planes_ser loop
            for p in 1 to input_no_feature_planes_ser loop
              UNIFORM(seed1, seed2, rand);
              int_rand := INTEGER(TRUNC(rand*(2.0**input_feature_width)));
              feature_stream(p*input_feature_width-1 downto (p-1)*input_feature_width) <= std_logic_vector(to_unsigned(int_rand, input_feature_width));
            
              int_rand := to_integer(signed(std_logic_vector(to_unsigned(int_rand, input_feature_width))));
              write (l, int_rand);
              write (l, string'(" "));
            end loop;
            wait until clk = '1';
            wait until clk = '0';
            while feature_ready = '0' loop
              wait until clk = '1';
              wait until clk = '0';
            end loop;
          end loop;
        end loop;     
      end loop;
      writeline (output, l);
      feature_valid <= '0';
    end loop;
    wait;
  end process;

  -- Print out neuron outputs
  process(clk)
    variable l : line;
    variable int_output : integer;
  begin
    if rising_edge(clk) then
      if stream_out_valid = '1' then
        -- Output is unsigned if ReLU used
        for i in 0 to output_par_widen_factor*no_par_layers-1 loop
          if ReLU then
            int_output := to_integer(unsigned(stream_out((i+1)*output_width-1 downto i*output_width)));
          else
            int_output := to_integer(signed(stream_out((i+1)*output_width-1 downto i*output_width)));
          end if;
       
          write (l, int_output);
          write (l, string'(","));
        end loop;
        writeline (output, l);
      end if;
    end if;
  end process;
  

  
end test;
