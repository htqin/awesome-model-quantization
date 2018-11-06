# PCIe reset
set_property PACKAGE_PIN AE15 [get_ports perst_n]
set_property IOSTANDARD LVCMOS18 [get_ports perst_n]
set_max_delay -from [get_ports perst_n] 100.000
set_min_delay -from [get_ports perst_n] -100.000
set_false_path -from [get_ports perst_n]

# PCIe reference clock
set_max_delay -from [get_ports pcie100_n] 100.000
set_min_delay -from [get_ports pcie100_n] -100.000
set_property PACKAGE_PIN AT9 [get_ports pcie100_n]
set_property PACKAGE_PIN AT10 [get_ports pcie100_p]
set_max_delay -from [get_ports pcie100_p] 100.000
set_min_delay -from [get_ports pcie100_p] -100.000

#fl_sel_n connected via startup block
#set_property PACKAGE_PIN AB9
#fl_oe_n
set_property PACKAGE_PIN AV16 [get_ports {model_inout_tri_io[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[0]}]
#fl_we_n
set_property PACKAGE_PIN AW16 [get_ports {model_inout_tri_io[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[1]}]
#fl_rst_n
set_property PACKAGE_PIN AF28 [get_ports {model_inout_tri_io[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[2]}]
#fl_adv_n
set_property PACKAGE_PIN AL15 [get_ports {model_inout_tri_io[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[3]}]
#fl_wait_n
set_property PACKAGE_PIN AE28 [get_ports {model_inout_tri_io[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[4]}]
#fl_a
set_property PACKAGE_PIN AJ15 [get_ports {model_inout_tri_io[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[5]}]
set_property PACKAGE_PIN AK15 [get_ports {model_inout_tri_io[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[6]}]
set_property PACKAGE_PIN AH14 [get_ports {model_inout_tri_io[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[7]}]
set_property PACKAGE_PIN AJ14 [get_ports {model_inout_tri_io[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[8]}]
set_property PACKAGE_PIN AL14 [get_ports {model_inout_tri_io[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[9]}]
set_property PACKAGE_PIN AL13 [get_ports {model_inout_tri_io[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[10]}]
set_property PACKAGE_PIN AL12 [get_ports {model_inout_tri_io[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[11]}]
set_property PACKAGE_PIN AM12 [get_ports {model_inout_tri_io[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[12]}]
set_property PACKAGE_PIN AM14 [get_ports {model_inout_tri_io[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[13]}]
set_property PACKAGE_PIN AN14 [get_ports {model_inout_tri_io[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[14]}]
set_property PACKAGE_PIN AN13 [get_ports {model_inout_tri_io[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[15]}]
set_property PACKAGE_PIN AN12 [get_ports {model_inout_tri_io[16]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[16]}]
set_property PACKAGE_PIN AP14 [get_ports {model_inout_tri_io[17]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[17]}]
set_property PACKAGE_PIN AP13 [get_ports {model_inout_tri_io[18]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[18]}]
set_property PACKAGE_PIN AR12 [get_ports {model_inout_tri_io[19]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[19]}]
set_property PACKAGE_PIN AT12 [get_ports {model_inout_tri_io[20]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[20]}]
set_property PACKAGE_PIN AP15 [get_ports {model_inout_tri_io[21]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[21]}]
set_property PACKAGE_PIN AR15 [get_ports {model_inout_tri_io[22]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[22]}]
set_property PACKAGE_PIN AR13 [get_ports {model_inout_tri_io[23]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[23]}]
set_property PACKAGE_PIN AT13 [get_ports {model_inout_tri_io[24]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[24]}]
set_property PACKAGE_PIN AT14 [get_ports {model_inout_tri_io[25]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[25]}]
set_property PACKAGE_PIN AU14 [get_ports {model_inout_tri_io[26]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[26]}]
set_property PACKAGE_PIN AU12 [get_ports {model_inout_tri_io[27]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[27]}]
set_property PACKAGE_PIN AV12 [get_ports {model_inout_tri_io[28]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[28]}]
set_property PACKAGE_PIN AV14 [get_ports {model_inout_tri_io[29]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[29]}]
set_property PACKAGE_PIN AW14 [get_ports {model_inout_tri_io[30]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[30]}]
#fl_d(0:3) connected via startup block
#set_property PACKAGE_PIN AE11
#set_property PACKAGE_PIN AD10
#set_property PACKAGE_PIN AC9
#set_property PACKAGE_PIN AD9
#fl_d(15:4)
set_property PACKAGE_PIN AF14 [get_ports {model_inout_tri_io[31]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[31]}]
set_property PACKAGE_PIN AG14 [get_ports {model_inout_tri_io[32]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[32]}]
set_property PACKAGE_PIN AE13 [get_ports {model_inout_tri_io[33]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[33]}]
set_property PACKAGE_PIN AF13 [get_ports {model_inout_tri_io[34]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[34]}]
set_property PACKAGE_PIN AF15 [get_ports {model_inout_tri_io[35]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[35]}]
set_property PACKAGE_PIN AG15 [get_ports {model_inout_tri_io[36]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[36]}]
set_property PACKAGE_PIN AG12 [get_ports {model_inout_tri_io[37]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[37]}]
set_property PACKAGE_PIN AH12 [get_ports {model_inout_tri_io[38]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[38]}]
set_property PACKAGE_PIN AK13 [get_ports {model_inout_tri_io[39]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[39]}]
set_property PACKAGE_PIN AK12 [get_ports {model_inout_tri_io[40]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[40]}]
set_property PACKAGE_PIN AH13 [get_ports {model_inout_tri_io[41]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[41]}]
set_property PACKAGE_PIN AJ13 [get_ports {model_inout_tri_io[42]}]
set_property IOSTANDARD LVCMOS18 [get_ports {model_inout_tri_io[42]}]
# AVR CK
set_property PACKAGE_PIN AW18 [get_ports {model_inout_tri_io[43]}]
set_property IOSTANDARD LVCMOS33 [get_ports {model_inout_tri_io[43]}]
# AVR TX (AVR to FPGA)
set_property PACKAGE_PIN AT17 [get_ports {model_inout_tri_io[44]}]
set_property IOSTANDARD LVCMOS33 [get_ports {model_inout_tri_io[44]}]
# AVR RX (FPGA to AVR)
set_property PACKAGE_PIN AT18 [get_ports {model_inout_tri_io[45]}]
set_property IOSTANDARD LVCMOS33 [get_ports {model_inout_tri_io[45]}]

set_max_delay -from [get_ports {model_inout_tri_io[*]}] 100.000
set_min_delay -from [get_ports {model_inout_tri_io[*]}] -100.000
set_max_delay -to [get_ports {model_inout_tri_io[*]}] 100.000
set_min_delay -to [get_ports {model_inout_tri_io[*]}] -100.000

