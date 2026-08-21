`timescale 1ns / 1ps
module Right_barrel(
     input [31:0] data_in,
     input direction,
     input [4:0]shift,
     output reg[31:0]data_out
    );
    reg [4:0]reverse_shift ;
    reg [31:0] data_out1,data_out2;
    always @(*)begin
    reverse_shift = 32 - shift;
    if(direction==1)begin
      data_out1 = data_in >> shift;
      data_out2 = data_in << reverse_shift;
    
     data_out = data_out1 | data_out2;
   end
   else begin
    data_out1 = data_in << shift; 
    data_out2 = data_in >> reverse_shift;
   
    data_out = data_out1 | data_out2;
   end
  end
endmodule
