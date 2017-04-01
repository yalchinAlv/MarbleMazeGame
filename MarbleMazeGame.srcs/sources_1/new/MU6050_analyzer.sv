`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2016 11:13:46 AM
// Design Name: 
// Module Name: MU6050_analyzer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MPU6050_analyzer(
    input logic clk, reset,
    inout logic sda, scl,
    output logic up, down, right, left
    );

    // MPU6050 registers to get accelerometer value
    logic [7:0] ACCEL_XOUT_H = 8'h3B;
    logic [7:0] ACCEL_XOUT_L = 8'h3C;
    logic [7:0] ACCEL_YOUT_H = 8'h3D;
    logic [7:0] ACCEL_YOUT_L = 8'h3E;
    logic [7:0] ACCEL_ZOUT_H = 8'h40;
    logic [7:0] ACCEL_ZOUT_L = 8'h41;
    
    logic [7:0] address;
    logic [7:0] data_rd;
    logic [7:0] data_wr;
    logic load;
    logic [7:0] accel_Xout_h;
    logic [7:0] accel_Yout_h;
    logic [7:0] accel_Zout_h;
    logic [7:0] accel_Xout_l;
    logic [7:0] accel_Yout_l;
    logic [7:0] accel_Zout_l;
    
    // data loader and reader
    I2C_StateMachine asd(clk, reset, address, data_wr, sda, scl, data_rd, load);
    
    logic [4:0] s, nextS;
    
    // state register
    always_ff@(posedge load)
        if(~reset)
            s <= 0;
        else
            s <= nextS;
    

    // next state and output logic
    always_comb
        case(s)
            0: begin
                data_wr = 8'h00;
                address = ACCEL_XOUT_H;
                nextS = 1;
            end
            1: begin
                accel_Xout_h = data_rd;
                nextS = 2;
            end
            2: begin
                address = ACCEL_XOUT_L;
                nextS = 3;
            end
            3: begin
                accel_Xout_l = data_rd;
                nextS = 4;
            end
            4: begin
                address = ACCEL_YOUT_H;
                nextS = 5;
            end
            5: begin
                accel_Yout_h = data_rd;
                nextS = 6;
            end
            6: begin
                address = ACCEL_YOUT_L;
                nextS = 7;
            end
            7: begin
                accel_Yout_l = data_rd;
                nextS = 8;
            end
            8: begin
                address = ACCEL_ZOUT_H;
                nextS = 9;
            end
            9: begin
                accel_Zout_h = data_rd;
                nextS = 10;
            end
            10: begin
                address = ACCEL_ZOUT_L;
                nextS = 11;
            end
            11: begin
                accel_Zout_l = data_rd;
                nextS = 0;
            end
        endcase
    
endmodule
