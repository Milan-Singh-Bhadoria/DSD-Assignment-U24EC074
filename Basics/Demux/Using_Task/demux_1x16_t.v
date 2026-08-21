module demux_1x16 (
   input in,
   input [3:0]sel,
   output reg [15:0]o
);
  
    task demux_1x4;
        input in;
        input [1:0]sel;
        output [3:0]out;
        begin
          out = 4'b0000;
        case (sel)
          2'b00 : out[0] = in;
          2'b01 : out[1] = in;
          2'b10 : out[2] = in;
          2'b11 : out[3] = in;
          default: out = 4'b0000;
        endcase   
        end
    endtask
  
    reg [3:0]hold;
    always @(*) begin
          demux_1x4(in,sel[3:2],hold[3:0]);
		
        demux_1x4(hold[0],sel[1:0],o[3:0]);
        demux_1x4(hold[1],sel[1:0],o[7:4] );
        demux_1x4(hold[2],sel[1:0],o[11:8]);
        demux_1x4(hold[3],sel[1:0],o[15:12]);
    end
endmodule