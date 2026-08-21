module gate_and(
  input a,b,
  output reg o
);
    always @(*) begin
        case (b)
           1'b1 : o = a;
           1'b0 : o = b;
           endcase
        
    end
endmodule