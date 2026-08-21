module deco_tb_t ();
  reg a,x,y; 
  wire [7:0]o;

  deco_3x8_t dut(a,x,y,o);
  initial begin
    $dumpfile("deco.vcd");
    $dumpvars(0, deco_tb_t);
     for(integer i=0;i<8;i=i+1)begin
       {a,x,y} = i;

       $display("Input: a=%b, x=%b, y=%b -> Output: o=%b", a ,x, y, o);
      #10;
    end
    $display("Test done");
    #10 $finish;
  end
endmodule