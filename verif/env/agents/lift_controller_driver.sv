`ifndef LIFT_CONTROLLER_DRIVER
`define LIFT_CONTROLLER_DRIVER

virtual class ENCODER #(parameter N_FLOORS = 12);
    static function bit [N_FLOORS-1:0] DECIMAL_TO_ONE_HOT(input int decimal_input);
        bit [N_FLOORS-1:0] onehot_output;

        // Initialize the output to all zeros
        onehot_output = {N_FLOORS{1'b0}};

        // Check if the input is within the valid range (1 to N_FLOORS)
        if (decimal_input > 0 && decimal_input <= N_FLOORS) begin
            // Set the corresponding bit to '1'
            onehot_output[decimal_input-1] = 1'b1;
        end else begin
            // Handle invalid inputs by setting the output to all ones
            onehot_output = {N_FLOORS{1'b1}};
        end

        // Return the one-hot encoding
        return onehot_output;
    endfunction

    // Static function for getting current floor ID
    static function int ONE_HOT_TO_DECIMAL(input [N_FLOORS-1:0] onehot_input);
        int dec_output;
        int ctr;

        for (ctr = 0; ctr < N_FLOORS; ctr = ctr + 1) begin
            if(onehot_input[ctr] == 1'b1) begin
                dec_output = ctr + 1;
            end
        end

        return dec_output;
        
    endfunction
endclass

// Define a driver class that extends uvm_driver
class lift_controller_driver extends uvm_driver #(lift_controller_cfg);

    lift_controller_cfg tr;
    lift_controller_seq_item tr_to_sb;

    // Declare the virtual interface
    virtual lift_controller_if lift_controller_vif;

    // Declare the driver to scoreboard input port (Connects to scoreboard export in env)
    uvm_analysis_port #(lift_controller_seq_item) input_txn_port;
    
    // Register the driver with the factory
    `uvm_component_utils(lift_controller_driver)

    // Constructor
    function new(string name = "lift_controller_driver", uvm_component parent = null);
        super.new(name, parent);
        input_txn_port = new("input_txn_port", this);
        tr = new();
        tr_to_sb = new();
    endfunction

    // Build phase: Get the virtual interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual lift_controller_if)::get(this, "", "lift_controller_vif", lift_controller_vif)) begin
            `uvm_fatal(get_full_name(),"Virtual interface not found in UVM Driver")
        end else begin
            `uvm_info(get_full_name(),$sformatf("Virtual interface obtained and connected to UVM Driver"),UVM_LOW);
        end
    endfunction

    // Run phase: Main task for driving transactions
    virtual task run_phase(uvm_phase phase);
        // Main loop to fetch and drive transactions
        lift_controller_vif.force_open = 1'b0;
        drive_transfer(0, NULL); // Reset all request arrays
        wait(!lift_controller_vif.reset);
        forever begin
            // Get the next transaction from the sequencer
            seq_item_port.get_next_item(tr);

            `uvm_info(get_full_name(),$sformatf("Transaction item received from sequencer, driving to DUT"),UVM_LOW);

            // Drive the transaction to the DUT without waiting for next transaction time
            fork
                drive_transfer(tr.floor, tr.req_type);
                sb_transfer(tr.floor, tr.req_type);
            join

            `uvm_info(get_full_name(),$sformatf("Transaction item driven to DUT and ScoreBoard, waiting for next item"),UVM_LOW);

            // Delay should be handled by sequence
            // Indicate that the item has been executed
            seq_item_port.item_done();
        end
    endtask

    virtual task drive_transfer(int floor, lift_request req_type);
        if(req_type == UP) begin
            lift_controller_vif.up_rqst = ENCODER #(`NUM_FLOORS)::DECIMAL_TO_ONE_HOT(floor);
            repeat(5)
                @(posedge lift_controller_vif.clk);
            lift_controller_vif.up_rqst = {`NUM_FLOORS{1'b0}};
        end
        else if(req_type == DN) begin
            lift_controller_vif.dn_rqst = ENCODER #(`NUM_FLOORS)::DECIMAL_TO_ONE_HOT(floor);
            repeat(5)
                @(posedge lift_controller_vif.clk);
            lift_controller_vif.dn_rqst = {`NUM_FLOORS{1'b0}};
        end
        else if(req_type == STOP) begin
            lift_controller_vif.flr_rqst = ENCODER #(`NUM_FLOORS)::DECIMAL_TO_ONE_HOT(floor);
            repeat(5)
                @(posedge lift_controller_vif.clk);
            lift_controller_vif.flr_rqst = {`NUM_FLOORS{1'b0}};
        end
        else if(req_type == NULL) begin
            lift_controller_vif.up_rqst <= {`NUM_FLOORS{1'b0}};
            lift_controller_vif.dn_rqst <= {`NUM_FLOORS{1'b0}};
            lift_controller_vif.flr_rqst <= {`NUM_FLOORS{1'b0}};
        end
        
    endtask // drive_transfer

    // No concept of set_id_info() used here since cfg type and actual comparison types are different
    virtual task sb_transfer(int floor, lift_request req_type);
        if(req_type == UP) begin
            // First txn
            tr_to_sb.door = DOOR_OPEN;
            tr_to_sb.floor = floor;
            // tr_to_sb.time = $time;
            tr_to_sb.dir = DIR_UP;  // Doesn't matter  
            input_txn_port.write(tr_to_sb);
            
            #1;

            // Second txn
            tr_to_sb.door = DOOR_CLOSED;
            tr_to_sb.floor = floor;
            // tr_to_sb.time = $time;
            tr_to_sb.dir = DIR_UP;
            input_txn_port.write(tr_to_sb);           
        end
        else if(req_type == DN) begin
            // First txn
            tr_to_sb.door = DOOR_OPEN;
            tr_to_sb.floor = floor;
            // tr_to_sb.time = $time;
            tr_to_sb.dir = DIR_DN;  // Doesn't matter  
            input_txn_port.write(tr_to_sb);
            
            #1;

            // Second txn
            tr_to_sb.door = DOOR_CLOSED;
            tr_to_sb.floor = floor;
            // tr_to_sb.time = $time;
            tr_to_sb.dir = DIR_DN;
            input_txn_port.write(tr_to_sb);  
        end
        else if(req_type == STOP) begin
            // First txn
            tr_to_sb.door = DOOR_OPEN;
            tr_to_sb.floor = floor;
            // tr_to_sb.time = $time;
            tr_to_sb.dir = DIR_DN;  // Doesn't matter
            input_txn_port.write(tr_to_sb);
        end
        
    endtask // sb_transfer

endclass

`endif