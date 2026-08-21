module mux_Nx1_tb();
  reg [3:0]d;
  reg En;
  reg [1:0]sel;
    wire o;

  mux_Nx1 dut(d,En,sel,o);
   initial begin
    $dumpfile("mux.vcd");
     $dumpvars(0,mux_Nx1_tb);
   for (integer j=0;j<2;j=j+1) begin
    En = j;
     if(En)begin
        d = 9;
        for (integer l=0;l<4;l=l+1) begin
            sel = l; #10;
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