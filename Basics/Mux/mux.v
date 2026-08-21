module mux (
   input [7:0]n,
   input[2:0]s,
   input En,
   output reg o
);
always @(*) begin
   if (En==1) begin
     case (s)
        3'b000: o =  n[0];
        3'b001: o =  n[1];
        3'b010: o =  n[2];
        3'b011: o =  n[3];
        3'b100: o =  n[4];
        3'b101: o =  n[5];
        3'b110: o =  n[6];
        3'b111: o =  n[7];
        default: o = 1'bx;
    endcase
   end
   else begin
    o = 1'bx;
   end
end
endmodule