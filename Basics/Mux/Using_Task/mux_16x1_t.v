module mux_16x1_t(
  input [15:0]in,
  input [3:0]sel,
  output reg o
);
   reg [3:0]temp;
    task mux_4x1;
        input [3:0]in;
        input [1:0]sel;
        output reg hold;

        case (sel)
            2'b00 : hold = in[0]; 
            2'b01 : hold = in[1]; 
            2'b10 : hold = in[2]; 
            2'b11 : hold = in[3]; 
            default: hold = 1'b0;
        endcase
    endtask
    always @(*) begin
     mux_4x1(in[3:0],sel[1:0],temp[0]);
     mux_4x1(in[7:4],sel[1:0],temp[1]);
     mux_4x1(in[11:8],sel[1:0],temp[2]);
     mux_4x1(in[15:12],sel[1:0],temp[3]);
    
     mux_4x1(temp[3:0],sel[3:2],o);
    end
endmodule