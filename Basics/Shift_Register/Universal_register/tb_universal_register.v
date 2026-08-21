`timescale 1ns / 1ps
module tb_Universal_register();
    reg clk,reset;
    reg D_right,D_left;
    reg [1:0]sel;
    reg [3:0]D_parallel;
    wire [3:0]Q_parallel;
    wire Q_series;
    
    Universal_register dut(clk,reset,D_right,D_left,sel,D_parallel,Q_parallel,Q_series);
    
    always #5 clk = ~clk;
    initial begin
    $dumpfile("uni_reg.vcd");
    $dumpvars(0, tb_Universal_register);
    clk = 0;
    D_right = 0;
    D_left = 0;
    D_parallel = 0;
    sel = 0;    // Hold
    reset = 1;#10;
    reset = 0;
    sel = 1;    // Shift Right
    D_right = 1;
    #10 D_right = 0;
    #10 D_right = 0;
    #10 D_right = 1;
    #40 sel = 2;   // Shift Left
     D_left = 1;
    #10 D_left = 0;
    #10 D_left = 0;
    #10 D_left = 1;
    #10 sel = 3;    // Parallel Load
    D_parallel = 4'd12;
    
    #50 $finish;
    end
endmodule
