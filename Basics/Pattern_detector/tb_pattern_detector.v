`timescale 1ns / 1ps
module tb_Sequence_detector();
  reg clk,x;
  wire y;

  Sequence_detector dut(clk,x, y);
  reg [31:0]bitstream = 32'b01101001110100011011110000101110;
  always #5 clk = ~clk;

  initial begin
    clk = 0;
   for(integer i=31;i>=0;i=i-1)begin
     x = bitstream[i];
     #10;
   end
    $dumpfile("edge.vcd");
    $dumpvars(0, tb_Sequence_detector);
    $monitor("x=%b | y=%b | clk=%b",  x, y, clk);
    #30;
    $finish;
  end
endmodule
