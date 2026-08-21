`timescale 1ns / 1ps
module tb_SISO_register();
   reg clk,Din;
   wire Q;
   
   SISO_register dut(clk,Din,Q);
   
   reg [3:0]bitstream = 4'd14;
   
   always #5 clk = ~clk;
   integer i;
   initial begin
   $dumpfile ("siso.vcd");
   $dumpvars (0, tb_SISO_register);
   clk = 0;
    Din = 0;
    for(i=0;i<4;i=i+1)begin
       Din = bitstream[i];
       #10;
    end
   #40 $finish; 
   end
endmodule
