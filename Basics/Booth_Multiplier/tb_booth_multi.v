`timescale 1ns / 1ps
module tb_Booth_multi();
  reg [7:0]m,q;
  wire [15:0]o;
  
  Booth_multi dut(m,q,o);
  
  initial begin
    $dumpfile ("booth.vcd");
    $dumpvars (0,tb_Booth_multi);
    m = 1; q = 1; #10;
    m = -3; q = 9; #10;
    m = 10; q = 12; #10;
    m = 17; q = -17; #10;
    m = 100; q = 126; #10;
    m = 127; q = 127; #10;
    #10 $finish;
  end
endmodule
