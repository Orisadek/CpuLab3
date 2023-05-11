onerror {resume}
add list -width 9 /tb/clk
add list /tb/rst
add list /tb/ena
add list /tb/memWriteTb
add list /tb/progWriteTb
add list /tb/tbActive
add list /tb/done
add list /tb/tbMemAddr
add list /tb/tbMemData
add list /tb/tbProgData
add list /tb/tbMemDataOut
add list /tb/tbProgAddr
add list /tb/Top_portMap/IRin
add list /tb/Top_portMap/RFin
add list /tb/Top_portMap/RFout
add list /tb/Top_portMap/Imm1_in
add list /tb/Top_portMap/Imm2_in
add list /tb/Top_portMap/Ain
add list /tb/Top_portMap/PCin
add list /tb/Top_portMap/Cout
add list /tb/Top_portMap/Cin
add list /tb/Top_portMap/MemOut
add list /tb/Top_portMap/MemIn
add list /tb/Top_portMap/Mem_wr
add list /tb/Top_portMap/RFaddr
add list /tb/Top_portMap/PCsel
add list /tb/Top_portMap/opc
add list /tb/Top_portMap/st
add list /tb/Top_portMap/ld
add list /tb/Top_portMap/mov
add list /tb/Top_portMap/done_signal
add list /tb/Top_portMap/add
add list /tb/Top_portMap/sub
add list /tb/Top_portMap/jmp
add list /tb/Top_portMap/jc
add list /tb/Top_portMap/jnc
add list /tb/Top_portMap/nop
add list /tb/Top_portMap/Cflag
add list /tb/Top_portMap/Zflag
add list /tb/Top_portMap/Nflag
add list /tb/Top_portMap/Control_portMap/pr_state
add list /tb/Top_portMap/Control_portMap/nx_state
add list /tb/Top_portMap/Datapath_portMap/central_bus
add list /tb/Top_portMap/Datapath_portMap/Alu_in
add list /tb/Top_portMap/Datapath_portMap/Alu_out
add list /tb/Top_portMap/Datapath_portMap/RF_bus_in
add list /tb/Top_portMap/Datapath_portMap/RF_bus_out
add list /tb/Top_portMap/Datapath_portMap/RFaddr_bus
add list /tb/Top_portMap/Datapath_portMap/mem_signal_bus
add list /tb/Top_portMap/Datapath_portMap/mem_reg_out
add list /tb/Top_portMap/Datapath_portMap/PC_signal
add list /tb/Top_portMap/Datapath_portMap/Alu_port_map/cout_value
add list /tb/Top_portMap/Datapath_portMap/Pc_port_map/AddToPc
add list /tb/Top_portMap/Datapath_portMap/Pc_port_map/ReadAddr
add list /tb/Top_portMap/Datapath_portMap/Pc_port_map/toPc
add list /tb/Top_portMap/Datapath_portMap/Pc_port_map/PcOffset
add list /tb/Top_portMap/Datapath_portMap/Pc_port_map/incPc
add list /tb/Top_portMap/Datapath_portMap/Pc_port_map/reg_one
add list /tb/Top_portMap/Datapath_portMap/Pc_port_map/reg_IR
configure list -usestrobe 1
configure list -strobestart {0 ps} -strobeperiod {5 ns}
configure list -usesignaltrigger 0
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
