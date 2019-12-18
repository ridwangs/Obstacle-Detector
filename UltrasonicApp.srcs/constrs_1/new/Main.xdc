create_clock -period 8 [get_ports clk]
create_generated_clock -name mclk -source [get_pins clk] -multiply_by 23 -divide_by 234 [get_pins mclk]

set_property PACKAGE_PIN K17 [get_ports {sys_clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_clk}]

set_property PACKAGE_PIN K18 [get_ports {reset_btn}]					
set_property IOSTANDARD LVCMOS33 [get_ports {reset_btn}]

#set_property PACKAGE_PIN G15 [get_ports {switch}]					
#set_property IOSTANDARD LVCMOS33 [get_ports {switch}]

set_property PACKAGE_PIN V15 [get_ports {echoPulse}]
set_property IOSTANDARD LVCMOS33 [get_ports {echoPulse}]

set_property PACKAGE_PIN W14 [get_ports {pulseTrigger}]
set_property IOSTANDARD LVCMOS33 [get_ports {pulseTrigger}]

set_property PACKAGE_PIN D18 [get_ports {distRange[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {distRange[3]}]
set_property PACKAGE_PIN G14 [get_ports {distRange[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {distRange[2]}]
set_property PACKAGE_PIN M15 [get_ports {distRange[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {distRange[1]}]
set_property PACKAGE_PIN M14 [get_ports {distRange[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {distRange[0]}]

set_property PACKAGE_PIN D19 [get_ports {TMDS[0]}]					
set_property IOSTANDARD TMDS_33 [get_ports {TMDS[0]}]
set_property PACKAGE_PIN D20 [get_ports {TMDSB[0]}]					
set_property IOSTANDARD TMDS_33 [get_ports {TMDSB[0]}]
set_property PACKAGE_PIN C20 [get_ports {TMDS[1]}]					
set_property IOSTANDARD TMDS_33 [get_ports {TMDS[1]}]
set_property PACKAGE_PIN B20 [get_ports {TMDSB[1]}]					
set_property IOSTANDARD TMDS_33 [get_ports {TMDSB[1]}]
set_property PACKAGE_PIN B19 [get_ports {TMDS[2]}]					
set_property IOSTANDARD TMDS_33 [get_ports {TMDS[2]}]
set_property PACKAGE_PIN A20 [get_ports {TMDSB[2]}]					
set_property IOSTANDARD TMDS_33 [get_ports {TMDSB[2]}]
set_property PACKAGE_PIN H16 [get_ports {TMDS[3]}]					
set_property IOSTANDARD TMDS_33 [get_ports {TMDS[3]}]
set_property PACKAGE_PIN H17 [get_ports {TMDSB[3]}]					
set_property IOSTANDARD TMDS_33 [get_ports {TMDSB[3]}]

set_property PACKAGE_PIN R19 [get_ports {bclk}]
set_property IOSTANDARD LVCMOS33 [get_ports {bclk}]

set_property PACKAGE_PIN R18 [get_ports {pbdat}]
set_property IOSTANDARD LVCMOS33 [get_ports {pbdat}]

set_property PACKAGE_PIN T19 [get_ports {pblrc}]
set_property IOSTANDARD LVCMOS33 [get_ports {pblrc}]

set_property PACKAGE_PIN R17 [get_ports {mclk}]
set_property IOSTANDARD LVCMOS33 [get_ports {mclk}]

set_property PACKAGE_PIN P18 [get_ports {mute}]
set_property IOSTANDARD LVCMOS33 [get_ports {mute}]