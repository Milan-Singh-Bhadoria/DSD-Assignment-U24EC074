module demux (
   input d,En,
   input [1:0]s,
   output reg [3:0]o
);
    always @(*) begin
        if (En==1) begin
            case (s)
                2'b00 : o[0] = d; 
                2'b01 : o[1] = d; 
                2'b10 : o[2] = d; 
                2'b11 : o[3] = d; 
                default: o = 4'bxxxx;
            endcase
        end
        else begin
            o = 4'bxxxx;
        end
    end
endmodule