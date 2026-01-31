`ifndef PERSON_JOURNEY_ITEM
`define PERSON_JOURNEY_ITEM

class person_journey_item extends uvm_sequence_item;
    rand int src_floor;
    rand int dest_floor;
    byte person_id;

    // Result fields (filled by driver)
    int boarded_lift_id = -1;
    realtime request_time;
    realtime boarding_time;
    realtime deboarding_time;

    `uvm_object_utils_begin(person_journey_item)
        `uvm_field_int(src_floor, UVM_ALL_ON)
        `uvm_field_int(dest_floor, UVM_ALL_ON)
        `uvm_field_int(person_id, UVM_ALL_ON)
    `uvm_object_utils_end

    constraint valid_journey {
        src_floor != dest_floor;
        src_floor inside {[1:`NUM_FLOORS]};
        dest_floor inside {[1:`NUM_FLOORS]};
    }

    function new(string name = "person_journey_item");
        super.new(name);
    endfunction
endclass

`endif
