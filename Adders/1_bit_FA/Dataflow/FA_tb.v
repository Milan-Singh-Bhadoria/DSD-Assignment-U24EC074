`timescale 1ns/1ps
module fa_tb;
reg a,b,cin;
wire s,cout;

fa uut(a,b,cin,s,cout);

initial begin
$dumpfile("fa.vcd");
$dumpvars(0,fa_tb);

    a=0;b=0;cin=0;
    #10 a=0;b=0;cin=1;
    #10 a=0;b=1;cin=0;
    #10 a=0;b=1;cin=1;
    #10 a=1;b=0;cin=0;
    #10 a=1;b=0;cin=1;
    #10 a=1;b=1;cin=0;
    #10 a=1;b=1;cin=1;
    $display("done");
    #10 $finish;
end
endmodule
