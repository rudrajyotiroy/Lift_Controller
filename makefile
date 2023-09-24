build : compile sim
compile:
	vcs tb/tb_top.sv -sverilog +incdir+$UVM_HOME/src -full64 -ntb_opts uvm -timescale=1ns/1ps -debug_all -assert dve
sim:
	$ ./simv +UVM_TR_RECORD +UVM_VERBOSITY=HIGH +UVM_TESTNAME=simple_test +UVM_CONFIG_DB_TRACE |& tee output_log.txt
view:
	Dve -full64 -vpd vcdplus.vpd