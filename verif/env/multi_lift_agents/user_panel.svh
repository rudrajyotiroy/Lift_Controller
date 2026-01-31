`ifndef USER_PANEL_SVH
`define USER_PANEL_SVH

virtual class user_panel extends uvm_object;
    `uvm_object_abstract_utils(user_panel)

    function new(string name = "user_panel");
        super.new(name);
    endfunction

    pure virtual task press_button(int floor, lift_request req_type);
endclass

// Represents global up/down buttons at a floor
class hall_panel extends user_panel;
    virtual multi_lift_controller_if vif;

    `uvm_object_utils(hall_panel)

    function new(string name = "hall_panel");
        super.new(name);
    endfunction

    virtual task press_button(int floor, lift_request req_type);
        if (req_type == UP) begin
            vif.up_rqst = (1 << (floor-1));
            repeat(5) @(posedge vif.clk);
            vif.up_rqst = 0;
        end else if (req_type == DN) begin
            vif.dn_rqst = (1 << (floor-1));
            repeat(5) @(posedge vif.clk);
            vif.dn_rqst = 0;
        end else begin
            `uvm_error("HALL_PANEL", "Only UP/DN requests supported on hall panel")
        end
    endtask
endclass

// Represents the internal panel inside a specific elevator
class car_panel extends user_panel;
    virtual lift_controller_if vif;
    int lift_id;

    `uvm_object_utils(car_panel)

    function new(string name = "car_panel");
        super.new(name);
    endfunction

    virtual task press_button(int floor, lift_request req_type);
        if (req_type == STOP) begin
            vif.flr_rqst = (1 << (floor-1));
            repeat(5) @(posedge vif.clk);
            vif.flr_rqst = 0;
        end else begin
            `uvm_error("CAR_PANEL", "Only STOP requests supported on car panel")
        end
    endtask
endclass

`endif
