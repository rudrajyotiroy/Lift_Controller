`ifndef LIFT_CONTROLLER_SEQ_ITEM
`define LIFT_CONTROLLER_SEQ_ITEM

// Used in monitor only
typedef enum {DIR_UP, DIR_DN} lift_direction;
typedef enum {DOOR_CLOSED, DOOR_OPEN} door_state; 
// Job of assertion to check whether lift is stopped when door is open

// Monitor sends output transaction to scoreboard whenever door state or floor state changes
// Driver sends input transaction to scoreboard whenever a request is placed
// If stop request is placed inside lift, one input transaction, door_state OPEN, lift direction IGNORED
// If up/down request is placed from a floor, two input transactions, first door_state OPEN, lift direction IGNORED
// then door_state CLOSED, lift direction should match, both same timestamp
// Criteria for test success : - All input transactions have an output transaction with a later or equal timestamp
// NOTE : - There might (almost certainly will) be excess output transactions which might be used to calculate efficiency

class lift_controller_seq_item #(parameter N_FLOORS = 12) extends uvm_sequence_item;
    lift_direction dir;
    door_state door;
    int floor;
    time timestamp;
endclass

`endif