`timescale 1ns / 1ps
module tb_PIPO_register();
   reg clk;
   reg [3:0]Din;
   wire [3:0]Q;
   
   PIPO_register dut(clk,Din,Q);

   always #5 clk = ~clk;

   initial begin
     $dumpfile ("pipo.vcd");
     $dumpvars (0, tb_PIPO_register);
     clk = 0;
    Din =  4'd14;
    
   #40 $finish; 
   end
endmodule
