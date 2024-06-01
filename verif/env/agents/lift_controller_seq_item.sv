`ifndef LIFT_CONTROLLER_SEQ_ITEM
`define LIFT_CONTROLLER_SEQ_ITEM

// Used in monitor only
typedef enum {DIR_UP, DIR_DN} lift_direction;
typedef enum {DOOR_CLOSED, DOOR_OPEN} door_state; 
// Job of assertion to check whether lift is stopped when door is open

// Monitor sends output transaction to scoreboard whenever door state changes
// Driver sends input transaction to scoreboard whenever a request is placed
// If stop request is placed inside lift, one input transaction, door_state OPEN, lift direction IGNORED
// If up/down request is placed from a floor, two input transactions, first door_state OPEN, lift direction IGNORED
// then door_state CLOSED, lift direction should match, both same timestamp
// TODO: Write scoreboard strategy to check out-of-order transactions https://vlsiverify.com/uvm/uvm-scoreboard/#Out-of-order_scoreboard

class lift_controller_seq_item #(parameter N_FLOORS = 12) extends uvm_sequence_item;
    lift_direction dir;
    door_state door;
    int floor;
    time timestamp;

    `uvm_object_utils_begin(lift_controller_seq_item)
        `uvm_field_int(dir,UVM_ALL_ON)
        `uvm_field_int(door,UVM_ALL_ON)
        `uvm_field_int(floor,UVM_ALL_ON)
        `uvm_field_int(timestamp,UVM_ALL_ON)
    `uvm_object_utils_end
endclass

`endif