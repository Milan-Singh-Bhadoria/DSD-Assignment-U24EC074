module xun_tb;
  reg a,b;
  wire O;
  
  xun uut(a,b,O);
  initial begin
    $dumpfile("xun_tb.vcd");
    $dumpvars(0,xun_tb);
    
    a=0;b=0;
    #10a=0;b=1;
    #10a=1;b=0;
    #10a=1;b=1;
    $display("Done");
    #10 $finish;
      end 
    endmodule;