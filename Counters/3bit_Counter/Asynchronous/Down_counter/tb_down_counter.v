`timescale 1ns / 1ps
module tb_Down_asyn();
    reg clk, reset;
    wire [2:0] Q;

    Down_asyn dut (.clk(clk), .reset(reset), .Q(Q));
    
    initial begin
        clk = 0;
        reset = 1;
        #5;
        reset = 0;
    end
 always #5 clk = ~clk;
    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, tb_Down_asyn);
        $monitor("clk = %b | reset = %b | Q = %b", clk, reset, Q);
        #85;
        $finish;
    end
endmodule
