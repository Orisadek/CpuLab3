onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/clk
add wave -noupdate /tb/rst
add wave -noupdate /tb/ena
add wave -noupdate /tb/memWriteTb
add wave -noupdate /tb/progWriteTb
add wave -noupdate /tb/tbActive
add wave -noupdate /tb/done
add wave -noupdate -radix hexadecimal /tb/tbMemAddr
add wave -noupdate -radix hexadecimal /tb/tbMemData
add wave -noupdate -radix hexadecimal /tb/tbProgData
add wave -noupdate /tb/tbMemDataOut
add wave -noupdate -radix hexadecimal /tb/tbProgAddr
add wave -noupdate /tb/Top_portMap/IRin
add wave -noupdate /tb/Top_portMap/RFin
add wave -noupdate /tb/Top_portMap/RFout
add wave -noupdate /tb/Top_portMap/Imm1_in
add wave -noupdate /tb/Top_portMap/Imm2_in
add wave -noupdate /tb/Top_portMap/Ain
add wave -noupdate /tb/Top_portMap/PCin
add wave -noupdate /tb/Top_portMap/Cout
add wave -noupdate /tb/Top_portMap/Cin
add wave -noupdate /tb/Top_portMap/MemOut
add wave -noupdate /tb/Top_portMap/MemIn
add wave -noupdate /tb/Top_portMap/Mem_wr
add wave -noupdate /tb/Top_portMap/RFaddr
add wave -noupdate /tb/Top_portMap/PCsel
add wave -noupdate /tb/Top_portMap/opc
add wave -noupdate /tb/Top_portMap/st
add wave -noupdate /tb/Top_portMap/ld
add wave -noupdate /tb/Top_portMap/mov
add wave -noupdate /tb/Top_portMap/done_signal
add wave -noupdate /tb/Top_portMap/add
add wave -noupdate /tb/Top_portMap/sub
add wave -noupdate /tb/Top_portMap/jmp
add wave -noupdate /tb/Top_portMap/jc
add wave -noupdate /tb/Top_portMap/jnc
add wave -noupdate /tb/Top_portMap/nop
add wave -noupdate /tb/Top_portMap/Cflag
add wave -noupdate /tb/Top_portMap/Zflag
add wave -noupdate /tb/Top_portMap/Nflag
add wave -noupdate /tb/Top_portMap/Control_portMap/pr_state
add wave -noupdate /tb/Top_portMap/Control_portMap/nx_state
add wave -noupdate /tb/Top_portMap/Datapath_portMap/central_bus
add wave -noupdate /tb/Top_portMap/Datapath_portMap/Alu_in
add wave -noupdate /tb/Top_portMap/Datapath_portMap/Alu_out
add wave -noupdate /tb/Top_portMap/Datapath_portMap/RF_bus_in
add wave -noupdate /tb/Top_portMap/Datapath_portMap/RF_bus_out
add wave -noupdate /tb/Top_portMap/Datapath_portMap/RFaddr_bus
add wave -noupdate /tb/Top_portMap/Datapath_portMap/mem_signal_bus
add wave -noupdate /tb/Top_portMap/Datapath_portMap/mem_reg_out
add wave -noupdate /tb/Top_portMap/Datapath_portMap/PC_signal
add wave -noupdate /tb/Top_portMap/Datapath_portMap/Alu_port_map/cout_value
add wave -noupdate /tb/Top_portMap/Datapath_portMap/Pc_port_map/AddToPc
add wave -noupdate /tb/Top_portMap/Datapath_portMap/Pc_port_map/ReadAddr
add wave -noupdate /tb/Top_portMap/Datapath_portMap/Pc_port_map/toPc
add wave -noupdate /tb/Top_portMap/Datapath_portMap/Pc_port_map/PcOffset
add wave -noupdate /tb/Top_portMap/Datapath_portMap/Pc_port_map/incPc
add wave -noupdate /tb/Top_portMap/Datapath_portMap/Pc_port_map/reg_one
add wave -noupdate /tb/Top_portMap/Datapath_portMap/Pc_port_map/reg_IR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 436
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {369660 ps}
