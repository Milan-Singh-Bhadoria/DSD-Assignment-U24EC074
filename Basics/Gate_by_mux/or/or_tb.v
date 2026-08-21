module gate_or_tb ();
    reg a,b;
    wire o;
    gate_or dut(.a(a),.b(b),.o(o));
    initial begin
    $dumpfile("or.vcd");
    $dumpvars(0,gate_or_tb);
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