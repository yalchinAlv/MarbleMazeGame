`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2016 01:26:45 AM
// Design Name: 
// Module Name: SPI_StateMachine
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


module SPI_StateMachine(
    input logic spi_clk, reset, [7:0] address2, [7:0] data2, [7:0] address1, [7:0] data1,
    output logic mosi, load
    );
    
    typedef enum logic [5:0] { S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20, S21, S22, S23, S24, S25, S26, S27, S28, S29, S30, S31, S32, S33} statetype;
    statetype s, nextS;
    
    logic [31:0] serial_data;
    
    // state registor
    always_ff@(negedge spi_clk)
        if (~reset)
            s <= S0;
        else
            s <= nextS;
            
    // next state logic
    always_comb
        case(s)
            S0: nextS = S1;
            S1: nextS = S2;
            S2: nextS = S3;
            S3: nextS = S4;
            S4: nextS = S5;
            S5: nextS = S6;
            S6: nextS = S7;
            S7: nextS = S8;
            S8: nextS = S9;
            S9: nextS = S10;                
            S10: nextS = S11;
            S11: nextS = S12;
            S12: nextS = S13;
            S13: nextS = S14;
            S14: nextS = S15;
            S15: nextS = S16;
            S16: nextS = S17;
            S17: nextS = S18;
            S18: nextS = S19;
            S19: nextS = S20;
            S20: nextS = S21;
            S21: nextS = S22;
            S22: nextS = S23;
            S23: nextS = S24;
            S24: nextS = S25;
            S25: nextS = S26;
            S26: nextS = S27;
            S27: nextS = S28;
            S28: nextS = S29;
            S29: nextS = S30;
            S30: nextS = S31;
            S31: nextS = S32;
            S32: nextS = S33;
            S33: nextS = S0;
            
        endcase
        
    // output logic
    always_comb
        case(s)
            S0: begin mosi = 0; load = 0; end
            S1: begin mosi = serial_data[31]; load = 0; end
            S2: begin mosi = serial_data[30]; load = 0; end
            S3: begin mosi = serial_data[29]; load = 0; end
            S4: begin mosi = serial_data[28]; load = 0; end
            S5: begin mosi = serial_data[27]; load = 0; end
            S6: begin mosi = serial_data[26]; load = 0; end
            S7: begin mosi = serial_data[25]; load = 0; end
            S8: begin mosi = serial_data[24]; load = 0; end
            S9: begin mosi = serial_data[23]; load = 0; end
            S10: begin mosi = serial_data[22]; load = 0; end
            S11: begin mosi = serial_data[21]; load = 0; end
            S12: begin mosi = serial_data[20]; load = 0; end
            S13: begin mosi = serial_data[19]; load = 0; end
            S14: begin mosi = serial_data[18]; load = 0; end
            S15: begin mosi = serial_data[17]; load = 0; end
            S16: begin mosi = serial_data[16]; load = 0; end
            S17: begin mosi = serial_data[15]; load = 0; end
            S18: begin mosi = serial_data[14]; load = 0; end
            S19: begin mosi = serial_data[13]; load = 0; end
            S20: begin mosi = serial_data[12]; load = 0; end
            S21: begin mosi = serial_data[11]; load = 0; end
            S22: begin mosi = serial_data[10]; load = 0; end
            S23: begin mosi = serial_data[9]; load = 0; end
            S24: begin mosi = serial_data[8]; load = 0; end
            S25: begin mosi = serial_data[7]; load = 0; end
            S26: begin mosi = serial_data[6]; load = 0; end
            S27: begin mosi = serial_data[5]; load = 0; end
            S28: begin mosi = serial_data[4]; load = 0; end
            S29: begin mosi = serial_data[3]; load = 0; end
            S30: begin mosi = serial_data[2]; load = 0; end
            S31: begin mosi = serial_data[1]; load = 0; end
            S32: begin mosi = serial_data[0]; load = 0; end
            S33: begin mosi = 0; load = 1; end
        endcase
        
        assign serial_data = {address2, data2, address1, data1};
        
        
endmodule
