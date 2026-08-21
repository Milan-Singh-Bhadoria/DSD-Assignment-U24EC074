module deco_3x8_t(
   input a,x,y,
   output reg [7:0]o
);
task decoder_2x4;
input a,x,y;
output reg [3:0]out;
 begin
   if(a)begin
    out[0] =  ~x & ~y;
    out[1] =  ~x & y;
    out[2] = x & ~y;
    out[3] = x & y;
    end
    else begin
        out = 4'b000;
    end
   end    
endtask
always @(*) begin
  decoder_2x4(a,x,y,o[7:4]);
  decoder_2x4(~a,x,y,o[3:0]); 
end
endmodule