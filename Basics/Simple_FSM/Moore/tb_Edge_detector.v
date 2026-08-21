`timescale 1ns / 1ps
module tb_edge_detect();
  reg clk,reset,x;
  wire y;

  edge_detect dut(clk,reset,x, y);

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;#1;
    x = 1; #1;  
    reset = 0;
    x = 1; #10; 
     x = 0; #10; 
      x = 1; #10; 
      x = 0; #10; 
      x = 1;#10;
      x = 1;#10;
      x = 0;
  end

  initial begin
    $dumpfile("edge.vcd");
    $dumpvars(0, tb_edge_detect);
    $monitor("x=%b | y=%b | clk=%b",  x, y, clk);
    #100;
    $finish;
  end
endmodule
