module encoder_8x3_tb ();
 reg [7:0]in;
 reg En;
 wire [2:0]o;

 encoder_8x3 dut(in,En,o);
 initial begin
    $dumpfile("enco.vcd");
    $dumpvars(0,encoder_8x3_tb);
   for (integer i=0;i<2;i=i+1) begin
     En = i;
     if(En)begin
        in = 8'b10000000;  #10;
        in = 8'b01000000; #10;
        in = 8'b00100000; #10;
        in = 8'b00010000; #10;
        in = 8'b00001000;  #10;
        in = 8'b00000100;  #10;
        in = 8'b00000010; #10;
        in = 8'b00000001; #10;
     end
   end
   $display("Test done");
   #10 $finish;
 end   
endmodule