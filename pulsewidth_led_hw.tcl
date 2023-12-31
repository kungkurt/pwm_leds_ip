# TCL File Generated by Component Editor 18.1
# Sat Apr 08 13:37:21 CEST 2023
# DO NOT MODIFY


# 
# pulsewidth_led "Pulse Width Led" v1.0
# Robin Riis 2023.04.08.13:37:21
# setting up led pins with pulse width modulation
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module pulsewidth_led
# 
set_module_property DESCRIPTION "setting up led pins with pulse width modulation"
set_module_property NAME pulsewidth_led
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP riisen
set_module_property AUTHOR "Robin Riis"
set_module_property DISPLAY_NAME "Pulse Width Led"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL pw_leds_ip
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file pw_leds.vhd VHDL PATH hdl/pw_leds.vhd
add_fileset_file pw_leds_ip.vhd VHDL PATH hdl/pw_leds_ip.vhd TOP_LEVEL_FILE
add_fileset_file pw_pin.vhd VHDL PATH hdl/pw_pin.vhd


# 
# parameters
# 
add_parameter nr_of_leds INTEGER 10
set_parameter_property nr_of_leds DEFAULT_VALUE 10
set_parameter_property nr_of_leds DISPLAY_NAME nr_of_leds
set_parameter_property nr_of_leds TYPE INTEGER
set_parameter_property nr_of_leds UNITS None
set_parameter_property nr_of_leds HDL_PARAMETER true
add_parameter pulse_bits INTEGER 8
set_parameter_property pulse_bits DEFAULT_VALUE 8
set_parameter_property pulse_bits DISPLAY_NAME pulse_bits
set_parameter_property pulse_bits TYPE INTEGER
set_parameter_property pulse_bits UNITS None
set_parameter_property pulse_bits HDL_PARAMETER true
add_parameter clock_count_len NATURAL 196
set_parameter_property clock_count_len DEFAULT_VALUE 196
set_parameter_property clock_count_len DISPLAY_NAME clock_count_len
set_parameter_property clock_count_len TYPE NATURAL
set_parameter_property clock_count_len UNITS None
set_parameter_property clock_count_len HDL_PARAMETER true


# 
# display items
# 


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clock
set_interface_property avalon_slave_0 associatedReset reset
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 1
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 cs_n chipselect_n Input 1
add_interface_port avalon_slave_0 addr address Input 4
add_interface_port avalon_slave_0 write_n write_n Input 1
add_interface_port avalon_slave_0 read_n read_n Input 1
add_interface_port avalon_slave_0 din writedata Input 32
add_interface_port avalon_slave_0 dout readdata Output 32
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clock clk Input 1


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clock
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end leds writedata Output nr_of_leds

