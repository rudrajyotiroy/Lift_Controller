`ifndef LIFT_CONTROLLER_BASE_SEQ 
`define LIFT_CONTROLLER_BASE_SEQ

class lift_controller_base_seq extends uvm_sequence#(lift_controller_cfg);

    // Virtual interface
    virtual lift_controller_if lift_controller_vif;

    typedef struct {
        int origin_floor;
        int destination_floor;
        int request_time;
        int boarding_time;
        int deboarding_time;
    } feedback_data;

    feedback_data info_array [byte unsigned];
   
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
        int min, max, avg, num;
        min = 9999999;
        max = 0;
        avg = 0;
        num = 0;
        fork
            begin
                wait(lift_controller_vif.up_rqst_status == 0);
                `uvm_info(get_full_name(),$sformatf("All UP requests cleared"),UVM_LOW);
                wait(lift_controller_vif.dn_rqst_status == 0);
                `uvm_info(get_full_name(),$sformatf("All DN requests cleared"),UVM_LOW);
                wait(lift_controller_vif.flr_rqst_status == 0);
                `uvm_info(get_full_name(),$sformatf("All FLR requests cleared, exiting test gracefully"),UVM_LOW);
            end
            begin
                #(`DRAIN_TIME);
                `uvm_fatal(get_full_name(),$sformatf("Test is not proceeding, please verify")) 
            end
        join_any
        `uvm_info(get_full_name(),$sformatf("Reporting from sequence..."),UVM_LOW);
        
        foreach(info_array[key]) begin
            $display("Person: %0d ==> Origin: %0d, Destination: %0d, Request_Time: %0dns, Boarding_Time: %0dns, Deboarding_Time: %0dns, Total_Time:%0dns",
        key, info_array[key].origin_floor, info_array[key].destination_floor, info_array[key].request_time, info_array[key].boarding_time, info_array[key].deboarding_time, info_array[key].deboarding_time - info_array[key].request_time); 
            min = ((info_array[key].deboarding_time - info_array[key].request_time) < min) ? (info_array[key].deboarding_time - info_array[key].request_time) : min;
            max = ((info_array[key].deboarding_time - info_array[key].request_time) > min) ? (info_array[key].deboarding_time - info_array[key].request_time) : max;
            avg = avg + (info_array[key].deboarding_time - info_array[key].request_time);
            num = num + 1;            
        end
        $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
        $display("Summary ==> Total Persons: %0d, average TAT: %0dns, minimum TAT: %0dns, maximum TAT: %0dns, that's all for today...", num, avg/num, min, max);
        `uvm_info(get_full_name(),$sformatf("Exiting main test, dropping objection"),UVM_LOW);
        if (phase != null) phase.drop_objection(this);
    endtask

    task wait_for_elevator(int desired_floor, lift_request req_type, byte unsigned person_id);

        if(req_type == DN) begin
            `uvm_info(get_full_name(),$sformatf("Person %0d, Waiting for elevator at floor %d, going DN", person_id, desired_floor),UVM_LOW);
            info_array[person_id].request_time = int'($time);
            info_array[person_id].origin_floor = desired_floor;
            wait((lift_controller_vif.direction == 1'b0) && (lift_controller_vif.floor_sense == (1'b1 << (desired_floor-1))));
        end else if (req_type == UP) begin
            `uvm_info(get_full_name(),$sformatf("Person %0d, Waiting for elevator at floor %d, going UP", person_id, desired_floor),UVM_LOW);
            info_array[person_id].request_time = int'($time);
            info_array[person_id].origin_floor = desired_floor;
            wait((lift_controller_vif.direction == 1'b1) && (lift_controller_vif.floor_sense == (1'b1 << (desired_floor-1))));
        end else if (req_type == STOP) begin
            `uvm_info(get_full_name(),$sformatf("Person %0d, Boarded elevator, waiting to reach floor %d", person_id, desired_floor),UVM_LOW);
            info_array[person_id].boarding_time = int'($time);
            info_array[person_id].destination_floor = desired_floor;
            wait(lift_controller_vif.floor_sense == (1'b1 << (desired_floor-1)));
        end
        `uvm_info(get_full_name(),$sformatf("Person %0d, Waiting for door to open", person_id),UVM_LOW);
        wait(lift_controller_vif.door_open == 1'b1);
        if((req_type == DN) || (req_type == UP)) begin
            `uvm_info(get_full_name(),$sformatf("Person %0d, Boarding complete, time to choose a floor", person_id),UVM_LOW);
        end else if (req_type == STOP) begin
            `uvm_info(get_full_name(),$sformatf("Person %0d, Deboarding complete", person_id),UVM_LOW);
            info_array[person_id].deboarding_time = int'($time);
        end
            
    endtask
   
endclass

`endif


