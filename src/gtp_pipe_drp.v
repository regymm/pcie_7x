//-----------------------------------------------------------------------------
//
// (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
`timescale 1ns / 1ps

module gtp_pipe_drp (
    //---------- Input -------------------------------------
    input               DRP_CLK,
    input               DRP_RST_N,
    input               DRP_X16,
    input               DRP_START,
    input       [15:0]  DRP_DO,
    input               DRP_RDY,
    //---------- Output ------------------------------------
    //output      [ 8:0]  DRP_ADDR,
    output              DRP_EN,  
    output      [15:0]  DRP_DI,   
    output              DRP_WE,
    output              DRP_DONE
    //output      [ 2:0]  DRP_FSM
);
    //---------- Input Registers ---------------------------
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg                 x16_reg1;
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg                 start_reg1;
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg         [15:0]  do_reg1;
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg                 rdy_reg1;
    
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg                 x16_reg2;
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg                 start_reg2;
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg         [15:0]  do_reg2;
(* ASYNC_REG = "TRUE", SHIFT_EXTRACT = "NO" *)    reg                 rdy_reg2;
    
    //---------- Internal Signals --------------------------
    //reg         [ 8:0]  addr_reg =  9'd0;
    //reg         [15:0]  di_reg   = 16'd0;
    //---------- Output Registers --------------------------
    //---------- DRP Address -------------------------------
    //localparam          ADDR_RX_DATAWIDTH  = 9'h011;              
    //---------- DRP Data ----------------------------------
    //wire        [15:0]  data_rx_datawidth;                 
    //---------- FSM ---------------------------------------
    localparam          FSM_IDLE  = 0;  
    localparam          FSM_LOAD  = 1;                           
    localparam          FSM_READ  = 2;
    localparam          FSM_RRDY  = 3;
    localparam          FSM_WRITE = 4;
    localparam          FSM_WRDY  = 5;    
    localparam          FSM_DONE  = 6;   
    reg                 done     =  1'd0;
    reg         [ 2:0]  fsm      =  0;      
    
//---------- Input FF ----------------------------------------------------------
always @ (posedge DRP_CLK) begin
    if (!DRP_RST_N) begin
        //---------- 1st Stage FF --------------------------
        x16_reg1   <=  1'd0;
        do_reg1    <= 16'd0;
        rdy_reg1   <=  1'd0;
        start_reg1 <=  1'd0;
        //---------- 2nd Stage FF --------------------------
        x16_reg2   <=  1'd0;
        do_reg2    <= 16'd0;
        rdy_reg2   <=  1'd0;
        start_reg2 <=  1'd0;
	end else begin
        //---------- 1st Stage FF --------------------------
        x16_reg1   <= DRP_X16;
        do_reg1    <= DRP_DO;
        rdy_reg1   <= DRP_RDY;
        start_reg1 <= DRP_START;
        //---------- 2nd Stage FF --------------------------
        x16_reg2   <= x16_reg1;
        do_reg2    <= do_reg1;
        rdy_reg2   <= rdy_reg1;
        start_reg2 <= start_reg1;
	end
end  

//---------- Select DRP Data ---------------------------------------------------
//assign data_rx_datawidth = x16_reg2 ? X16_RX_DATAWIDTH : X20_RX_DATAWIDTH;

//parameter LOAD_CNT_MAX     = 2'd1;
//reg [ 1:0] load_cnt =  2'd0;

//---------- Update DRP Address and Data ---------------------------------------
//always @ (posedge DRP_CLK) begin
    //if (!DRP_RST_N) begin
        ////addr_reg <=  9'd0;
        //di_reg   <= 16'd0;
	//end else begin
		////addr_reg <= ADDR_RX_DATAWIDTH;
		//di_reg   <= (do_reg2 & MASK_RX_DATAWIDTH) | (x16_reg2 ? X16_RX_DATAWIDTH : X20_RX_DATAWIDTH);
	//end
//end  

//---------- PIPE DRP FSM ------------------------------------------------------
always @ (posedge DRP_CLK) begin
    if (!DRP_RST_N) begin
        fsm   <= FSM_IDLE;
        done  <= 1'd1; //Fix applied for GTP DRP issue
		//load_cnt <= 2'd0;
	end else begin
        case (fsm)
        FSM_IDLE :  begin
            if (start_reg2) begin
                fsm   <= FSM_LOAD;
                done  <= 1'd0; 
			end
		end
        FSM_LOAD : begin
			fsm <= FSM_READ;
		end  
        FSM_READ : begin
            fsm   <= FSM_RRDY;
		end
        FSM_RRDY :    begin
			if (rdy_reg2) fsm <= FSM_WRITE;
		end
        FSM_WRITE :    begin
            fsm   <= FSM_WRDY;
		end       
        FSM_WRDY :    begin
            if(rdy_reg2) fsm <= FSM_DONE;
		end        
        FSM_DONE : begin
			fsm   <= FSM_IDLE;
			done  <= 1'd1;	//Fix applied for GTP DRP issue
		end     
        default : begin      
            fsm   <= FSM_IDLE;
            done  <= 1'd1; //Fix applied for GTP DRP issue
		end
        endcase
	end
end 

////---------- DRP Mask ----------------------------------
//localparam          MASK_RX_DATAWIDTH  = 16'b1111011111111111;  // Unmask bit [   11]  
////---------- DRP Data for x16 --------------------------
//localparam          X16_RX_DATAWIDTH   = 16'b0000000000000000;  // 2-byte (16-bit) internal data width
////---------- DRP Data for x20 --------------------------
//localparam          X20_RX_DATAWIDTH   = 16'b0000100000000000;  // 2-byte (20-bit) internal data width               

//assign DRP_ADDR = addr_reg;
assign DRP_EN   = (fsm == FSM_READ) || (fsm == FSM_WRITE);
assign DRP_DI   = (do_reg2 & 16'hF7FF) | (x16_reg2 ? 16'h0 : 16'h0800);
assign DRP_WE   = (fsm == FSM_WRITE);
assign DRP_DONE = done;
endmodule
