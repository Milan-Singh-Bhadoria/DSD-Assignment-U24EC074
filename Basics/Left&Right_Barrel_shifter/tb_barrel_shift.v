`timescale 1ns / 1ps
module tb_Right_barrel();
  reg [31:0] data_in;
     reg  direction;
     reg [4:0]shift;
     wire [31:0]data_out;
  
  Right_barrel dut(.data_in(data_in), .direction(direction), .shift(shift), .data_out(data_out));
  
  initial begin
    $dumpfile("barrel.vcd");
    $dumpvars(0, tb_Right_barrel);
    
    direction = 1;  //right -> direction = 1  and left -> direction = 0
    shift = 10;
    data_in = 32'd3546321837;
    #10;
    direction = 0;
    #10;
    shift = 16;
    direction = 1;
    #10;
    direction = 0;
   #20 $finish;
  end
endmodule
