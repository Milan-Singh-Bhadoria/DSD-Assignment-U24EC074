module deco_tb ();
  reg x,y,z; 
  wire [7:0]o;

  deco_3x8 dut(x,y,z,o);
  initial begin
    $dumpfile("deco.vcd");
    $dumpvars(0, deco_tb);
     for(integer i=0;i<8;i=i+1)begin
      {x,y,z} = i;

      $display("Input: x=%b, y=%b, z=%b -> Output: o=%b", x, y, z, o);
      #10;
    end
    $display("Test done");
    #10 $finish;
  end
endmodule