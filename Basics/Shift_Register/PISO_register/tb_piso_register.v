`timescale 1ns / 1ps
module tb_PISO_register();
    reg clk;
    reg [3:0]D;
    reg load;
    wire Q;
    
  PISO_register dut(clk,D,load,Q);
    
    always #5 clk = ~clk;
    initial begin
    $dumpfile("piso.vcd");
    $dumpvars(0, tb_PISO_register);
    clk = 0;
    load = 1;
    D = 4'd11; 
    #10;
    load = 0;
    #30 $finish;
    end
endmodule
