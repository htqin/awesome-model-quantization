
set today [clock format [clock seconds] -format "%y%m%d"]

exec rm -fr proj/zfnet_fpga_pcie_v$today
exec mkdir proj/zfnet_fpga_pcie_v$today

create_project -part xcku115-flva1517-2-e -force proj/zfnet_fpga_pcie_v$today/zfnet_fpga_pcie_v$today

import_files -force xdc/adb3_admpcie8k5-pcie_x0y0.xdc  
import_files -force xdc/bitstream.xdc  
import_files -force xdc/refclk200.xdc
import_files -force xci/axi_dwidth_converter_1.xci  
import_files -force xci/axi_protocol_converter_0.xci
import_files -force ../conv_neuron/conv_neuron.vhd
import_files -force ../conv_neuron_layer/conv_neuron_layer_ffanout.vhd
import_files -force ../feature_buffer/feature_buffer.vhd
import_files -force ../feature_buffer/feature_buffer_zf0.vhd
import_files -force ../conv_neuron/conv_neuron_par4.vhd
import_files -force ../conv_neuron_layer/conv_neuron_layer_par4.vhd
import_files -force ../conv_neuron/conv_neuron_par2.vhd
import_files -force ../conv_neuron_layer/conv_neuron_layer_par2.vhd
import_files -force ../maxpool/maxpool.vhd
import_files -force ../stream_tools/stream_narrow.vhd
import_files -force ../stream_tools/stream_narrow_6to4.vhd
import_files -force ../stream_tools/stream_widen.vhd
import_files -force ../stream_tools/stream_narrow_32to6.vhd
import_files -force ../stream_tools/stream_narrow_weights.vhd
import_files -force ../stream_tools/zero_pad_stream.vhd
import_files -force ../stream_tools/zero_pad_stream_mp.vhd
import_files -force ../zfnet/zfnet_layer.vhd
import_files -force ../zfnet/zfnet_layer0_opt.vhd
import_files -force ../zfnet/zfnet_layer1_opt.vhd
import_files -force ../zfnet/zfnet_layer3_opt.vhd
import_files -force ../zfnet/zfnet_opt.vhd
import_files -force vhdl/axi_dwidth_converter_1_wrap.vhd
import_files -force vhdl/axi_protocol_converter_0_wrap.vhd
import_files -force vhdl/axi4_field_pkg.vhd
import_files -force vhdl/axi4l_profile_pkg.vhd  
import_files -force vhdl/reg_bank_axi4l.vhd
import_files -force vhdl/axi4_profile_pkg.vhd 
import_files -force vhdl/reg_bank_axi4l_wrap.vhd
import_files -force vhdl/adb3_admpcie8k5_x8_axi4_0_wrap.vhd
import_files -force vhdl/admpcie8k5_zfnet_top1.vhd

start_gui

set_property "ip_repo_paths" "[file normalize "ip_repo"]" [current_project]
update_ip_catalog

update_ip_catalog -add_ip ip_repo/adb3_admpcie8k5_x8_axi4_v1_2.zip -repo_path "[file normalize "ip_repo"]"
update_ip_catalog


create_ip -name adb3_admpcie8k5_x8_axi4 -vendor alpha-data.com -library user -version 1.2 -module_name adb3_admpcie8k5_x8_axi4_0
set_property -dict [list CONFIG.number_of_dma_engines {3} CONFIG.dma_engine0_config {4} CONFIG.dma_engine1_config {3} CONFIG.dma_engine2_config {4} CONFIG.use_diff_ref_clock {false} CONFIG.generate_perst_on_configuration {true}] [get_ips adb3_admpcie8k5_x8_axi4_0]

report_ip_status -name ip_status 
upgrade_ip [get_ips  {axi_dwidth_converter_1 axi_protocol_converter_0}] -log ip_upgrade.log






