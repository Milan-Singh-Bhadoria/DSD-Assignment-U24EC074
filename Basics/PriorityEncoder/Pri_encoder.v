module pri_enco (
   input [7:0]d,
   input En,
   output reg [2:0]o,
   output reg v
);
    always @(*) begin
    if(En==1)begin
        if(d[7])begin
            o = 3'b000; v = 1'b1;
        end
        else if(d[6])begin
            o = 3'b001; v = 1'b1;
        end
        else if(d[5])begin
            o = 3'b010; v = 1'b1;
        end
        else if(d[4])begin
            o = 3'b011; v = 1'b1;
        end
        else if(d[3])begin
            o = 3'b100; v = 1'b1;
        end
        else if(d[2])begin
            o = 3'b101; v = 1'b1;
        end
        else if(d[1])begin
            o = 3'b110; v = 1'b1;
        end
        else if(d[0])begin
            o = 3'b111; v = 1'b1;
        end
        else begin
            o = 3'bxxx ; v=0;
        end
    end
    if (En==0) begin
        v = 1'b0;
        o = 3'bxxx;
    end
end
endmodule