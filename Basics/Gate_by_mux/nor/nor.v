module nor_gate(
  input a,b,
  output reg o
);
    always @(*) begin
        case (b)
           1'b0 : o = ~a;
           1'b1 : o = 1'b0;
           endcase
        
    end
endmodule