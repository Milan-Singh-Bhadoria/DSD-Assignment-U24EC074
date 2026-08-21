module mux_16x1_tb_t ();
   reg [15:0]in ;
   reg [3:0]sel;
   wire o;
mux_16x1_t dut(in,sel,o);
initial begin
    $dumpfile("mux.vcd");
    $dumpvars(0,mux_16x1_tb_t);  
        in = 43160;

        for (integer j=0;j<16;j=j+1) begin
        sel = j; #10;
        $display("Input: in=%b , sel=%b -> o=%b" , in,sel,o);
        end
   $display("Test done");
   #10 $finish;  
   end
endmodule