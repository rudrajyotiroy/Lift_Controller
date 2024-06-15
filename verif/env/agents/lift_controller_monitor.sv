`ifndef LIFT_CONTROLLER_MONITOR
`define LIFT_CONTROLLER_MONITOR

class lift_controller_monitor extends uvm_monitor;

    // Virtual interface
    virtual lift_controller_if lift_controller_vif;
  
    // Analysis port to send the transaction to the scoreboard or other components
    uvm_analysis_port #(lift_controller_seq_item) output_txn_port;

    lift_controller_seq_item tr_mon;

    `uvm_component_utils(lift_controller_monitor)
  
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        tr_mon = new();
        output_txn_port = new("output_txn_port", this);
    endfunction : new

    // Build phase: Get the virtual interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual lift_controller_if)::get(this, "", "lift_controller_vif", lift_controller_vif)) begin
            `uvm_fatal(get_full_name(),"Virtual interface not found in UVM Monitor")
        end else begin
            `uvm_info(get_full_name(),$sformatf("Virtual interface obtained and connected to UVM Monitor"),UVM_LOW);
        end
    endfunction

    // Run phase: Main task for driving transactions
    virtual task run_phase(uvm_phase phase);
        lift_direction curr_dir;
        door_state curr_door;

        super.run_phase(phase);
        wait(!lift_controller_vif.reset);
        `uvm_info(get_full_name(),$sformatf("UVM_MONITOR : Ready to detect lift state"),UVM_LOW);
        forever begin
            @(lift_controller_vif.door_open);
            @(negedge lift_controller_vif.clk); // Add out of cycle delay
            $cast(curr_dir,lift_controller_vif.direction);
            $cast(curr_door,lift_controller_vif.door_open);
            tr_mon.door = curr_door;
            tr_mon.dir = curr_dir;
            tr_mon.floor = (ENCODER #(`NUM_FLOORS)::ONE_HOT_TO_DECIMAL(lift_controller_vif.floor_sense));
            // tr_mon.time <= $time;
            output_txn_port.write(tr_mon);
            // Print enumerated datatype name (ref: https://verificationguide.com/systemverilog/systemverilog-print-enum-as-string/)
            `uvm_info(get_full_name(),$sformatf("UVM_MONITOR : Lift door state : %0s at floor %d in direction %0s", tr_mon.door.name(), tr_mon.floor, tr_mon.dir.name()),UVM_LOW)
        end
    endtask

endclass : lift_controller_monitor

`endif