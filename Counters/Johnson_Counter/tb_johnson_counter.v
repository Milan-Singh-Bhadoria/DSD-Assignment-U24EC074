`timescale 1ns / 1ps
module tb_johnson_counter();
    reg clk, reset;
    wire [3:0] Q;

    Johnson_counter dut (.clk(clk), .reset(reset), .Q(Q));
    
    initial begin
        reset = 1;
        #10;
        clk = 0;
        reset = 0;
    end
 always #5 clk = ~clk;
    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, tb_johnson_counter);
        $monitor("clk = %b | reset = %b | Q = %b", clk, reset, Q);
        #160;
        $finish;
    end
endmodule
