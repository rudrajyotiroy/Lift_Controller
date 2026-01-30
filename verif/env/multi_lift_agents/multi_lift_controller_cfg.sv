`ifndef MULTI_LIFT_CONTROLLER_CFG
`define MULTI_LIFT_CONTROLLER_CFG

class multi_lift_controller_cfg #(parameter N_FLOORS = `NUM_FLOORS, parameter N_LIFTS = 10) extends lift_controller_cfg #(N_FLOORS);
    rand int lift_id;
    constraint lift_id_c { lift_id inside {[0:N_LIFTS-1]}; }

    `uvm_object_utils_begin(multi_lift_controller_cfg)
        `uvm_field_int(lift_id, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "multi_lift_controller_cfg");
        super.new(name);
    endfunction
endclass

`endif
