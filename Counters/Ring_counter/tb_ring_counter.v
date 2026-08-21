`timescale 1ns / 1ps
module tb_ring_counter();
    reg clk, reset, preset;
    wire [3:0] Q;

    Ring_counter dut (.clk(clk), .reset(reset), .preset(preset), .Q(Q));
    
    initial begin

        reset = 1;
        preset = 1;
        #10;
        clk = 0;
        preset = 0;
        reset = 0;
    end
 always #5 clk = ~clk;
    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, tb_ring_counter);
        $monitor("clk = %b | reset = %b | Q = %b", clk, reset, Q);
        #80;
        $finish;
    end
endmodule
