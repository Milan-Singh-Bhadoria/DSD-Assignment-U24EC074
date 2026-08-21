`timescale 1ns / 1ps
module tb_Lift();
   reg clk,reset;
   reg [1:0]in;
   wire [2:0]floor;
   
   Lift dut(clk,reset,in,floor); 
   
    initial begin
     forever #5 clk = ~clk;
     end
     
   initial begin
   $dumpfile("lift.vcd");
   $dumpvars(0, tb_Lift);
   clk = 0;
   in = 0;
   reset = 1;#5;
     reset = 0;
     in = 0;
     #10 in = 1;
     #10 in = 3;
     #10 in = 3;
     #25 in = 2;
     #10 in = 1;
     #10 in = 2;
     #20 in = 3;
     #10 in = 1;
     #17 in = 2;
     #23 in = 1;
     #10 in = 3;
     #25 in = 2;
     #10 in = 1;
     #20;
   $finish;
   end
endmodule
