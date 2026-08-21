module nand_tb ();
    reg a,b;
    wire o;
    nand_gate dut(.a(a),.b(b),.o(o));
    initial begin
    $dumpfile("nand.vcd");
    $dumpvars(0,nand_tb);
      for(integer i=0;i<2;i=i+1)begin
        for (integer j=0;j<2;j=j+1) begin
            a = i; 
            b = j; #10;
        end
    end
    $display("Test done");
    #10 $finish;
    end
endmodule