`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2022 02:47:06 PM
// Design Name: 
// Module Name: PWM_Tutorial_Testbench
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


module PWM_Tutorial_Testbench(
    );
    reg SW0;
    reg SW1;
    reg SW2;
    reg SW3;
    reg SW4;
    reg SW5;
    reg SW6;
    reg SW7;    
    reg clock;
//    reg [1:0] speed;
    reg reset;
    wire IN1;
    wire IN2;
    wire IN3;
    wire IN4;
    wire LED0;
    wire LED1;
    wire LED2;
    wire LED3;
    wire LED4;
    wire LED5;
    wire LED6;
    wire LED7;
    wire ENA;
    wire ENB;
    
    //Instantion
    PWM_Tutorial UUT(SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,clock,reset,IN1,IN2,IN3,IN4,LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7,ENA,ENB);
    
    initial begin
        clock = 0;
//        speed = 0;
        reset = 0;
        SW0 = 0;
        SW1 = 0;
        SW2 = 0;
        SW3 = 0;
        SW4 = 0;
        SW5 = 0;
        SW6 = 0;
        SW7 = 0;
        #10;
//        speed = 0;
        reset = 0;
        SW0 = 1;
        SW1 = 0;
        SW2 = 0;
        SW3 = 0;
        SW4 = 1;
        #200;
//        speed = 0;
        reset = 0;
        SW0 = 0;
        SW1 = 1;
        SW2 = 0;
        SW3 = 0;
        SW4 = 0;
        SW5 = 1;
        #200;
//        speed = 0;
        reset = 0;
        SW0 = 0;
        SW1 = 0;
        SW2 = 1;
        SW3 = 0;
        SW5 = 0;
        SW6 = 1;
        #200;
//        speed = 0;
        reset = 0;
        SW0 = 0;
        SW1 = 0;
        SW2 = 0;
        SW3 = 1;
        SW6 = 1;
        SW7 = 1;
        #200;
//        speed = 0;
        reset = 0;
        SW0 = 0;
        SW1 = 0;
        SW2 = 1;
        SW3 = 1;
        SW6 = 0;
        SW7 = 1;
        #150;
//        speed = 0;
        reset = 1;
        SW0 = 0;
        SW1 = 0;
        SW2 = 0;
        SW3 = 0;
        SW6 = 0;
        SW7 = 0;
        #10
//        speed = 0;
        reset = 0;
        SW0 = 0;
        SW1 = 0;
        SW2 = 0;
        SW3 = 0;
        
    end
    
    always begin
    #1 clock = ~clock;
    end
    
endmodule
