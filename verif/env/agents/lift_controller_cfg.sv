`ifndef LIFT_CONTROLLER_CFG
`define LIFT_CONTROLLER_CFG


typedef enum { DN, UP, STOP, NULL } lift_request;
typedef enum { MODERATE, HEAVY, LIGHT, SCARCE, CONVERGING, DIVERGING, PAIRED, TWO_WAY_CONV, TWO_WAY_DIV, PAIRED_W_HOTSPOT, CUSTOM} op_cond;


class lift_controller_cfg #(parameter N_FLOORS = 12) extends uvm_sequence_item;
    rand lift_request req_type;
    rand op_cond traffic;
    rand int floor;
    rand int delay;

    // For modelling specialized testcases
    rand int pref_floor_1;
    rand int pref_floor_2;
    rand int pref_floor_3;

    `uvm_object_utils_begin(lift_controller_cfg)
        `uvm_field_enum(lift_request, req_type,UVM_ALL_ON)
        `uvm_field_enum(op_cond, traffic,UVM_ALL_ON)
        `uvm_field_int(floor,UVM_ALL_ON)
        `uvm_field_int(delay,UVM_ALL_ON)
        `uvm_field_int(pref_floor_1,UVM_ALL_ON)
        `uvm_field_int(pref_floor_2,UVM_ALL_ON)
        `uvm_field_int(pref_floor_3,UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "lift_controller_cfg");
        super.new(name);
    endfunction

    // Primitives
    constraint delay_c {delay inside {[100:1000]}; }			  
    constraint floor_c {floor inside {[0:(`NUM_FLOORS - 1)]}; }			  
    constraint req_type_c {req_type inside {UP,DN,STOP}; }	

    function void post_randomize();
    endfunction  

endclass

`endif