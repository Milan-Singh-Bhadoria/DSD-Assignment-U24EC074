module demux_tb();
    reg d,En;
    reg [1:0]s;
    wire [3:0]o;

   demux dut(d,En,s,o);
   initial begin
    $dumpfile("demux.vcd");
    $dumpvars(0,demux_tb);
   for (integer i=0;i<2;i=i+1) begin
    En = i;
    if(En==1)begin
        d = 1;
        for (integer j=0;j<4;j=j+1) begin
            s = j; #10;
        end
       #10; d = 0;
        for (integer k=0;k<4;k=k+1) begin
            s = k; #10;
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