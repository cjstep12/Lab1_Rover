`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2022 02:32:51 PM
// Design Name: 
// Module Name: PWM_Tutorial
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


module PWM_Tutorial(
    input SW0,
    input SW1,
    input SW2,
    input SW3,
    input SW4,
    input SW5,
    input SW6,
    input SW7,
    input clock100,
    input button,
//    input [1:0] speed,
    input reset,
    input SENSA,
    input SENSB,
    output IN1,
    output IN2,
    output IN3,
    output IN4,
    output LED0,
    output LED1,
    output LED2,
    output LED3,
    output LED4,
    output LED5,
    output LED6,
    output LED7,
    output LED8,
    output LED9,
    output ENA,
    output ENB,
    output a, b, c, d, e, f, g, dp, //the individual LED output for the seven segment along with the digital point
    output [3:0] an   // the 4 bit enable signal
    );
        reg [3:0] in0, in1, in2, in3;  //the 4 inputs for each display
        reg clock25;
        reg [4:0] counter; //sets the period 11111+1=00000
        reg [4:0] widthA;
        reg [4:0] widthB;
        reg [28:0] ticker; //to hold a count of 50M
        wire click;
        reg controlA;
        reg controlB;
        reg temp_PWMA;
        reg temp_PWMB;
        reg [6:0]sseg; //the 7 bit register to hold the data to output
        reg [3:0]an_temp; //register for the 4 bit enable
        localparam N = 18;
        reg [N-1:0]count; //the 18 bit counter which allows us to multiplex at 1000Hz        
        reg sensbutton;
        reg[10:0] COUNTER;
    
        //parameter COUNT = 11'd2000;
        parameter COUNT = 11'd10;
    
    initial begin
        sensbutton = 1'b0;
        clock25 = 1'b0;
        COUNTER = 11'd0;
        widthA = 0;
        temp_PWMA = 0;
        widthB = 0;
        temp_PWMB = 0;
        in1 = 0;
        in2 = 0;
        in3 = 4;
        in0 = 4;
    end
    
    always@(posedge clock100)begin   
        COUNTER = COUNTER + 1;
        if(COUNTER > COUNT)
        begin
            clock25 = ~clock25;
            COUNTER = 11'd0;
        end
        if(reset)
            count<=0;
        else
            count<=count+1;
        if(reset)
            counter<=0;
        else
            counter<=counter+1;
    end
        always@(posedge clock25) begin
            if(button == 1)
            begin
                sensbutton=1'b0;  
            end
                
            if(counter<widthA)
                temp_PWMA<=1;
            else
                temp_PWMA<=0;
            if(counter<widthB)
                temp_PWMB<=1;
            else
                temp_PWMB<=0;
            if(controlA<1)
                temp_PWMA = 0;
            if(controlB<1)
                temp_PWMB = 0;
            if(reset)
                ticker <= 0;
            else if(ticker == 90000000) //reset after 1 second
                ticker <= 0;
            else
                ticker <= ticker + 1;
            if(SW0 == 1 && SW1 == 1)
                in0 = 4;
            else if(SW0 ==1)
                in0 = 5;
                else if(SW1 ==1)
                in0 = 6;
                    else
                        in0 = 4;
            if(SW4 == 1 && SW5 == 1)
                in3 = 4;
            else if(SW4 ==1)
                in3 = 5;
                else if(SW5 ==1)
                in3 = 6;
                    else
                        in3 = 4;
            if(SENSA==0 && sensbutton==0)
            begin
                sensbutton=1'b0;
                if(SW2==1 && SW3==1)begin
                    widthA=11'd3000;
                    in1 = 3;
                    end
                else
                    if(SW3==1)begin
                        widthA=11'd2000;
                        in1 = 2;
                        end
                    else
                        if(SW2==1)begin
                            widthA=11'd1000;
                            in1 = 1;
                            end
                        else
                        begin
                            widthA=11'd0000;
                            in1 = 0;
                            end
            end
            else if(SENSA == 1 || sensbutton == 1)
                begin
                    widthA=11'd0000;
                    sensbutton=1'b1;
                    in1 = 0;
                end
            if(SENSB==0 && sensbutton==0)
            begin              
                sensbutton=1'b0;
                if(SW6==1 && SW7==1)begin
                    widthB=11'd3000;
                    in2 = 3;
                    end
                else
                    if(SW7==1)
                    begin
                        widthB=11'd2000;
                        in2 = 2;
                        end
                    else
                        if(SW6==1)begin
                            widthB=11'd1000;
                            in2 = 1;
                            end
                        else
                        begin
                            widthB=11'd0000;
                            in2 = 0;
                            end
             end
             else if(SENSB == 1 || sensbutton == 1)
                begin
                    widthB=11'd0000;
                    in2 = 0;
                    sensbutton=1'b1;
                end
             end
         
   always@(*)begin
   
   case(count[N-1:N-2]) //using only the 2 MSB's of the counter 
   
   2'b00 :  //When the 2 MSB's are 00 enable the fourth display
    begin
     sseg = in0;
     an_temp = 4'b1110;
    end
   
   2'b01:  //When the 2 MSB's are 01 enable the third display
    begin
     sseg = in1;
     an_temp = 4'b1101;
    end
   
   2'b10:  //When the 2 MSB's are 10 enable the second display
    begin
     sseg = in2;
     an_temp = 4'b1011;
    end
    
   2'b11:  //When the 2 MSB's are 11 enable the first display
    begin
     sseg = in3;
     an_temp = 4'b0111;
    end
  endcase
  end
  
  assign an = an_temp;

  reg [6:0] sseg_temp; // 7 bit register to hold the binary value of each input given

always @ (*)
 begin
  case(sseg)
   4'd0 : sseg_temp = 7'b1000000; //to display 0 0
   4'd1 : sseg_temp = 7'b1111001; //to display 1 1
   4'd2 : sseg_temp = 7'b0100100; //to display 2 2
   4'd3 : sseg_temp = 7'b0110000; //to display 3 3
   4'd4 : sseg_temp = 7'b0010010; //to display 4 S
   4'd5 : sseg_temp = 7'b0000011; //to display 5 B
   4'd6 : sseg_temp = 7'b0001110; //to display 6 F
   4'd7 : sseg_temp = 7'b1111000; //to display 7
   4'd8 : sseg_temp = 7'b0000000; //to display 8
   4'd9 : sseg_temp = 7'b0010000; //to display 9
   default : sseg_temp = 7'b0111111; //dash
  endcase
 end
assign {g, f, e, d, c, b, a} = sseg_temp; //concatenate the outputs to the register, this is just a more neat way of doing this.
// I could have done in the case statement: 4'd0 : {g, f, e, d, c, b, a} = 7'b1000000; 
// its the same thing.. write however you like it

assign dp = 1'b1; //since the decimal point is not needed, all 4 of them are turned off
            
    assign LED0 = SW0;
    assign IN3 = SW0;
    assign IN4 = SW1;
    assign LED1 = SW1;
    assign LED2 = SW2;
    assign LED3 = SW3;
    assign LED4 = SW4;
    assign IN1 = SW4;
    assign IN2 = SW5;
    assign LED5 = SW5;
    assign LED6 = SW6;
    assign LED7 = SW7;
    assign LED8 = SENSA;
    assign LED9 = sensbutton;
    assign ENA = temp_PWMA;
    assign ENB = temp_PWMB;
    
endmodule