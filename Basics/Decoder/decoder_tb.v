module deco_tb ();
  reg x,y,z,En; 
  wire [7:0]o;

  deco dut(x,y,z,En,o);
  initial begin
    $dumpfile("deco.vcd");
    $dumpvars(0, deco_tb);
    
    for(integer j=0;j<2;j=j+1)begin
        En = j;
      if(En==0) begin
      #10;
     end
    else begin
    for(integer i=0;i<8;i=i+1)begin
      {x,y,z} = i;
      #10;

     $display("Input: x=%b, y=%b, z=%b En=%b -> Output: o=%b", x, y, z,En, o);
    end
    end
    end
    $display("Test done");
    #10 $finish;
  end
endmodule
