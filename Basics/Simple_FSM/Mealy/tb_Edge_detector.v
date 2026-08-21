`timescale 1ns / 1ps
module tb_edge_detect();
  reg clk,x;
  wire y;

  edge_detect dut(clk,x, y);

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    x = 0; #6;
    x = 1; #10;
    x = 0; #7;
    x = 1; #9;
    x = 0; #9;
    x = 1; #5;
    x = 0; #9;  
  end

  initial begin
    $dumpfile("edge.vcd");
    $dumpvars(0, tb_edge_detect);
    $monitor("x=%b | y=%b | clk=%b",  x, y, clk);
    #70;
    $finish;
  end
endmodule
