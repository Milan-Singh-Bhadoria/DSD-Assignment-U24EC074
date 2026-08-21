module gray(
    input [7:0] in,
    output reg [7:0]o
);
    always @(*) begin
    o[7] = in[7];
        for (integer i=6;i>-1;i=i-1) begin
            o[i] = in[i+1]^in[i];
        end
    end
endmodule