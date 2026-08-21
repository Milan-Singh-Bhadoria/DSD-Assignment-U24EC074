module encoder_8x3 (
    input [7:0] in, 
    input En,     
    output [2:0] o     
);
function [2:0] encoder;
    input [7:0] in;
    input En;
    begin
        if(En) begin
        case (in)
            8'b00000001: encoder = 3'b000;
            8'b00000010: encoder = 3'b001;
            8'b00000100: encoder = 3'b010;
            8'b00001000: encoder = 3'b011;
            8'b00010000: encoder = 3'b100;
            8'b00100000: encoder = 3'b101;
            8'b01000000: encoder = 3'b110;
            8'b10000000: encoder = 3'b111;
            default: encoder = 3'b000;  
        endcase
    end
end
endfunction
assign o = encoder(in,En);
endmodule