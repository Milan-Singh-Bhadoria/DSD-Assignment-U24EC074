module demux_1xN_tb();
    reg d,En;
  reg [1:0]sel;
    wire [3:0]o;

  demux_1xN dut(d,En,sel,o);
   initial begin
    $dumpfile("demux.vcd");
    $dumpvars(0,demux_1xN_tb);
   for (integer j=0;j<2;j=j+1) begin
    En = j;
     if(En)begin
        d = 1;
        for (integer l=0;l<4;l=l+1) begin
            sel = l; #10;
        end
       d = 0;
        for (integer k=0;k<4;k=k+1) begin
            sel = k; #10;
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