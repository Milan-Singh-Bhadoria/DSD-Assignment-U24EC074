`timescale 1ns / 1ps
module tb_Up_counter_3bit();
    reg clk, reset;
    wire [2:0] Q;

    Up_counter_3bit dut (.clk(clk), .reset(reset), .Q(Q));

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
    end

    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, tb_Up_counter_3bit);
        $monitor("clk = %b | reset = %b | Q = %b", clk, reset, Q);
        #90;
        $finish;
    end
endmodule
