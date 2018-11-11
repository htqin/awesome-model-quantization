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
-- sim_zfnet_layer0.vhd
-- Simulation Only VHDL for Convolutional Neuron Layer
-- Used to verify fixed point behaviour
-- Reads in data from file to test
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use std.textio.all; --  Imports the standard textio package.

entity sim_anet_layer0 is
end entity;

architecture test of sim_anet_layer0 is

  constant input_feature_width         : natural := 8;
  constant input_no_features: natural := 3;
  constant input_feature_plane_width   : natural := 224;
  constant input_feature_plane_height  : natural := 224;
  
  constant input_mask_width            : natural := 11;
  constant input_mask_height           : natural := 11;
  constant input_stride                : natural := 4;
  constant layer_size                  : natural := 96;
  constant weight_width                : natural := 8;
  
  constant output_width                : natural := 8;
  constant output_shift                : natural := 6;

  constant bias_shift                : natural := 3;
  
  constant post_filter_width   : natural := 110;
  constant post_filter_height  : natural := 110;
  
  constant maxpool_mask_width          : natural := 3;
  constant maxpool_mask_height         : natural := 3;
  constant maxpool_stride              : natural := 2;
  
  constant no_weights : natural := input_no_features * input_mask_width * input_mask_height;
  constant no_weight_bits                : natural := 8; -- log2(no_weights)

  constant output_tensor_width   : natural := 55;
  constant output_tensor_height  : natural := 55;
  
  
  type input_channels_type is array (1 to input_no_features) of signed(input_feature_width -1 downto 0);
  type input_line_type is array(1 to input_feature_plane_width) of input_channels_type;
  type input_tensor_type is array(1 to input_feature_plane_height) of input_line_type;

  type weight_vector_type is array(1 to no_weights) of signed(weight_width-1 downto 0);
  type weight_matrix_type is array(1 to layer_size) of weight_vector_type;

  type bias_vector_type is array(1 to layer_size) of signed(weight_width-1 downto 0);
  
  
  type mask_region_line_type is array(1 to input_mask_width) of input_channels_type;
  type mask_region_tensor_type is array(1 to input_mask_height) of mask_region_line_type;


  type post_filter_channels_type is array (1 to layer_size) of unsigned(output_width -1 downto 0);
  type post_filter_line_type is array(1 to post_filter_width) of post_filter_channels_type;
  type post_filter_tensor_type is array(1 to post_filter_height) of post_filter_line_type;

  type output_channels_type is array (1 to layer_size) of unsigned(output_width -1 downto 0);
  type output_line_type is array(1 to output_tensor_width) of output_channels_type;
  type output_tensor_type is array(1 to output_tensor_height) of output_line_type;

  constant input_bias : integer := 128;
  constant weight_scaling : integer := 16777216/2;
  constant bias_scaling : integer := weight_scaling * (2**bias_shift);
  
begin

  -- Sequential Process
  process
    variable seed1, seed2: positive;
    variable rand: real;
    variable int_rand: integer;
    variable l : line;
    -- Use text files for maximum portability
    file input_file : text is in "input_data.txt";
    file weight_file : text is in "places205CNN_conv1_filter.txt";
    file bias_file : text is in "places205CNN_conv1_bias.txt";

    variable outcount : integer := 0;
    variable int_output : integer := 0;
    file output_file : text is out "output_data.txt";
    variable ol : line;
    
    variable il : line;
    variable int_file: integer;
    variable input_tensor : input_tensor_type;
    variable weights : weight_matrix_type;
    variable bias : bias_vector_type;

    variable mask_region_tensor : mask_region_tensor_type;
    
    variable weight_pos : integer;
    variable signed_feature : signed(input_feature_width-1 downto 0);
    variable neuron_product : signed(input_feature_width+weight_width-1 downto 0);
    variable neuron_acc : signed(no_weight_bits + input_feature_width+weight_width downto 0);
    variable neuron_out : unsigned(output_width-1 downto 0);
    variable post_filter_tensor : post_filter_tensor_type;
    variable output_tensor : output_tensor_type;

    variable start_row : integer;
    variable start_col : integer;
    
  begin
    write (l, string'("Test Bench for Convolutional Neuron Layer"));
    writeline (output, l);
    write (l, string'("Parameters: "));
    writeline (output, l);
    write (l, string'("Feature planes, mask size: "));
    write (l, input_no_features);
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
    write (l, string'("Layer size: "));
    write (l, layer_size);
    writeline (output, l);
   

    --
    -- Initialize Neurons with weights
    --

    for n in 1 to layer_size loop
      write (l, string'("Reading in weights, for neuron #"));
      write(l,n);
      writeline (output, l);
      if not endfile(bias_file) then
        readline(bias_file,il);
        read(il,int_file);
      else
        write (l, string'("Input file too small"));
        writeline(output,l);
      end if;
      int_file := int_file/bias_scaling; -- Shift down bias as text
                                           -- file is Bias * 2^31
      bias(n) := to_signed(int_file, weight_width);
      -- First weight is the BIAS
      write (l, string'("Bias: "));   
      write (l, int_file);
      writeline (output, l);
      weight_pos := 1;
      for j in 1 to input_mask_height loop
        for k in 1 to input_mask_width loop
          for i in 1 to input_no_features loop
            if not endfile(weight_file) then
              readline(weight_file,il);
              read(il,int_file);
            else
              write (l, string'("Input file too small"));
              writeline(output,l);
            end if;
            int_file := int_file/weight_scaling; -- Shift down weights as text
                                                 -- file is W * 2^31
            -- Perform BGR to RGB channel order conversion for input layer
            -- Should really be
            -- weights(n)(weight_pos) := to_signed(int_file, weight_width);
            if i=1 then
              weights(n)(weight_pos+2) := to_signed(int_file, weight_width);
            elsif i=2 then
              weights(n)(weight_pos) := to_signed(int_file, weight_width);
            else
              weights(n)(weight_pos-2) := to_signed(int_file, weight_width);
            end if;
            weight_pos := weight_pos+1;
                 
            write (l, int_file);
            write (l, string'(" "));            
          end loop;
          write (l, string'(" : "));
        end loop;
        writeline (output, l);
      end loop;
    end loop;

    --
    -- Read image data in layer input
    --
    
    for batch in 1 to 1 loop
      write (l, string'("Reading File"));
      writeline(output,l);
      for i in 1 to input_feature_plane_height loop        
        for j in 1 to input_feature_plane_width loop
          for k in 1 to input_no_features loop
            if not endfile(input_file) then
              readline(input_file,il);
              read(il,int_file);
            else
              write (l, string'("Input file too small"));
              writeline(output,l);
            end if;
            int_file := int_file-input_bias;
            input_tensor(i)(j)(k) := to_signed(int_file, input_feature_width);  
            
            
          end loop;
        end loop;   
      end loop;
      

      --
      -- Scan across input image
      --
      write (l, string'("Running Neuron layer"));
      writeline(output,l);
      for i in 1 to post_filter_height loop
        write (l, string'("Line #"));
        write (l,i);
        writeline(output,l);
        for j in 1 to post_filter_width loop
          -- Read in Filter input Tensor
          start_row := input_stride*i-5;
          start_col := input_stride*j-5;
          for ii in 1 to input_mask_height loop
            for jj in 1 to input_mask_width loop
              for kk in 1 to input_no_features loop
                if start_row+ii >0 and start_row+ii <= input_feature_plane_height and start_col+jj >0 and start_col+jj <= input_feature_plane_width then              
                  mask_region_tensor(ii)(jj)(kk) := input_tensor(start_row+ii)(start_col+jj)(kk);
                else
                  -- Zero pad data outsite image
                  mask_region_tensor(ii)(jj)(kk) := to_signed(0,input_feature_width);
                end if;
              end loop;
            end loop;
          end loop;
          -- Implement Neurons
          for n in 1 to layer_size loop
            neuron_acc := shift_left(resize(bias(n),neuron_acc'length),bias_shift);
            weight_pos := 1;
            for ii in 1 to input_mask_height loop
              for jj in 1 to input_mask_width loop
                for kk in 1 to input_no_features loop
                  -- Convert Unsigned feature to signed, with extra bit
                  signed_feature := mask_region_tensor(ii)(jj)(kk);
                  neuron_product := signed_feature * weights(n)(weight_pos);
                  weight_pos := weight_pos+1;
                  neuron_acc := neuron_acc+resize(neuron_product,neuron_acc'length);
                end loop;
              end loop;
            end loop;
            -- ReLU
            if neuron_acc(no_weight_bits + input_feature_width+weight_width) = '1' then
              -- if negative
              neuron_out := to_unsigned(0,output_width);
            else
              -- Check for overflow
              if output_shift+output_width < no_weight_bits + input_feature_width+weight_width-1 then
                if to_integer(neuron_acc(no_weight_bits + input_feature_width+weight_width-1 downto output_shift+output_width)) /= 0 then
                  -- Check for overflow
                  neuron_out := (others => '1'); -- Saturate              
                else
                  neuron_out := unsigned(std_logic_vector(neuron_acc(output_shift+output_width-1 downto output_shift)));
                end if;         
              else
                neuron_out := unsigned(std_logic_vector(neuron_acc(output_shift+output_width-1 downto output_shift)));
              end if;            
            end if;
            post_filter_tensor(i)(j)(n) := neuron_out;
          end loop;
        end loop;
      end loop;

  
      -- No Max Pooling Layer
      for i in 1 to output_tensor_height loop
        write (l, string'("Line #"));
        write (l,i);
        writeline(output,l);
        for j in 1 to output_tensor_width loop
          for kk in 1 to layer_size loop
            output_tensor(i)(j)(kk):=  post_filter_tensor(i)(j)(kk);       
          end loop;               
        end loop;
      end loop;


      -- Write output to file
      write (l, string'("Writing output to File"));
      writeline(output,l);
      for i in 1 to output_tensor_height loop
        write (l, string'("Line #"));
        write (l,i);
        writeline(output,l);
        for j in 1 to output_tensor_width loop
          for kk in 1 to layer_size loop
            int_output := to_integer(output_tensor(i)(j)(kk));
            write( ol, int_output);
            writeline( output_file, ol);
            outcount := outcount+1;
          end loop;
        end loop;
      end loop;
    end loop; 
    write (l, string'("Closing file: "));
    write (l, outcount);          
    writeline (output, l);
    file_close(output_file);
     
    wait;
  end process;


    
end test;
