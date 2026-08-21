module mux_tb ();
   reg [7:0]n ;
   reg [2:0]s;
   reg En;
   wire o;
mux dut(n,s,En,o);
initial begin
    $dumpfile("mux.vcd");
    $dumpvars(0,mux_tb);
   for (integer i=0;i<2;i=i+1 ) begin
    En = i;
    if (En==1) begin  
        for (integer j=0;j<8;j=j+1) begin
        s = j; #10;
        n = 110; #10;
        end
    end
    else begin
       #10;
    end
   end
   $display("Test done");
   #10 $finish;
end   
endmodule