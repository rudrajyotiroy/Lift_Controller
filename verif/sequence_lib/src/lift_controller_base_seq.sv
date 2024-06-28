`ifndef LIFT_CONTROLLER_BASE_SEQ 
`define LIFT_CONTROLLER_BASE_SEQ

class lift_controller_base_seq extends uvm_sequence#(lift_controller_cfg);

    // Virtual interface
    virtual lift_controller_if lift_controller_vif;
   
    `uvm_object_utils(lift_controller_base_seq)
    uvm_phase phase;

    function new(string name = "lift_controller_base_seq");
        super.new(name);
    endfunction

    task pre_body();
        `uvm_info(get_type_name(), "Inside pre_body, raising objection", UVM_LOW);
        phase = get_starting_phase; // Retrieve phase information
        if (phase != null) phase.raise_objection(this);

        if (!uvm_config_db#(virtual lift_controller_if)::get(null, "", "lift_controller_vif", lift_controller_vif)) begin
            `uvm_fatal(get_full_name(),"Virtual interface not found in UVM Monitor")
        end else begin
            `uvm_info(get_full_name(),$sformatf("Virtual interface obtained and connected to UVM Monitor"),UVM_LOW);
        end
    endtask

    virtual task body();
        wait(!lift_controller_vif.reset);
        `uvm_info(get_full_name(),$sformatf("Entering main test"),UVM_LOW);

    endtask

    task post_body();
        #(`DRAIN_TIME);
        `uvm_info(get_full_name(),$sformatf("Exiting main test, dropping objection"),UVM_LOW);
        if (phase != null) phase.drop_objection(this);
    endtask

    task wait_for_elevator(int desired_floor, lift_request req_type, int person_id);

        if(req_type == DN) begin
            `uvm_info(get_full_name(),$sformatf("Person %d, Waiting for elevator at floor %d, going DN", person_id, desired_floor),UVM_LOW);
            wait((lift_controller_vif.direction == 1'b0) && (lift_controller_vif.floor_sense == (1'b1 << (desired_floor-1))));
        end else if (req_type == UP) begin
            `uvm_info(get_full_name(),$sformatf("Person %d, Waiting for elevator at floor %d, going UP", person_id, desired_floor),UVM_LOW);
            wait((lift_controller_vif.direction == 1'b1) && (lift_controller_vif.floor_sense == (1'b1 << (desired_floor-1))));
        end else if (req_type == STOP) begin
            `uvm_info(get_full_name(),$sformatf("Person %d, Boarded elevator, waiting to reach floor %d", person_id, desired_floor),UVM_LOW);
            wait(lift_controller_vif.floor_sense == (1'b1 << (desired_floor-1)));
        end
        `uvm_info(get_full_name(),$sformatf("Person %d, Waiting for door to open", person_id),UVM_LOW);
        wait(lift_controller_vif.door_open == 1'b1);
        if((req_type == DN) || (req_type == UP)) begin
            `uvm_info(get_full_name(),$sformatf("Person %d, Boarding complete, time to choose a floor", person_id),UVM_LOW);
        end else if (req_type == STOP) begin
            `uvm_info(get_full_name(),$sformatf("Person %d, Deboarding complete", person_id),UVM_LOW);
        end

    endtask
   
endclass

`endif


