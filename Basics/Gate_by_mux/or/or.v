module gate_or(
  input a,b,
  output reg o
);
    always @(*) begin
        case (b)
           1'b1 : o = 1'b1;
           1'b0 : o = a;
           endcase
        
    end
endmodule