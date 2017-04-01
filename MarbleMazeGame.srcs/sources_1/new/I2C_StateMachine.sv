`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2016 11:06:49 AM
// Design Name: 
// Module Name: I2C_StateMachine
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


module I2C_StateMachine(
    input logic clk, reset,// en, rw,
    input logic [7:0] address,          // address of register
    input logic [7:0] data_wr,
    inout logic sda, scl,               // serial data and clock lines
    output logic [7:0] data_rd,
    output logic load
    );
    
    // MPU6050 registers
    logic [7:0] PWR_MGMT_1 = 8'h6b;
    logic [7:0] ACCEL_XOUT_H = 8'h3c;     
    
    // I2C address of MPU6050
    logic [7:0] chip_write = {7'h68, 1'b0};
    logic [7:0] chip_read  = {7'h68, 1'b1};
    
    
    logic sda_in, scl_in = 1'b0;               // sda and scl(400kHz) lines for internal use
    
    // clock divider
    logic [6:0] count = 7'd0;
    logic clk_en;                       // new clock about 800 kHz
    always_ff@(posedge clk) begin
        count <= count + 1;
    
        if(count == 7'd124)
            count <= 7'd0;
    
        if(count <= 7'd63)
            clk_en <= 1'b1;
        else
            clk_en <= 1'b0;
    end
    
    // finite state machine
    logic [6:0] s, nextS;               // current and next states
    logic [2:0] bitcount;
    // state register
    always_ff@(posedge clk_en) begin
        if(~reset)
            s <= 0;
        else
            s <= nextS;
        scl_in = ~scl_in;
    end
    // next state and output logic
    always_ff@(negedge clk_en)
        case(s)
            0: begin
                sda_in <= 1;
                nextS <= 1;
                bitcount <= 7;
//                data_rd <= 8'b11111111;       // for testing
                load <= 0;
            end
            1: begin
                if(scl_in) begin       // starting the transmission
                    sda_in <= 0;
                    nextS <= 2;
                end
            end
            2: begin
                if(~scl_in) begin
                    sda_in <= chip_write[bitcount];
                    if(bitcount > 0)
                        nextS <= 3;
                    else begin
                        bitcount <= 7;
                        nextS <= 4;
                    end
                end
            end
            3: begin
                bitcount <= bitcount - 1;
                nextS <= 2;
            end
            4: begin
                if(~scl_in) begin
                    sda_in <= 1;        // releasing the data line
                    nextS <= 5;
                end
            end
            5: begin
                if(~scl_in) begin
                    sda_in <= PWR_MGMT_1[bitcount];     // send data
                    if(bitcount > 0)
                        nextS <= 6;
                    else begin
                        bitcount <= 7;
                        nextS <= 7;
                    end
                end
            end
            6: begin
                bitcount <= bitcount - 1;
                nextS <= 5;
            end
            7: begin
                if(~scl_in) begin
                    sda_in <= 1;        // releasing the data line
                    nextS <= 8;
                end
            end
            8: begin
                if(~scl_in) begin
                    sda_in <= 0;     // send data
                    if(bitcount > 0)
                        nextS <= 9;
                    else begin
                        bitcount <= 7;
                        nextS <= 10;
                    end
                end
            end
            9: begin
                bitcount <= bitcount - 1;
                nextS <= 8;
            end
            10: begin
                if(~scl_in) begin
                    sda_in <= 1;        // releasing the data line
                    nextS <= 11;
                end
            end
            11: begin
                if(~scl_in) begin
                    sda_in <= 0;
                    nextS <= 12;
                end
            end
            12: begin
                if(scl_in) begin
                    sda_in <= 1;        // stoping the transmission
                    nextS <= 13;
                end
            end
            13: begin
                if(scl_in) begin
                    sda_in <= 0;        // starting new transmission
                    nextS <= 14;
                    load <= 0;
                end
            end
            14: begin
                if(~scl_in) begin
                    sda_in <= chip_write[bitcount];
                    if(bitcount > 0)
                        nextS <= 15;
                    else begin
                        bitcount <= 7;
                        nextS <= 16;
                    end
                end
            end
            15: begin
                bitcount <= bitcount - 1;
                nextS <= 14;
            end
            16: begin
                if(~scl_in) begin
                    sda_in <= 1;        // releasing the data line
                    nextS <= 17;
                end
            end
            17: begin
                if(~scl_in) begin
                    sda_in <= address[bitcount];
                    if(bitcount > 0)
                        nextS <= 18;
                    else begin
                        bitcount <= 7;
                        nextS <= 19;
                    end
                end
            end
            18: begin
                bitcount <= bitcount - 1;
                nextS <= 17;
            end
            19: begin
                if(~scl_in) begin
                    sda_in <= 1;        // releasing the data line
                    nextS <= 20;
                end
            end
            20: begin
                if(scl_in) begin
                    sda_in <= 0;        // restarting..
                    nextS <= 21;
                end
            end
            21: begin
                if(~scl_in) begin
                    sda_in <= chip_read[bitcount];
                    if(bitcount > 0)
                        nextS <= 22;
                    else begin
                        bitcount <= 7;
                        nextS <= 23;
                    end
                end
            end
            22: begin
                bitcount <= bitcount - 1;
                nextS <= 21;
            end
            23: begin
                if(~scl_in) begin
                    sda_in <= 1;        // releasing the data line
                    nextS <= 29;
                end
            end
            29: begin
                if(~scl_in)
                    nextS <= 24;
            end
            24: begin                   // start reading
                if(scl_in) begin
    
                    if(sda == 1'bz)
                        data_rd[bitcount] <= 1;
                    else if (sda == 1'b0)
                        data_rd[bitcount] <= sda;
                        
                    if(bitcount > 0)
                        nextS <= 25;
                    else begin
                        bitcount <= 7;
                        nextS <= 26;
                    end
                end
            end
            25: begin
                bitcount <= bitcount - 1;
                nextS <= 24;
            end
            26: begin
                if(~scl_in) begin
                    sda_in <= 0;        // sending ack signal
                    nextS <= 27;
                end
            end
            27: begin
                if(~scl_in) begin
                    nextS <= 28;        
                end
            end
            28: begin
                if(scl_in) begin
                    sda_in <= 1;        // end transmission
                    load <= 1;
                end
            end
    
        endcase
    
    
    assign sda = sda_in ? 1'bz : 0;     // because sda and scl lines are open-drain lines
    assign scl = scl_in ? 1'bz : 0;     // they can only be set low
    
    endmodule
