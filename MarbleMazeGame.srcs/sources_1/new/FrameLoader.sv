`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2016 01:26:14 AM
// Design Name: 
// Module Name: FrameLoader
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


module FrameLoader(
    input logic clk, reset,
    input logic [15:0][7:0] frame,
    output logic spi_clk, mosi, load, finish
    );
    
    // max7219 registers
        logic [7:0] reg_noop        = 8'h00;
        logic [7:0] reg_digit0      = 8'h01;
        logic [7:0] reg_digit1      = 8'h02;
        logic [7:0] reg_digit2      = 8'h03;
        logic [7:0] reg_digit3      = 8'h04;
        logic [7:0] reg_digit4      = 8'h05;
        logic [7:0] reg_digit5      = 8'h06;
        logic [7:0] reg_digit6      = 8'h07;
        logic [7:0] reg_digit7      = 8'h08;
        logic [7:0] reg_decodeMode  = 8'h09;
        logic [7:0] reg_intensity   = 8'h0a;
        logic [7:0] reg_scanLimit   = 8'h0b;
        logic [7:0] reg_shutdown    = 8'h0c;
        logic [7:0] reg_displayTest = 8'h0f;
        
        logic [7:0] data1; // data to load on 1st LED matrix
        logic [7:0] data2; // data to load on 2nd LED matrix
        logic [7:0] address1; // address of register on 1st LED matrix
        logic [7:0] address2; // address of register on 2nd LED matrix
    
    // clock divider
    logic [5:0] count = 5'd0;
    always@(posedge clk) begin
         count <= count + 1;
                    
         if( count == 5'd19)
            count <= 5'd0;
         if( count <= 5'd9)
            spi_clk <= 1'b1;
         else
            spi_clk <= 1'b0;
    end
    
    // module to load the data to max7219
    SPI_StateMachine DLSM( spi_clk, reset, address2, data2, address1, data1, mosi, load);
    
    logic [5:0] s, nextS;
    
    // state register
    always_ff@(posedge load, negedge reset)
        if(~reset)
            s <= 0;
        else
            s <= nextS;
        
    // states
    always_comb
        case(s)
            0: begin
                address2 = reg_scanLimit;
                data2 = 8'h07;
                address1 = reg_scanLimit;
                data1 = 8'h07;
                nextS = 1;
                finish = 0;
            end
            1: begin
                address2 = reg_decodeMode;
                data2 = 8'h00;
                address1 = reg_decodeMode;
                data1 = 8'h00;
                nextS = 2;
            end
            2: begin
                address2 = reg_shutdown;
                data2 = 8'h01;
                address1 = reg_shutdown;
                data1 = 8'h01;
                nextS = 3;
            end
            3: begin
                address2 = reg_displayTest;
                data2 = 8'h00;
                address1 = reg_displayTest;
                data1 = 8'h00;
                nextS = 4;
            end
            4: begin
                address2 = reg_intensity;
                data2 = 8'h0f;
                address1 = reg_intensity;
                data1 = 8'h0f;
                nextS = 5;
            end
            5: begin
                address2 = reg_digit0;
                data2 = 8'h00;
                address1 = reg_digit0;
                data1 = 8'h00;
                nextS = 6;
            end
            6: begin
                address2 = reg_digit1;
                data2 = 8'h00;
                address1 = reg_digit1;
                data1 = 8'h00;
                nextS = 7;
            end
            7: begin
                address2 = reg_digit2;
                data2 = 8'h00;
                address1 = reg_digit2;
                data1 = 8'h00;
                nextS = 8;
            end
            8: begin
                address2 = reg_digit3;
                data2 = 8'h00;
                address1 = reg_digit3;
                data1 = 8'h00;
                nextS = 9;
            end
            9: begin
                address2 = reg_digit4;
                data2 = 8'h00;
                address1 = reg_digit4;
                data1 = 8'h00;
                nextS = 10;
            end
            10: begin
                address2 = reg_digit5;
                data2 = 8'h00;
                address1 = reg_digit5;
                data1 = 8'h00;
                nextS = 11;
            end
            11: begin
                address2 = reg_digit6;
                data2 = 8'h00;
                address1 = reg_digit6;
                data1 = 8'h00;
                nextS = 12;
            end
            12: begin
                address2 = reg_digit7;
                data2 = 8'h00;
                address1 = reg_digit7;
                data1 = 8'h00;
                nextS = 14;
            end
            14: begin
                address2 = reg_noop;
                data2 = 8'h00;
                address1 = reg_noop;
                data1 = 8'h00;
                nextS = 15;
                finish = 0;
            end
            15: begin
                address2 = reg_digit0;
                data1 = frame[15];
                address1 = reg_digit0;
                data2 = frame[7];
                nextS = 16;
            end
            16: begin
                address2 = reg_digit1;
                data1 = frame[14];
                address1 = reg_digit1;
                data2 = frame[6];
                nextS = 17;
            end
            17: begin
                address2 = reg_digit2;
                data1 = frame[13];
                address1 = reg_digit2;
                data2 = frame[5];
                nextS = 18;
            end
            18: begin
                address2 = reg_digit3;
                data1 = frame[12];
                address1 = reg_digit3;
                data2 = frame[4];
                nextS = 19;
            end
            19: begin
                address2 = reg_digit4;
                data1 = frame[11];
                address1 = reg_digit4;
                data2 = frame[3];
                nextS = 20;
            end
            20: begin
                address2 = reg_digit5;
                data1 = frame[10];
                address1 = reg_digit5;
                data2 = frame[2];
                nextS = 21;
            end
            21: begin
                address2 = reg_digit6;
                data1 = frame[9];
                address1 = reg_digit6;
                data2 = frame[1];
                nextS = 22;
            end
            22: begin
                address2 = reg_digit7;
                data1 = frame[8];
                address1 = reg_digit7;
                data2 = frame[0];
                nextS = 23;
            end
            23: begin
                address2 = reg_noop;
                data2 = 8'h00;
                address1 = reg_noop;
                data1 = 8'h00;
                finish = 1;
                nextS = 14;
            end
        endcase   

endmodule