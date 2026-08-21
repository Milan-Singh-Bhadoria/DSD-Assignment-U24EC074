module bcd_tb();
    reg [3:0]in ;
    wire [7:0]o ;
bcd dut(in,o);
initial begin
$dumpfile("bcd.vcd");
$dumpvars(0,bcd_tb);
   for (integer i=0;i<16;i=i+1) begin
       in = i; #10;
       $display("BCD of in = %b is : o = %b" ,in, o);
   end
$display("Test done");
#10 $finish;
end    
endmodule