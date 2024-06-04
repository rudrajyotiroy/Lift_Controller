`ifndef LIFT_CONTROLLER_CFG
`define LIFT_CONTROLLER_CFG

typedef enum { DN, UP, STOP, NULL } lift_request;
typedef enum { MODERATE, HEAVY, LIGHT, SCARCE, CONVERGING, DIVERGING, PAIRED, TWO_WAY_CONV, TWO_WAY_DIV, PAIRED_W_HOTSPOT } op_cond;

class lift_controller_cfg #(parameter N_FLOORS = 12) extends uvm_sequence_item;

    parameter int MODERATE_DELAY_DIST[4] = '{200, 300, 700, 800};
    parameter int HEAVY_DELAY_DIST[5] = '{100, 150, 400, 450, 500};
    parameter int LIGHT_DELAY_DIST[3] = '{500, 900, 1000};
    parameter int SCARCE_DELAY_DIST[3] = '{1000, 2000, 800};
    parameter BIAS_CONVERGING = 70;
    parameter BIAS_DIVERGING = 70;
    parameter BIAS_PAIRED = 35;
    parameter BIAS_TWO_WAY_CONV = 35;
    parameter BIAS_TWO_WAY_DIV = 30;
    parameter BIAS_PAIRED_W_HOTSPOT = 25;

    rand lift_request req_type;
    rand op_cond traffic;
    rand int floor;
    rand int delay;

    // For modelling specialized testcases
    rand int pref_floor_1;
    rand int pref_floor_2;
    rand int pref_floor_3;

    `uvm_object_utils_begin(lift_controller_cfg)
        `uvm_field_enum(lift_request, req_type, UVM_ALL_ON)
        `uvm_field_enum(op_cond, traffic, UVM_ALL_ON)
        `uvm_field_int(floor, UVM_ALL_ON)
        `uvm_field_int(delay, UVM_ALL_ON)
        `uvm_field_int(pref_floor_1, UVM_ALL_ON)
        `uvm_field_int(pref_floor_2, UVM_ALL_ON)
        `uvm_field_int(pref_floor_3, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "lift_controller_cfg");
        super.new(name);
    endfunction

    // Primitives
    constraint delay_c { delay inside {[0:5000]}; }            
    constraint floor_c { floor inside {[1:N_FLOORS]}; }           
    constraint req_type_c { req_type inside {UP, DN, STOP}; }  

    // Delay distribution based on traffic conditions
    constraint delay_distribution {
        if (traffic == HEAVY) {
            delay dist {HEAVY_DELAY_DIST[0] := 30, [HEAVY_DELAY_DIST[1]:HEAVY_DELAY_DIST[2]] := 50, [HEAVY_DELAY_DIST[3]:HEAVY_DELAY_DIST[4]] := 20};
        } else if (traffic == LIGHT) {
            delay dist {[LIGHT_DELAY_DIST[0]:LIGHT_DELAY_DIST[1]] := 70, LIGHT_DELAY_DIST[2] := 30};
        } else if (traffic == SCARCE) {
            delay dist {[SCARCE_DELAY_DIST[0]:SCARCE_DELAY_DIST[1]] := 80, SCARCE_DELAY_DIST[1] := 20};
        } else {
            delay dist {MODERATE_DELAY_DIST[0] := 20, [MODERATE_DELAY_DIST[1]:MODERATE_DELAY_DIST[2]] := 60, MODERATE_DELAY_DIST[3] := 20};
        }
    }

    // Additional constraints based on traffic patterns
    constraint random_floors_c {
        // Select three random, disjoint floors
        solve pref_floor_1 before pref_floor_2;
        solve pref_floor_2 before pref_floor_3;
        solve pref_floor_3 before floor;
        solve traffic before floor;
        solve floor before req_type;
        pref_floor_1 inside {[1:N_FLOORS]};
        pref_floor_2 inside {[1:N_FLOORS]} && pref_floor_2 != pref_floor_1;
        pref_floor_3 inside {[1:N_FLOORS]} && pref_floor_3 != pref_floor_1 && pref_floor_3 != pref_floor_2;
    }

    constraint floor_config_c {
        if (traffic == CONVERGING) {
            soft floor dist {pref_floor_1 := BIAS_CONVERGING, [1:N_FLOORS] := 100 - BIAS_CONVERGING};
        }
        else if (traffic == DIVERGING) {
            soft floor dist {pref_floor_1 := 100 - BIAS_DIVERGING, [1:N_FLOORS] := BIAS_DIVERGING};
        }
        else if (traffic == PAIRED) {
            soft floor dist {pref_floor_1 := BIAS_PAIRED, pref_floor_2 := BIAS_PAIRED, [1:N_FLOORS] := 100 - 2*BIAS_PAIRED};
        }
        else if (traffic == TWO_WAY_CONV) {
            soft floor dist {pref_floor_1 := BIAS_TWO_WAY_CONV, pref_floor_2 := BIAS_TWO_WAY_CONV, [1:N_FLOORS] := 100 - 2*BIAS_TWO_WAY_CONV};
        }
        else if (traffic == TWO_WAY_DIV) {
            soft floor dist {pref_floor_1 := BIAS_TWO_WAY_DIV, pref_floor_2 := BIAS_TWO_WAY_DIV, [1:N_FLOORS] := 100 - 2*BIAS_TWO_WAY_DIV};
        }
        else if (traffic == PAIRED_W_HOTSPOT) {
            soft floor dist {pref_floor_1 := BIAS_PAIRED_W_HOTSPOT, pref_floor_2 := BIAS_PAIRED_W_HOTSPOT, pref_floor_3 := BIAS_PAIRED_W_HOTSPOT, [1:N_FLOORS] := 100 - 3*BIAS_PAIRED_W_HOTSPOT};
        }
    }

    constraint dir_config_c {
        if (traffic == CONVERGING) {
            if (floor < pref_floor_1) {
                soft req_type dist {UP := BIAS_CONVERGING, DN := 100 - BIAS_CONVERGING, STOP := 100 - BIAS_CONVERGING};
            } else if (floor > pref_floor_1) {
                soft req_type dist {DN := BIAS_CONVERGING, UP := 100 - BIAS_CONVERGING, STOP := 100 - BIAS_CONVERGING};
            }
        }
        else if (traffic == DIVERGING) {
            if (floor == pref_floor_1) {
                soft req_type dist {STOP := BIAS_DIVERGING, UP := 100 - BIAS_DIVERGING, DN := 100 - BIAS_DIVERGING};
            }
        }
        else if (traffic == PAIRED) {
             if (floor == pref_floor_1) {
                if (pref_floor_1 < pref_floor_2) {
                    soft req_type dist {UP := BIAS_PAIRED, DN:= 100 - BIAS_PAIRED, STOP := 100 - BIAS_PAIRED};
                } else {
                    soft req_type dist {DN := BIAS_PAIRED, UP := 100 - BIAS_PAIRED, STOP := 100 - BIAS_PAIRED};
                }
            } else if (floor == pref_floor_2) {
                if (pref_floor_1 < pref_floor_2) {
                    soft req_type dist {DN := BIAS_PAIRED, UP := 100 - BIAS_PAIRED, STOP := 100 - BIAS_PAIRED};
                } else {
                    soft req_type dist {UP := BIAS_PAIRED, DN := 100 - BIAS_PAIRED, STOP := 100 - BIAS_PAIRED};
                }
            }
        }
        else if (traffic == TWO_WAY_CONV) {
            if ((floor < pref_floor_1 && floor < pref_floor_2) || (floor > pref_floor_1 && floor > pref_floor_2)) {
                soft req_type dist {UP := BIAS_TWO_WAY_CONV, DN := 100 - BIAS_TWO_WAY_CONV, STOP := 100 - BIAS_TWO_WAY_CONV};
            } else {
                soft req_type dist {DN := BIAS_TWO_WAY_CONV, UP := 100 - BIAS_TWO_WAY_CONV, STOP := 100 - BIAS_TWO_WAY_CONV};
            }
        }
        else if (traffic == TWO_WAY_DIV) {
            if (floor == pref_floor_1 || floor == pref_floor_2) {
                soft req_type dist {STOP := BIAS_TWO_WAY_DIV, UP := 100 - BIAS_TWO_WAY_DIV, DN := 100 - BIAS_TWO_WAY_DIV};
            } else if ((floor < pref_floor_1 && floor < pref_floor_2) || (floor > pref_floor_1 && floor > pref_floor_2)) {
                soft req_type dist {UP := BIAS_TWO_WAY_DIV, DN := 100 - BIAS_TWO_WAY_DIV, STOP := 100 - BIAS_TWO_WAY_DIV};
            } else {
                soft req_type dist {DN := BIAS_TWO_WAY_DIV, UP := 100 - BIAS_TWO_WAY_DIV, STOP := 100 - BIAS_TWO_WAY_DIV};
            }
        }
        else if (traffic == PAIRED_W_HOTSPOT) {
            if (floor == pref_floor_1) {
                if (pref_floor_1 < pref_floor_2) {
                    soft req_type dist {UP := BIAS_PAIRED_W_HOTSPOT, DN := 100 - BIAS_PAIRED_W_HOTSPOT, STOP := 100 - BIAS_PAIRED_W_HOTSPOT};
                } else {
                    soft req_type dist {DN := BIAS_PAIRED_W_HOTSPOT, UP := 100 - BIAS_PAIRED_W_HOTSPOT, STOP := 100 - BIAS_PAIRED_W_HOTSPOT};
                }
            } else if (floor == pref_floor_2) {
                if (pref_floor_1 < pref_floor_2) {
                    soft req_type dist {DN := BIAS_PAIRED_W_HOTSPOT, UP := 100 - BIAS_PAIRED_W_HOTSPOT, STOP := 100 - BIAS_PAIRED_W_HOTSPOT};
                } else {
                    soft req_type dist {UP := BIAS_PAIRED_W_HOTSPOT, DN := 100 - BIAS_PAIRED_W_HOTSPOT, STOP := 100 - BIAS_PAIRED_W_HOTSPOT};
                }
            } else if (floor == pref_floor_3) {
                soft req_type dist {STOP := BIAS_PAIRED_W_HOTSPOT, UP := 100 - BIAS_PAIRED_W_HOTSPOT, DN := 100 - BIAS_PAIRED_W_HOTSPOT};
            } else if (floor < pref_floor_3) {
                soft req_type dist {UP := BIAS_PAIRED_W_HOTSPOT, DN := 100 - BIAS_PAIRED_W_HOTSPOT, STOP := 100 - BIAS_PAIRED_W_HOTSPOT};
            } else if (floor > pref_floor_3) {
                soft req_type dist {DN := BIAS_PAIRED_W_HOTSPOT, UP := 100 - BIAS_PAIRED_W_HOTSPOT, STOP := 100 - BIAS_PAIRED_W_HOTSPOT};
            }
        }
    }

    function void post_randomize();
    endfunction  

endclass

`endif
