module mux_Nx1 #(N=4) (
   input [N-1:0]d,En,
   input [$clog2(N)-1:0]sel,
   output reg o
);
always @(*) begin
  if(En)begin
        case (sel)
          2'b00 : o = d[0];
          2'b01 : o = d[1];
          2'b10 : o = d[2];
          2'b11 : o = d[3];
            default: o = 1'bx;
        endcase
    end
    else begin
        o = 1'bx;
    end
  end
endmodule