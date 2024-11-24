build : compile sim
compile:
	vcs ../verif/tb/src/tb_top.sv +vcs+dumpvars+vcdplus.vpd +define+COMPILE_VCS -sverilog -f include.f -full64 -ntb_opts uvm -timescale=1ns/1ps -debug_all -assert dve -wdump 
sim:
	$ ./simv +UVM_TR_RECORD +UVM_VERBOSITY=HIGH +UVM_TESTNAME=lift_controller_base_test +UVM_CONFIG_DB_TRACE |& tee output_log.txt
view:
	Dve -full64 -vpd vcdplus.vpd
dve:	sim
	./simv -gui &
