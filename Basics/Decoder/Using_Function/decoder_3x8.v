module deco_3x8(
   input x,y,z,
   output reg [7:0]o
);
function [3:0]decoder_2x4;
input En,x,y;
 begin
    if(En)begin
    decoder_2x4[0] =  ~x & ~y;
    decoder_2x4[1] =  ~x & y;
    decoder_2x4[2] = x & ~y;
    decoder_2x4[3] = x & y;
    end
    else begin
        decoder_2x4 = 4'b000;
    end
   end    
endfunction
always @(*) begin
   o[7:4] = decoder_2x4(x,y,z);
  o[3:0] = decoder_2x4(~x,y,z);
   
end
endmodule