module pri_enco_tb ();
 reg [7:0]d;
 reg En;
 wire [2:0]o;
 wire v;

 pri_enco dut(d,En,o,v);
 initial begin
    $dumpfile("Pri_enco.vcd");
    $dumpvars(0,pri_enco_tb);
   for (integer i=0;i<2;i=i+1) begin
     En = i;
     if(En==0)begin
        d = 8'bxxxxxxxx;
        #10;
     end
     if(En==1)begin
        d = 8'b10000000;
        #10;
        d = 8'b01000000;
        #10;
        d = 8'b00100000;
        #10;
        d = 8'b00010000;
        #10;
        d = 8'b00001000;
        #10;
        d = 8'b00000100;
        #10;
        d = 8'b00000010;
        #10;
        d = 8'b00000001;
        #10;
        d = 8'b00000000; 
        #10;
     end
   end
   $display("Test done");
   #10 $finish;
 end   
endmodule