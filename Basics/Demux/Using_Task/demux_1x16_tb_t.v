module demux_tb_1x16_t();
    reg in;
    reg [3:0]sel;
    wire [15:0]o;

  demux_1x16_t dut(in,sel,o);
   initial begin
    $dumpfile("demux.vcd");
    $dumpvars(0,demux_tb_1x16_t);
        in = 1;    
     for (integer j=0;j<16;j=j+1) begin
            sel = j; #10;
       $display("Input: in=%b, sel=%b -> o=%b" , in ,sel ,o);
        end
       #10; in = 0;
     for (integer k=0;k<16;k=k+1) begin
            sel = k; #10;
        end
   $display("Test done");
   #10 $finish;
   end
endmodule