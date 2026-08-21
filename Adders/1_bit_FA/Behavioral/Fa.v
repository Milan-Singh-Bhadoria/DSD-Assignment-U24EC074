module FA(
  input a,b,cin,
  output reg s,cout
);
    always @(*) begin
        s = (a ^ b ) ^ cin;
        cout = (a&b) | (a&cin) | (b&cin);
    end
endmodule
