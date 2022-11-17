`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2022 01:01:30 PM
// Design Name: 
// Module Name: IPS_Test
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


module IPS_Test(
    input IPS0,
    input IPS1,
    output LED0,
    output LED1,
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
    output ENA,
    output ENB
    );
        reg clock25;
        reg [4:0] counter; //sets the period 11111+1=00000
        reg [4:0] widthA;
        reg [4:0] widthB;
        reg [28:0] ticker; //to hold a count of 50M
        reg [4:0] move;
        wire click;
        reg temp_PWMA;
        reg temp_PWMB;
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
        move = 0;
        IN1 = 0;
        IN2 = 0;
        IN3 = 0;
        IN4 = 0;
    end
    always@(posedge clock100)begin   
        COUNTER = COUNTER + 1;
        if(COUNTER > COUNT)
        begin
            clock25 = ~clock25;
            COUNTER = 11'd0;
        end
        if(reset)begin
            count<=0;
            end
        else begin
            count<=count+1;
            end
        if(reset)begin
            counter<=0;
            end
        else begin
            counter<=counter+1;
            end
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
            if(reset)
                ticker <= 0;
            else if(ticker == 90000000) //reset after 1 second
                ticker <= 0;
            else
                ticker <= ticker + 1;
            if(SW0 == 1)begin
                if(move == 0)begin
                    widthA=11'd3000;
                    widthB=11'd3000;
                    IN1 = 0;
                    IN2 = 1;
                    IN3 = 0;
                    IN4 = 1;
                    if(IPS0 == 0 || IPS1 == 0)begin
                        move = 1;
                    end    
                end
                if(move == 1)begin
                    widthA=11'd3000;
                    widthB=11'd3000;
                    IN1 = 0;
                    IN2 = 1;
                    IN3 = 1;
                    IN4 = 0;
                end
            end
            else begin
                widthA=11'd0000;
                widthB=11'd0000;
            end
                
        end
    assign LED0 = IPS0;
    assign LED1 = IPS1;
endmodule
