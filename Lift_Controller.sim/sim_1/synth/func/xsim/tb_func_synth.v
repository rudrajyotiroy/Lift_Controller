// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
// Date        : Mon Sep 25 00:20:17 2023
// Host        : DESKTOP-SUFLN7R running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               C:/Users/rudra/OneDrive/Documents/Lift_Controller/Lift_Controller.sim/sim_1/synth/func/xsim/tb_func_synth.v
// Design      : door_controller
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k70tfbv676-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* DOOR_OPEN_CYCLES = "200" *) (* EDGE_INPUTS = "2" *) (* N_FLOORS = "12" *) 
(* NotValidForBitStream *)
module door_controller
   (clk,
    reset,
    edge_in,
    force_open,
    door_open);
  input clk;
  input reset;
  input [1:0]edge_in;
  input force_open;
  output door_open;

  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire counter_active;
  wire counter_active_i_2_n_0;
  wire door_open;
  wire door_open_OBUF;
  wire force_open;
  wire force_open_IBUF;
  wire reset;
  wire reset_IBUF;
  wire [31:0]sel0;
  wire [7:3]up_counter;
  wire \up_counter[11]_i_2_n_0 ;
  wire \up_counter[11]_i_3_n_0 ;
  wire \up_counter[11]_i_4_n_0 ;
  wire \up_counter[11]_i_5_n_0 ;
  wire \up_counter[15]_i_2_n_0 ;
  wire \up_counter[15]_i_3_n_0 ;
  wire \up_counter[15]_i_4_n_0 ;
  wire \up_counter[15]_i_5_n_0 ;
  wire \up_counter[19]_i_2_n_0 ;
  wire \up_counter[19]_i_3_n_0 ;
  wire \up_counter[19]_i_4_n_0 ;
  wire \up_counter[19]_i_5_n_0 ;
  wire \up_counter[23]_i_2_n_0 ;
  wire \up_counter[23]_i_3_n_0 ;
  wire \up_counter[23]_i_4_n_0 ;
  wire \up_counter[23]_i_5_n_0 ;
  wire \up_counter[27]_i_2_n_0 ;
  wire \up_counter[27]_i_3_n_0 ;
  wire \up_counter[27]_i_4_n_0 ;
  wire \up_counter[27]_i_5_n_0 ;
  wire \up_counter[2]_i_2_n_0 ;
  wire \up_counter[2]_i_3_n_0 ;
  wire \up_counter[2]_i_4_n_0 ;
  wire \up_counter[2]_i_5_n_0 ;
  wire \up_counter[31]_i_2_n_0 ;
  wire \up_counter[31]_i_3_n_0 ;
  wire \up_counter[31]_i_4_n_0 ;
  wire \up_counter[31]_i_5_n_0 ;
  wire \up_counter[5]_i_2_n_0 ;
  wire \up_counter[5]_i_3_n_0 ;
  wire \up_counter[5]_i_4_n_0 ;
  wire \up_counter[5]_i_5_n_0 ;
  wire \up_counter[7]_i_2_n_0 ;
  wire \up_counter[7]_i_3_n_0 ;
  wire \up_counter[7]_i_4_n_0 ;
  wire \up_counter[7]_i_5_n_0 ;
  wire \up_counter[7]_i_6_n_0 ;
  wire \up_counter[7]_i_7_n_0 ;
  wire \up_counter[7]_i_8_n_0 ;
  wire \up_counter_reg[11]_i_1_n_0 ;
  wire \up_counter_reg[11]_i_1_n_1 ;
  wire \up_counter_reg[11]_i_1_n_2 ;
  wire \up_counter_reg[11]_i_1_n_3 ;
  wire \up_counter_reg[15]_i_1_n_0 ;
  wire \up_counter_reg[15]_i_1_n_1 ;
  wire \up_counter_reg[15]_i_1_n_2 ;
  wire \up_counter_reg[15]_i_1_n_3 ;
  wire \up_counter_reg[19]_i_1_n_0 ;
  wire \up_counter_reg[19]_i_1_n_1 ;
  wire \up_counter_reg[19]_i_1_n_2 ;
  wire \up_counter_reg[19]_i_1_n_3 ;
  wire \up_counter_reg[23]_i_1_n_0 ;
  wire \up_counter_reg[23]_i_1_n_1 ;
  wire \up_counter_reg[23]_i_1_n_2 ;
  wire \up_counter_reg[23]_i_1_n_3 ;
  wire \up_counter_reg[27]_i_1_n_0 ;
  wire \up_counter_reg[27]_i_1_n_1 ;
  wire \up_counter_reg[27]_i_1_n_2 ;
  wire \up_counter_reg[27]_i_1_n_3 ;
  wire \up_counter_reg[2]_i_1_n_0 ;
  wire \up_counter_reg[2]_i_1_n_1 ;
  wire \up_counter_reg[2]_i_1_n_2 ;
  wire \up_counter_reg[2]_i_1_n_3 ;
  wire \up_counter_reg[31]_i_1_n_1 ;
  wire \up_counter_reg[31]_i_1_n_2 ;
  wire \up_counter_reg[31]_i_1_n_3 ;
  wire \up_counter_reg[5]_i_1_n_0 ;
  wire \up_counter_reg[5]_i_1_n_1 ;
  wire \up_counter_reg[5]_i_1_n_2 ;
  wire \up_counter_reg[5]_i_1_n_3 ;
  wire \up_counter_reg_n_0_[0] ;
  wire \up_counter_reg_n_0_[10] ;
  wire \up_counter_reg_n_0_[11] ;
  wire \up_counter_reg_n_0_[12] ;
  wire \up_counter_reg_n_0_[13] ;
  wire \up_counter_reg_n_0_[14] ;
  wire \up_counter_reg_n_0_[15] ;
  wire \up_counter_reg_n_0_[16] ;
  wire \up_counter_reg_n_0_[17] ;
  wire \up_counter_reg_n_0_[18] ;
  wire \up_counter_reg_n_0_[19] ;
  wire \up_counter_reg_n_0_[1] ;
  wire \up_counter_reg_n_0_[20] ;
  wire \up_counter_reg_n_0_[21] ;
  wire \up_counter_reg_n_0_[22] ;
  wire \up_counter_reg_n_0_[23] ;
  wire \up_counter_reg_n_0_[24] ;
  wire \up_counter_reg_n_0_[25] ;
  wire \up_counter_reg_n_0_[26] ;
  wire \up_counter_reg_n_0_[27] ;
  wire \up_counter_reg_n_0_[28] ;
  wire \up_counter_reg_n_0_[29] ;
  wire \up_counter_reg_n_0_[2] ;
  wire \up_counter_reg_n_0_[30] ;
  wire \up_counter_reg_n_0_[31] ;
  wire \up_counter_reg_n_0_[3] ;
  wire \up_counter_reg_n_0_[4] ;
  wire \up_counter_reg_n_0_[5] ;
  wire \up_counter_reg_n_0_[6] ;
  wire \up_counter_reg_n_0_[7] ;
  wire \up_counter_reg_n_0_[8] ;
  wire \up_counter_reg_n_0_[9] ;
  wire [3:3]\NLW_up_counter_reg[31]_i_1_CO_UNCONNECTED ;

  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  LUT6 #(
    .INIT(64'hFFFFFFFF00000100)) 
    counter_active_i_1
       (.I0(\up_counter[7]_i_4_n_0 ),
        .I1(\up_counter[7]_i_3_n_0 ),
        .I2(\up_counter[7]_i_2_n_0 ),
        .I3(sel0[7]),
        .I4(counter_active_i_2_n_0),
        .I5(reset_IBUF),
        .O(counter_active));
  LUT2 #(
    .INIT(4'h7)) 
    counter_active_i_2
       (.I0(sel0[3]),
        .I1(sel0[6]),
        .O(counter_active_i_2_n_0));
  FDRE #(
    .INIT(1'b0)) 
    counter_active_reg
       (.C(clk_IBUF_BUFG),
        .CE(force_open_IBUF),
        .D(force_open_IBUF),
        .Q(door_open_OBUF),
        .R(counter_active));
  OBUF door_open_OBUF_inst
       (.I(door_open_OBUF),
        .O(door_open));
  IBUF force_open_IBUF_inst
       (.I(force_open),
        .O(force_open_IBUF));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[11]_i_2 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[11] ),
        .O(\up_counter[11]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[11]_i_3 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[10] ),
        .O(\up_counter[11]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[11]_i_4 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[9] ),
        .O(\up_counter[11]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[11]_i_5 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[8] ),
        .O(\up_counter[11]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[15]_i_2 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[15] ),
        .O(\up_counter[15]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[15]_i_3 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[14] ),
        .O(\up_counter[15]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[15]_i_4 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[13] ),
        .O(\up_counter[15]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[15]_i_5 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[12] ),
        .O(\up_counter[15]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[19]_i_2 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[19] ),
        .O(\up_counter[19]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[19]_i_3 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[18] ),
        .O(\up_counter[19]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[19]_i_4 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[17] ),
        .O(\up_counter[19]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[19]_i_5 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[16] ),
        .O(\up_counter[19]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[23]_i_2 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[23] ),
        .O(\up_counter[23]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[23]_i_3 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[22] ),
        .O(\up_counter[23]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[23]_i_4 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[21] ),
        .O(\up_counter[23]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[23]_i_5 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[20] ),
        .O(\up_counter[23]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[27]_i_2 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[27] ),
        .O(\up_counter[27]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[27]_i_3 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[26] ),
        .O(\up_counter[27]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[27]_i_4 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[25] ),
        .O(\up_counter[27]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[27]_i_5 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[24] ),
        .O(\up_counter[27]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[2]_i_2 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[3] ),
        .O(\up_counter[2]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[2]_i_3 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[2] ),
        .O(\up_counter[2]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[2]_i_4 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[1] ),
        .O(\up_counter[2]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFD02)) 
    \up_counter[2]_i_5 
       (.I0(\up_counter_reg_n_0_[0] ),
        .I1(force_open_IBUF),
        .I2(reset_IBUF),
        .I3(door_open_OBUF),
        .O(\up_counter[2]_i_5_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[31]_i_2 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[31] ),
        .O(\up_counter[31]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[31]_i_3 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[30] ),
        .O(\up_counter[31]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[31]_i_4 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[29] ),
        .O(\up_counter[31]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[31]_i_5 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[28] ),
        .O(\up_counter[31]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hCCCCCCC4CCCCCCCC)) 
    \up_counter[3]_i_1 
       (.I0(sel0[6]),
        .I1(sel0[3]),
        .I2(\up_counter[7]_i_4_n_0 ),
        .I3(\up_counter[7]_i_3_n_0 ),
        .I4(\up_counter[7]_i_2_n_0 ),
        .I5(sel0[7]),
        .O(up_counter[3]));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[5]_i_2 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[7] ),
        .O(\up_counter[5]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[5]_i_3 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[6] ),
        .O(\up_counter[5]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[5]_i_4 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[5] ),
        .O(\up_counter[5]_i_4_n_0 ));
  LUT3 #(
    .INIT(8'h10)) 
    \up_counter[5]_i_5 
       (.I0(reset_IBUF),
        .I1(force_open_IBUF),
        .I2(\up_counter_reg_n_0_[4] ),
        .O(\up_counter[5]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hCCCCCCC4CCCCCCCC)) 
    \up_counter[6]_i_1 
       (.I0(sel0[3]),
        .I1(sel0[6]),
        .I2(\up_counter[7]_i_4_n_0 ),
        .I3(\up_counter[7]_i_3_n_0 ),
        .I4(\up_counter[7]_i_2_n_0 ),
        .I5(sel0[7]),
        .O(up_counter[6]));
  LUT6 #(
    .INIT(64'hFE00FF00FF00FF00)) 
    \up_counter[7]_i_1 
       (.I0(\up_counter[7]_i_2_n_0 ),
        .I1(\up_counter[7]_i_3_n_0 ),
        .I2(\up_counter[7]_i_4_n_0 ),
        .I3(sel0[7]),
        .I4(sel0[3]),
        .I5(sel0[6]),
        .O(up_counter[7]));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \up_counter[7]_i_2 
       (.I0(sel0[16]),
        .I1(sel0[17]),
        .I2(sel0[14]),
        .I3(sel0[15]),
        .I4(\up_counter[7]_i_5_n_0 ),
        .O(\up_counter[7]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \up_counter[7]_i_3 
       (.I0(sel0[8]),
        .I1(sel0[9]),
        .I2(sel0[4]),
        .I3(sel0[5]),
        .I4(\up_counter[7]_i_6_n_0 ),
        .O(\up_counter[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \up_counter[7]_i_4 
       (.I0(\up_counter[7]_i_7_n_0 ),
        .I1(sel0[23]),
        .I2(sel0[22]),
        .I3(sel0[25]),
        .I4(sel0[24]),
        .I5(\up_counter[7]_i_8_n_0 ),
        .O(\up_counter[7]_i_4_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \up_counter[7]_i_5 
       (.I0(sel0[19]),
        .I1(sel0[18]),
        .I2(sel0[21]),
        .I3(sel0[20]),
        .O(\up_counter[7]_i_5_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \up_counter[7]_i_6 
       (.I0(sel0[11]),
        .I1(sel0[10]),
        .I2(sel0[13]),
        .I3(sel0[12]),
        .O(\up_counter[7]_i_6_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \up_counter[7]_i_7 
       (.I0(sel0[27]),
        .I1(sel0[26]),
        .I2(sel0[29]),
        .I3(sel0[28]),
        .O(\up_counter[7]_i_7_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \up_counter[7]_i_8 
       (.I0(sel0[0]),
        .I1(sel0[30]),
        .I2(sel0[31]),
        .I3(sel0[2]),
        .I4(sel0[1]),
        .O(\up_counter[7]_i_8_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[0]),
        .Q(\up_counter_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[10]),
        .Q(\up_counter_reg_n_0_[10] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[11]),
        .Q(\up_counter_reg_n_0_[11] ),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \up_counter_reg[11]_i_1 
       (.CI(\up_counter_reg[5]_i_1_n_0 ),
        .CO({\up_counter_reg[11]_i_1_n_0 ,\up_counter_reg[11]_i_1_n_1 ,\up_counter_reg[11]_i_1_n_2 ,\up_counter_reg[11]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(sel0[11:8]),
        .S({\up_counter[11]_i_2_n_0 ,\up_counter[11]_i_3_n_0 ,\up_counter[11]_i_4_n_0 ,\up_counter[11]_i_5_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[12]),
        .Q(\up_counter_reg_n_0_[12] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[13]),
        .Q(\up_counter_reg_n_0_[13] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[14]),
        .Q(\up_counter_reg_n_0_[14] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[15]),
        .Q(\up_counter_reg_n_0_[15] ),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \up_counter_reg[15]_i_1 
       (.CI(\up_counter_reg[11]_i_1_n_0 ),
        .CO({\up_counter_reg[15]_i_1_n_0 ,\up_counter_reg[15]_i_1_n_1 ,\up_counter_reg[15]_i_1_n_2 ,\up_counter_reg[15]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(sel0[15:12]),
        .S({\up_counter[15]_i_2_n_0 ,\up_counter[15]_i_3_n_0 ,\up_counter[15]_i_4_n_0 ,\up_counter[15]_i_5_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[16]),
        .Q(\up_counter_reg_n_0_[16] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[17]),
        .Q(\up_counter_reg_n_0_[17] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[18]),
        .Q(\up_counter_reg_n_0_[18] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[19]),
        .Q(\up_counter_reg_n_0_[19] ),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \up_counter_reg[19]_i_1 
       (.CI(\up_counter_reg[15]_i_1_n_0 ),
        .CO({\up_counter_reg[19]_i_1_n_0 ,\up_counter_reg[19]_i_1_n_1 ,\up_counter_reg[19]_i_1_n_2 ,\up_counter_reg[19]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(sel0[19:16]),
        .S({\up_counter[19]_i_2_n_0 ,\up_counter[19]_i_3_n_0 ,\up_counter[19]_i_4_n_0 ,\up_counter[19]_i_5_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[1]),
        .Q(\up_counter_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[20]),
        .Q(\up_counter_reg_n_0_[20] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[21]),
        .Q(\up_counter_reg_n_0_[21] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[22]),
        .Q(\up_counter_reg_n_0_[22] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[23]),
        .Q(\up_counter_reg_n_0_[23] ),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \up_counter_reg[23]_i_1 
       (.CI(\up_counter_reg[19]_i_1_n_0 ),
        .CO({\up_counter_reg[23]_i_1_n_0 ,\up_counter_reg[23]_i_1_n_1 ,\up_counter_reg[23]_i_1_n_2 ,\up_counter_reg[23]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(sel0[23:20]),
        .S({\up_counter[23]_i_2_n_0 ,\up_counter[23]_i_3_n_0 ,\up_counter[23]_i_4_n_0 ,\up_counter[23]_i_5_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[24]),
        .Q(\up_counter_reg_n_0_[24] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[25]),
        .Q(\up_counter_reg_n_0_[25] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[26]),
        .Q(\up_counter_reg_n_0_[26] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[27]),
        .Q(\up_counter_reg_n_0_[27] ),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \up_counter_reg[27]_i_1 
       (.CI(\up_counter_reg[23]_i_1_n_0 ),
        .CO({\up_counter_reg[27]_i_1_n_0 ,\up_counter_reg[27]_i_1_n_1 ,\up_counter_reg[27]_i_1_n_2 ,\up_counter_reg[27]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(sel0[27:24]),
        .S({\up_counter[27]_i_2_n_0 ,\up_counter[27]_i_3_n_0 ,\up_counter[27]_i_4_n_0 ,\up_counter[27]_i_5_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[28]),
        .Q(\up_counter_reg_n_0_[28] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[29]),
        .Q(\up_counter_reg_n_0_[29] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[2]),
        .Q(\up_counter_reg_n_0_[2] ),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \up_counter_reg[2]_i_1 
       (.CI(1'b0),
        .CO({\up_counter_reg[2]_i_1_n_0 ,\up_counter_reg[2]_i_1_n_1 ,\up_counter_reg[2]_i_1_n_2 ,\up_counter_reg[2]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,door_open_OBUF}),
        .O(sel0[3:0]),
        .S({\up_counter[2]_i_2_n_0 ,\up_counter[2]_i_3_n_0 ,\up_counter[2]_i_4_n_0 ,\up_counter[2]_i_5_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[30]),
        .Q(\up_counter_reg_n_0_[30] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[31]),
        .Q(\up_counter_reg_n_0_[31] ),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \up_counter_reg[31]_i_1 
       (.CI(\up_counter_reg[27]_i_1_n_0 ),
        .CO({\NLW_up_counter_reg[31]_i_1_CO_UNCONNECTED [3],\up_counter_reg[31]_i_1_n_1 ,\up_counter_reg[31]_i_1_n_2 ,\up_counter_reg[31]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(sel0[31:28]),
        .S({\up_counter[31]_i_2_n_0 ,\up_counter[31]_i_3_n_0 ,\up_counter[31]_i_4_n_0 ,\up_counter[31]_i_5_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(up_counter[3]),
        .Q(\up_counter_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[4]),
        .Q(\up_counter_reg_n_0_[4] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[5]),
        .Q(\up_counter_reg_n_0_[5] ),
        .R(1'b0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY4 \up_counter_reg[5]_i_1 
       (.CI(\up_counter_reg[2]_i_1_n_0 ),
        .CO({\up_counter_reg[5]_i_1_n_0 ,\up_counter_reg[5]_i_1_n_1 ,\up_counter_reg[5]_i_1_n_2 ,\up_counter_reg[5]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(sel0[7:4]),
        .S({\up_counter[5]_i_2_n_0 ,\up_counter[5]_i_3_n_0 ,\up_counter[5]_i_4_n_0 ,\up_counter[5]_i_5_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(up_counter[6]),
        .Q(\up_counter_reg_n_0_[6] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(up_counter[7]),
        .Q(\up_counter_reg_n_0_[7] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[8]),
        .Q(\up_counter_reg_n_0_[8] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \up_counter_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(1'b1),
        .D(sel0[9]),
        .Q(\up_counter_reg_n_0_[9] ),
        .R(1'b0));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
