onerror {resume}
add list -width 9 /tb/clk
add list /tb/rst
add list /tb/ena
add list /tb/done
add list /tb/IRin
add list /tb/RFin
add list /tb/RFout
add list /tb/Imm1_in
add list /tb/Imm2_in
add list /tb/Ain
add list /tb/PCin
add list /tb/Cout
add list /tb/Cin
add list /tb/MemOut
add list /tb/MemIn
add list /tb/Mem_wr
add list /tb/RFaddr
add list /tb/PCsel
add list /tb/opc
add list /tb/st
add list /tb/ld
add list /tb/mov
add list /tb/done_signal
add list /tb/add
add list /tb/sub
add list /tb/jmp
add list /tb/jc
add list /tb/jnc
add list /tb/nop
add list /tb/Cflag
add list /tb/Zflag
add list /tb/Nflag
configure list -usestrobe 1
configure list -strobestart {0 ps} -strobeperiod {5 ns}
configure list -usesignaltrigger 0
configure list -delta all
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
