module enco_tb ();
 reg [7:0]a;
 reg En;
 wire [2:0]o;

 enco dut(a,En,o);
 initial begin
    $dumpfile("enco.vcd");
    $dumpvars(0,enco_tb);
   for (integer i=0;i<2;i=i+1) begin
     En = i;
     if(En==0)begin
        a = 8'bxxxxxxxx;
        #10;
     end
     if(En==1)begin
        a = 8'b10000000; #10;
        a = 8'b01000000; #10;
        a = 8'b00100000; #10;
        a = 8'b00010000; #10;
        a = 8'b00001000; #10;
        a = 8'b00000100; #10;
        a = 8'b00000010; #10;
        a = 8'b00000001; #10;
     end
   end
   $display("Test done");
   #10 $finish;
 end   
endmodule
