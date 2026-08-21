`timescale 1ns / 1ps
module tb_Bidirectional_register();
    reg clk;
    reg D;
    reg shift;
    wire Q;
    
  Bidirectional_register dut(clk,D,shift,Q);
    
    always #5 clk = ~clk;
    initial begin
        $dumpfile("bi_reg.vcd");
        $dumpvars(0, tb_Bidirectional_register);
    clk = 0;
    shift = 1;
     D = 1;
     #10 D = 1;
     #10 D = 0;
     #10 D = 1; 
    #20;
    shift = 0;
    D = 1;
     #10 D = 1;
     #10 D = 0;
     #10 D = 1;

    #50 $finish;
    end
endmodule
