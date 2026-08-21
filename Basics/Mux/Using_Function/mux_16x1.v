module mux_16x1(
  input [15:0]in,
  input [3:0]sel,
  output reg o
);
reg [3:0]hold;
    function mux_4x1;
        input [3:0]in;
        input [1:0]sel;
        case (sel)
            2'b00 : mux_4x1 = in[0]; 
            2'b01 : mux_4x1 = in[1]; 
            2'b10 : mux_4x1 = in[2]; 
            2'b11 : mux_4x1 = in[3]; 
            default: mux_4x1 = 1'b0;
        endcase
    endfunction
    always @(*) begin
        hold[0] = mux_4x1(in[3:0],sel[1:0]);
        hold[1] = mux_4x1(in[7:4],sel[1:0]);
        hold[2] = mux_4x1(in[11:8],sel[1:0]);
        hold[3] = mux_4x1(in[15:12],sel[1:0]);
        o = mux_4x1(hold[3:0],sel[3:2]);
    end
endmodule
