`ifndef LIFT_CONTROLLER_SCOREBOARD 
`define LIFT_CONTROLLER_SCOREBOARD

// Out-of-order scoreboard
class lift_controller_scoreboard extends uvm_scoreboard;
 
    `uvm_component_utils(lift_controller_scoreboard)

    uvm_analysis_export #(lift_controller_seq_item) input_txn_export, output_txn_export;
    uvm_tlm_analysis_fifo #(lift_controller_seq_item) in_fifo, out_fifo;

    // Running data structures
    lift_controller_seq_item in_txn_copy, out_txn_copy;

    lift_controller_seq_item in_q[$];

    int total_count;

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
        total_count = 0;
        forever begin
            fork
                begin
                    lift_controller_seq_item in_txn = lift_controller_seq_item::type_id::create("in_txn");
                    in_fifo.get(in_txn_copy);
                    in_txn.copy(in_txn_copy);
                    in_q.push_back(in_txn);
                    `uvm_info(get_full_name(), $sformatf("input transaction received (button press) in scoreboard"), UVM_LOW);
                    in_txn.print();
                end
                begin
                    lift_controller_seq_item out_txn = lift_controller_seq_item::type_id::create("out_txn");
                    out_fifo.get(out_txn_copy);
                    out_txn.copy(out_txn_copy);
                    `uvm_info(get_full_name(), $sformatf("output transaction received (lift door event) in scoreboard"), UVM_LOW);
                    out_txn.print();
                    tick_off_requests(out_txn);
                end
            join_any
        end
    endtask

    function tick_off_requests(lift_controller_seq_item curr_txn);
        int i = 0;
        int match_count = 0;
        `uvm_info(get_full_name(), $sformatf("Ticking off input requests at current floor, request queue size %0d", in_q.size()), UVM_LOW);
        while (i < in_q.size()) begin
            `uvm_info(get_full_name(), $sformatf("Examining queue element %d, floor : %d, door %0s, dir %0s", i, in_q[i].floor, in_q[i].door.name(), in_q[i].dir.name()), UVM_LOW);
            if((in_q[i].floor == curr_txn.floor) && (in_q[i].door == curr_txn.door) && ((curr_txn.door == DOOR_OPEN) || (curr_txn.dir == in_q[i].dir))) begin               
                in_q.delete(i);
                `uvm_info(get_full_name(), $sformatf("Deleted this input request, request queue size %0d", in_q.size()), UVM_LOW);
                match_count++;
                total_count++;
            end else begin
                i++; 
            end
        end
        `uvm_info(get_full_name(), $sformatf("Ticked off input requests at current floor, request queue size %0d", in_q.size()), UVM_LOW);
        if(match_count == 0) begin
            `uvm_warning(get_full_name(), "No requests found at current floor");
        end
    endfunction

    // Method name : check
    // Description : Check the size of input and output arrays then compare
    function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        `uvm_info(get_full_name(), "Starting check-phase, before start stats", UVM_LOW);
        `uvm_info(get_full_name(), $sformatf("Request queue size = %0d, total matched txn count = %0d", in_q.size(), total_count), UVM_LOW);
        if(in_q.size()) begin
            `uvm_info(get_full_name(), "Request queue is NOT cleared, all requests are not addressed", UVM_LOW);
        end
    endfunction

    // Method name : report 
    // Description : Report the testcase status PASS/FAIL

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        if(in_q.size() == 0) begin
            // $write("%c[7;32m",27);
            $display("-------------------------------------------------");
            $display("------ INFO : TEST CASE PASSED ------------------");
            $display("-------------------------------------------------");
            // $write("%c[0m",27);
        end else begin
            // $write("%c[7;31m",27);
            $display("---------------------------------------------------");
            $display("------ ERROR : TEST CASE FAILED ------------------");
            $display("---------------------------------------------------");
            // $write("%c[0m",27);
        end
    endfunction 
endclass : lift_controller_scoreboard

`endif
