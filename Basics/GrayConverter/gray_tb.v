module gray_tb();
   reg [7:0]in;
   wire [7:0]o;
gray dut (in,o);

initial begin
$dumpfile("gray.vcd");
$dumpvars(0,gray_tb);
in = 8'b00000000; #10;
in = 8'b00000001; #10;
in = 8'b00000010; #10;
in = 8'b00000011; #10;
in = 8'b00000100; #10;
in = 8'b00000101; #10;
in = 8'b00000110; #10;
in = 8'b00000111; #10;

$display("Test done");
 $finish;
end
endmodule