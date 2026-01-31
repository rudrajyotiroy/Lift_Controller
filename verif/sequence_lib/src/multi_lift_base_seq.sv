`ifndef MULTI_LIFT_BASE_SEQ
`define MULTI_LIFT_BASE_SEQ

class multi_lift_base_seq #(parameter N_LIFTS = 10) extends uvm_sequence#(multi_lift_controller_cfg #(`NUM_FLOORS, N_LIFTS));

    // Virtual interfaces
    virtual multi_lift_controller_if #(`NUM_FLOORS, N_LIFTS) multi_vif;
    virtual lift_controller_if #(`NUM_FLOORS) lift_vifs[N_LIFTS];

    typedef struct {
        int origin_floor;
        int destination_floor;
        int request_time;
        int boarding_time;
        int deboarding_time;
        int lift_id;
    } feedback_data;

    feedback_data info_array [byte unsigned];

    `uvm_object_utils(multi_lift_base_seq)
    uvm_phase phase;

    function new(string name = "multi_lift_base_seq");
        super.new(name);
    endfunction

    task pre_body();
        `uvm_info(get_type_name(), "Inside pre_body, raising objection", UVM_LOW);
        `ifdef COMPILE_VCS
            phase = uvm_sequence_base::starting_phase; // Pre-UVM 1.2
        `else
            phase = get_starting_phase(); // Retrieve phase information (UVM 1.2+)
        `endif
        if (phase != null) phase.raise_objection(this);

        if (!uvm_config_db#(virtual multi_lift_controller_if #(`NUM_FLOORS, N_LIFTS))::get(null, "", "multi_lift_controller_vif", multi_vif)) begin
            `uvm_fatal(get_full_name(),"Multi-lift interface not found")
        end
        for (int i = 0; i < N_LIFTS; i++) begin
            if (!uvm_config_db#(virtual lift_controller_if #(`NUM_FLOORS))::get(null, "", $sformatf("lift_vif_%0d", i), lift_vifs[i])) begin
                `uvm_fatal(get_full_name(), $sformatf("Lift interface %0d not found", i))
            end
        end
    endtask

    virtual task body();
        wait(!multi_vif.reset);
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
                // Wait for all requests to be cleared in all lifts
                for (int i = 0; i < N_LIFTS; i++) begin
                    wait(lift_vifs[i].up_rqst_status == 0);
                    wait(lift_vifs[i].dn_rqst_status == 0);
                    wait(lift_vifs[i].flr_rqst_status == 0);
                end
                `uvm_info(get_full_name(),$sformatf("All requests cleared in all lifts, exiting test gracefully"),UVM_LOW);
            end
            begin
                #(`DRAIN_TIME);
                `uvm_fatal(get_full_name(),$sformatf("Test is not proceeding, please verify"))
            end
        join_any

        $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
        foreach(info_array[key]) begin
            $display("Person: %0d ==> Origin: %0d, Destination: %0d, Lift: %0d, Request_Time: %0dns, Boarding_Time: %0dns, Deboarding_Time: %0dns, Total_Time:%0dns",
        key, info_array[key].origin_floor, info_array[key].destination_floor, info_array[key].lift_id, info_array[key].request_time, info_array[key].boarding_time, info_array[key].deboarding_time, info_array[key].deboarding_time - info_array[key].request_time);
            if (info_array[key].deboarding_time > 0) begin
                min = ((info_array[key].deboarding_time - info_array[key].request_time) < min) ? (info_array[key].deboarding_time - info_array[key].request_time) : min;
                max = ((info_array[key].deboarding_time - info_array[key].request_time) > max) ? (info_array[key].deboarding_time - info_array[key].request_time) : max;
                avg = avg + (info_array[key].deboarding_time - info_array[key].request_time);
                num = num + 1;
            end
        end
        if (num > 0)
            $display("Summary ==> Total Persons: %0d, average TAT: %0dns, minimum TAT: %0dns, maximum TAT: %0dns", num, avg/num, min, max);
        $display("------------------------------------------------------------------------------------------------------------------------------------------------------------");
        `uvm_info(get_full_name(),$sformatf("Exiting main test, dropping objection"),UVM_LOW);
        if (phase != null) phase.drop_objection(this);
    endtask

    task wait_for_any_elevator(int floor, lift_request req_type, byte unsigned person_id, output int lift_id);
        `uvm_info(get_full_name(), $sformatf("Person %0d waiting for ANY elevator at floor %d", person_id, floor), UVM_LOW)
        info_array[person_id].request_time = int'($time);
        info_array[person_id].origin_floor = floor;

        while (1) begin
            for (int i = 0; i < N_LIFTS; i++) begin
                if (lift_vifs[i].door_open && lift_vifs[i].floor_sense == (1'b1 << (floor-1))) begin
                    if ((req_type == UP && lift_vifs[i].direction == 1'b1) ||
                        (req_type == DN && lift_vifs[i].direction == 1'b0)) begin
                        lift_id = i;
                        info_array[person_id].boarding_time = int'($time);
                        info_array[person_id].lift_id = lift_id;
                        `uvm_info(get_full_name(), $sformatf("Person %0d boarded lift %0d", person_id, lift_id), UVM_LOW)
                        return;
                    end
                end
            end
            @(posedge multi_vif.clk);
        end
    endtask

    task wait_for_specific_elevator(int lift_id, int floor, byte unsigned person_id);
        `uvm_info(get_full_name(), $sformatf("Person %0d in lift %0d waiting for floor %d", person_id, lift_id, floor), UVM_LOW)
        wait(lift_vifs[lift_id].floor_sense == (1'b1 << (floor-1)) && lift_vifs[lift_id].door_open == 1'b1);
        info_array[person_id].deboarding_time = int'($time);
        info_array[person_id].destination_floor = floor;
        `uvm_info(get_full_name(), $sformatf("Person %0d deboarded lift %0d", person_id, lift_id), UVM_LOW)
    endtask

endclass

`endif
