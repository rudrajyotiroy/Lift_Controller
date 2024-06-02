`ifndef LIFT_CONTROLLER_SCOREBOARD 
`define LIFT_CONTROLLER_SCOREBOARD

// Out-of-order scoreboard
class lift_controller_scoreboard extends uvm_scoreboard;
 
    `uvm_component_utils(lift_controller_scoreboard)

    uvm_analysis_export #(lift_controller_seq_item) input_txn_export, output_txn_export;
    uvm_tlm_analysis_fifo #(lift_controller_seq_item) in_fifo, out_fifo;

    // Running data structures
    lift_controller_seq_item in_txn, out_txn;

    // Associative array
    lift_controller_seq_item input_txn_array[int];
    lift_controller_seq_item output_txn_array[int];

    // Store idx in separate queues
    int in_q[$], out_q[$];

    function new (string name = "lift_controller_scoreboard" , uvm_component parent = null) ;
        super.new(name, parent);
    endfunction
    
    
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        in_fifo           = new("in_fifo", this);
        out_fifo          = new("out_fifo", this);
        input_txn_export  = new("input_txn_export", this);
        output_txn_export = new("output_txn_export", this);
    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        input_txn_export.connect(in_fifo.analysis_export);
        output_txn_export.connect(out_fifo.analysis_export);
    endfunction

    // Run phase
    task run_phase( uvm_phase phase);
        super.run_phase(phase);
        forever begin
            fork
                begin
                    in_fifo.get(in_txn);
                    // input_txn_array[in_txn.id] = in_txn;
                    // in_q.push_back(in_txn.id);
                    `uvm_info(get_full_name(), $sformatf("input transaction received (button press) in scoreboard"), UVM_LOW);
                    in_txn.print();
                end
                begin
                    out_fifo.get(out_txn);
                    // output_txn_array[out_txn.id] = out_txn;
                    // out_q.push_back(out_txn.id);
                    `uvm_info(get_full_name(), $sformatf("output transaction received (lift door event) in scoreboard"), UVM_LOW);
                    out_txn.print();
                end
            join_any
        end
    endtask

    // Method name : check
    // Description : Check the size of input and output arrays then compare
    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        `uvm_info(get_full_name(), "Starting check-phase, before start stats", UVM_LOW);
        `uvm_info(get_full_name(), $sformatf("input transaction queue size = %0d", in_q.size()), UVM_LOW);
        `uvm_info(get_full_name(), $sformatf("output transaction queue size = %0d", out_q.size()), UVM_LOW);
    endfunction

    // Method name : report 
    // Description : Report the testcase status PASS/FAIL

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        if(in_q.size() == 0) begin
            $write("%c[7;32m",27);
            $display("-------------------------------------------------");
            $display("------ INFO : TEST CASE PASSED ------------------");
            $display("-----------------------------------------");
            $write("%c[0m",27);
        end else begin
            $write("%c[7;31m",27);
            $display("---------------------------------------------------");
            $display("------ ERROR : TEST CASE FAILED ------------------");
            $display("---------------------------------------------------");
            $write("%c[0m",27);
        end
    endfunction 
endclass : lift_controller_scoreboard

`endif
