`timescale 1ns / 1ps
module tb_SIPO_register();
   reg clk,Din;
   wire [3:0]Q;
   
   SIPO_register dut(clk,Din,Q);
   
   reg [3:0]bitstream = 4'd14;
   
   always #5 clk = ~clk;
   integer i;
   initial begin
     $dumpfile ("sipo.vcd");
     $dumpvars (0, tb_SIPO_register);
   clk = 0;
    Din = 0;
    for(i=0;i<4;i=i+1)begin
       Din = bitstream[i];
       #10;
    end
   #10 $finish; 
   end
endmodule
