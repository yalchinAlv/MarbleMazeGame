`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2016 01:25:29 AM
// Design Name: 
// Module Name: MarbleMazeGame
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


module MarbleMazeGame(
    input logic clk, reset, up, down, right, left, start, mode,     // if mode = 1 then timer will be used in the game
    output logic spi_clk, mosi, load,
    output logic a, b, c, d, e, f, g, dp,
    output logic [3:0] an
    );
    
    logic [15:0][7:0] frame1 ={ 8'b1000_0000,
                                8'b0000_0000,
                                8'b0000_0000,
                                8'b0000_0000,
                                8'b1111_0000,
                                8'b0000_0000,
                                8'b0000_0000,
                                8'b0000_0000,
                                8'b0001_1111,
                                8'b0000_0000,
                                8'b0000_0000,
                                8'b0000_0000,
                                8'b1110_0000,
                                8'b0000_0000,
                                8'b0001_1100,
                                8'b0000_0000 };
    
    logic [15:0][7:0] frame2 ={ 8'b1000_0000,
                                8'b0000_0000,
                                8'b0001_1000,
                                8'b0000_0000,
                                8'b0110_0010,
                                8'b0000_0011,
                                8'b0000_0000,
                                8'b0000_0000,
                                8'b0001_1100,
                                8'b0000_1000,
                                8'b0000_1000,
                                8'b1100_1001,
                                8'b0000_1000,
                                8'b0000_0000,
                                8'b1111_0000,
                                8'b0000_0000 };                          
    
    logic [15:0][7:0] frame3 ={ 8'b1000_0000,                 
                               8'b0000_0001,
                               8'b0010_0001,
                               8'b0010_0100,
                               8'b0010_0100,
                               8'b0110_0101,
                               8'b0010_0100,
                               8'b0010_0100,
                               8'b1010_0100,
                               8'b0010_0110,
                               8'b0010_0000,
                               8'b0010_0000,
                               8'b0111_1100,
                               8'b0010_0000,
                               8'b1000_0011,
                               8'b0000_0000 };
    
    logic [3:0][7:0] one = {
        8'b1000_0100,
        8'b1111_1110,
        8'b1000_0000,
        8'b0000_0000
    };  
    
    logic [3:0][7:0] two = {
        8'b1100_0100,
        8'b1010_0010,
        8'b1001_0010,
        8'b1000_1100
    };  
    
    logic [3:0][7:0] three = {
        8'b0100_0100,
        8'b1000_0010,
        8'b1001_0010,
        8'b0110_1100
    };                             
    
    logic [15:0][7:0] frame;
    logic finish;
    logic [1:0] level;
    logic [2:0] ballRow;
    logic [3:0] ballCol;
    logic [3:0] shift;
    logic [3:0] loading;
    logic [3:0] timer;
    
    FrameLoader asd(clk, reset, frame, spi_clk, mosi, load, finish);
    
    logic [5:0] s, nextS;
    
    // clock divider for frame rate
    logic clk_en = 1'b0;
    logic [8:0] count = 9'd0;
    always_ff@(posedge finish)
        begin
            count <= count + 1;
            
            if(count == 9'd500) begin
                count <= 9'd0;
                clk_en <= 1'b1;
            end
            else
                clk_en <= 1'b0;
        end
    
    // clock divider for game over frame rate
    logic pass = 1'b0;
    logic [4:0] count1 = 5'd0;
    always_ff@(posedge clk_en)
        begin
            count1 <= count1 + 1;
            
            if(count1 == 5'd10) begin
                count1 <= 5'd0;
                pass <= 1'b1;
            end
            else
                pass <= 1'b0;
        end
        
    // clock divider for the timer
    logic timer_clk = 1'b0;
    logic [26:0] count2 = 27'd0;
    always_ff@(posedge clk)
         begin
            count2 <= count2 + 1;
                    
            if(count2 == 27'd100000000) begin
                 count2 <= 27'd0;
                 timer_clk <= 1'b1;
            end
            else
                 timer_clk <= 1'b0;
         end
    
    // register for the timer which is enabled only when mode == 1
    always_ff@(posedge timer_clk) begin
        if(s == 6 | s == 0)
            timer <= 9;
        else if(s == 1 | s == 2 | s == 3 | s == 4 | s == 5 | s == 7 | s == 8 | s == 10 | s == 11 | s == 13)
             begin
                 if(timer != 0)    
                    timer <= timer - 1;
             end
    end
    
    // state register
    always_ff@(negedge clk_en, negedge reset)
        if (~reset) begin
            s <= 0;
        end
        else begin
            
                  // timer affects the game only when the game is not in normal mode(mode = 1)
                if(mode & timer == 0) begin
                    s <= 6;     // game over
                end
                else
                    s <= nextS;
        end
        
    
    // next state and output logic
    always_ff@(posedge clk_en)
        case(s)
            0: begin  // and level 1
    
                frame <= {
                    8'b1000_0010,
                    8'b1111_1110,
                    8'b1000_0000,
                    8'b0011_1000,
                    8'b0100_0000,
                    8'b1000_0000,
                    8'b0100_0000,
                    8'b0011_1000,
                    8'b1000_0010,
                    8'b1111_1110,
                    8'b1000_0000,
                    8'b0000_0000,
                    one
                };
    
                shift <= 0;
                level <= 1;
    
                if(start)
                    nextS <= 35;
                else
                    if(up)
                        nextS <= 15;
                    else
                        nextS <= 0;
            end
            15: begin
                frame[3] <= frame[3] << 1;
                frame[2] <= frame[2] << 1;
                frame[1] <= frame[1] << 1;
                frame[0] <= frame[0] << 1;
                
                nextS <= 16;
                
            end
            16: begin
                frame[3][0] <= two[3][7 - shift];
                frame[2][0] <= two[2][7 - shift];
                frame[1][0] <= two[1][7 - shift];
                frame[0][0] <= two[0][7 - shift];
                if(shift < 7)
                    nextS <= 17;
                else
                    nextS <= 18;
            end
            17: begin
                shift <= shift + 1;
                nextS <= 15;
            end
            // level 2
            18: begin
                frame <= {
                    8'b1000_0010,
                    8'b1111_1110,
                    8'b1000_0000,
                    8'b0011_1000,
                    8'b0100_0000,
                    8'b1000_0000,
                    8'b0100_0000,
                    8'b0011_1000,
                    8'b1000_0010,
                    8'b1111_1110,
                    8'b1000_0000,
                    8'b0000_0000,
                    two
                };
    
                shift <= 0;
                level <= 2;
    
                if(start)
                    nextS <= 35;
                else
                    if(up)
                        nextS <= 19;
                    else if(down)
                        nextS <= 26;
                    else
                        nextS <= 18;
            end
            19: begin
                frame[3] <= frame[3] << 1;
                frame[2] <= frame[2] << 1;
                frame[1] <= frame[1] << 1;
                frame[0] <= frame[0] << 1;
                
                nextS <= 20;
            end
            20: begin
                frame[3][0] <= three[3][7 - shift];
                frame[2][0] <= three[2][7 - shift];
                frame[1][0] <= three[1][7 - shift];
                frame[0][0] <= three[0][7 - shift];
                if(shift < 7)
                    nextS <= 21;
                else
                    nextS <= 22;
            end
            21: begin
                shift <= shift + 1;
                nextS <= 19;
            end
    
            // level 3
            22: begin
                frame <= {
                    8'b1000_0010,
                    8'b1111_1110,
                    8'b1000_0000,
                    8'b0011_1000,
                    8'b0100_0000,
                    8'b1000_0000,
                    8'b0100_0000,
                    8'b0011_1000,
                    8'b1000_0010,
                    8'b1111_1110,
                    8'b1000_0000,
                    8'b0000_0000,
                    three
                };
    
                shift <= 0;
                level <= 3;
    
                if(start)
                    nextS <= 35;
                else
                    if(down)
                        nextS <= 23;
                    else   
                        nextS <= 22;
            end
            // going from level 3 to level 2
            23: begin
                frame[3] <= frame[3] >> 1;
                frame[2] <= frame[2] >> 1;
                frame[1] <= frame[1] >> 1;
                frame[0] <= frame[0] >> 1;
                
                nextS <= 24;
            end
            24: begin
                frame[3][7] <= two[3][shift];
                frame[2][7] <= two[2][shift];
                frame[1][7] <= two[1][shift];
                frame[0][7] <= two[0][shift];
                
                if(shift < 7)
                    nextS <= 25;
                else
                    nextS <= 18;
            end
            25: begin
                shift <= shift + 1;
                nextS <= 23;
            end
    
            // going from level 2 to level 1
            26: begin
                frame[3] <= frame[3] >> 1;
                frame[2] <= frame[2] >> 1;
                frame[1] <= frame[1] >> 1;
                frame[0] <= frame[0] >> 1;
                
                nextS <= 27;
            end
            27: begin
                frame[3][7] <= one[3][shift];
                frame[2][7] <= one[2][shift];
                frame[1][7] <= one[1][shift];
                frame[0][7] <= one[0][shift];
                
                if(shift < 7)
                    nextS <= 28;
                else
                    nextS <= 0;
            end
            28: begin
                shift <= shift + 1;
                nextS <= 26;
            end
    
            // starting the game
            35: begin
                case(level)
                    1: frame <= frame1;
                    2: frame <= frame2;
                    3: frame <= frame3;
                endcase
    
                ballRow <= 7;
                ballCol <= 15;
                nextS <= 13;
            end
    
            13: begin
                case(up)
                    1: nextS <= 1;
                    0: case(down)
                        1: nextS <= 4;
                        0: case(right)
                            1: nextS <= 7;
                            0: case(left)
                                1: nextS <= 10;
                                0: nextS <= 13;
                            endcase
                        endcase
                    endcase
                endcase
            end
    
            //-- States for up button --//
            1: begin
                frame[ballCol][ballRow] <= 1'b0;
                nextS <= 2;
            end
            2: begin
                ballRow <= ballRow - 1;
                nextS <= 3;
            end
            3: begin
                if(frame[ballCol][ballRow] == 1'b1) // means the game is lost
                    nextS <= 6;
                else if(ballCol == 0)  // means the game is won
                    nextS <= 12;
                else begin
                    frame[ballCol][ballRow] <= 1'b1;
                    nextS <= 13;
                end
            end
    
            //-- States for down button --//
            4: begin
                frame[ballCol][ballRow] <= 1'b0;
                nextS <= 5;
            end
            5: begin
                ballRow <= ballRow + 1;
                nextS <= 3;
            end
    
            //-- States for right button --//
            7: begin
                if(ballCol > 0) begin
                    frame[ballCol][ballRow] <= 1'b0;
                    nextS <= 8;
                end
                else
                    nextS <= 13;
            end
            8: begin
                ballCol <= ballCol - 1;
                nextS <= 3;
            end
            
            //-- States for left button --//
            10: begin
                if(ballCol < 15) begin
                    frame[ballCol][ballRow] <= 1'b0;
                    nextS <= 11;
                end
                else
                    nextS <= 13;
            end
            11: begin
                ballCol <= ballCol + 1;
                nextS <= 3;
            end
    
            //-- States for game over
            6: begin
                loading <= 0;
                frame <= {
                    8'b0000_0000,
                    8'b0000_0000,
                    8'b0000_0000,
                    8'b0000_0000,
                    8'b1000_0001,
                    8'b0100_0010,
                    8'b0010_0100,
                    8'b0001_1000,
                    8'b0001_1000,
                    8'b0010_0100,
                    8'b0100_0010,
                    8'b1000_0001,
                    8'b0000_0000,
                    8'b0000_0000,
                    8'b0000_0000,
                    8'b0000_0000
                };
    
                if(start)
                    nextS <= 40; // restarting the game
                else if(pass)
                    nextS <= 9;
            end
            9: begin
                frame <= {
                    8'b1111_1111,
                    8'b1111_1111,
                    8'b1111_1111,
                    8'b1111_1111,
                    8'b0111_1110,
                    8'b1011_1101,
                    8'b1101_1011,
                    8'b1110_0111,
                    8'b1110_0111,
                    8'b1101_1011,
                    8'b1011_1101,
                    8'b0111_1110,
                    8'b1111_1111,
                    8'b1111_1111,
                    8'b1111_1111,
                    8'b1111_1111
                };
    
                if(start)
                    nextS <= 40; // restarting the game
                else if(pass)
                    nextS <= 6;
            end
    
            //-- States for winning
            12: begin
                loading <= 0;
                frame <= {
                    8'b0011_1110,
                    8'b0100_0000,
                    8'b0011_1100,
                    8'b0100_0000,
                    8'b0011_1110,
                    8'b00000_000,
                    8'b0011_1000,
                    8'b0100_0100,
                    8'b0100_0100,
                    8'b0011_1000,
                    8'b0000_0000,
                    8'b0111_1100,
                    8'b0000_1000,
                    8'b0001_0000,
                    8'b0010_0000,
                    8'b0111_1100
                };
    
                if(start)
                    nextS <= 40; // restarting the game
                else  if(pass)
                    nextS <= 14;
            end
            14: begin
                frame <= {
                    8'b1100_0001,
                    8'b1011_1111,
                    8'b1100_0011,
                    8'b1011_1111,
                    8'b1100_0001,
                    8'b1111_1111,
                    8'b1100_0111,
                    8'b1011_1011,
                    8'b1011_1011,
                    8'b1100_0111,
                    8'b1111_1111,
                    8'b1000_0011,
                    8'b1111_0111,
                    8'b1110_1111,
                    8'b1101_1111,
                    8'b1000_0011
                };
    
                if(start)
                    nextS <= 40; // restarting the game
                else if(pass)
                    nextS <= 12;
            end
            40: begin
                if(loading == 8)
                    nextS <= 0;
                else
                    nextS <= 41;
            end
            41: begin
                loading <= loading + 1;
                nextS <= 40;
            end
    
        endcase
        
        // 7 segment display
            logic [3:0] digit;
            assign digit = mode ? timer : level;
            logic [6:0] leds;
            always_comb begin
                leds = 7'b1111111;
                case(digit)
                   4'd0 : leds = 7'b1000000;
                   4'd1 : leds = 7'b1111001;
                   4'd2 : leds = 7'b0100100;
                   4'd3 : leds = 7'b0110000;
                   4'd4 : leds = 7'b0011001;
                   4'd5 : leds = 7'b0010010;
                   4'd6 : leds = 7'b0000010;
                   4'd7 : leds = 7'b1111000;
                   4'd8 : leds = 7'b0000000;
                   4'd9 : leds = 7'b0010000; 
                   default: leds = 7'b0111111;
                endcase
            end
            assign an = 4'b1110; 
            assign {g, f, e, d, c, b, a} = leds; 
            assign dp = 1'b1;
    endmodule
