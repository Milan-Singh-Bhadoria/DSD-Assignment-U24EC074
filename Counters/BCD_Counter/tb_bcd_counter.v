`timescale 1ns / 1ps

module tb_bcd_counter();
    reg clk, reset;
    wire [3:0] Q;

    bcd_counter dut(.clk(clk), .reset(reset), .Q(Q));
    
    initial begin
        clk = 0;
        reset = 1;
        #10;
        reset = 0;
    end
 always #5 clk = ~clk;
    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, tb_bcd_counter);
        $monitor("clk = %b | reset = %b | Q = %b", clk, reset, Q);
        #150;
        $finish;
    end
endmodule
