`timescale 1ns / 1ps
module tb_Traffic();
    reg clk, reset;
    wire Red,Green,Yellow;

    Traffic dut (.clk(clk),.reset(reset),.Red(Red),.Green(Green),.Yellow(Yellow));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
       reset = 1; #10;
        reset = 0; 
        $dumpfile ("traffic.vcd");
        $dumpvars (0,tb_Traffic);
        $monitor("R=%b Y=%b G=%b",  Red, Yellow, Green);
        #700 $finish;
    end
endmodule
