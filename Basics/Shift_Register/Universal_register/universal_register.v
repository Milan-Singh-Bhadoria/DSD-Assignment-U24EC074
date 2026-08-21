`timescale 1ns / 1ps
module mux (
   input [3:0]n,
   input[1:0]s,
   output reg o
);
always @(*) begin
     case (s)
        2'b00: o =  n[0];
        2'b01: o =  n[1];
        2'b10: o =  n[2];
        2'b11: o =  n[3];
        default: o = 1'bx;
    endcase
end
endmodule
 
module flip_flop(
    input clk,reset,D,
    output reg Q
);
  always@(posedge clk)begin
      if(reset) Q <= 0;
      else Q <= D;
  end
endmodule

module Universal_register(
    input clk,reset,
    input D_right,D_left,
    input [1:0]sel,
    input [3:0]D_parallel,
    output [3:0]Q_parallel,
    output Q_series
);
  wire q0,q1,q2,q3;
  wire d0,d1,d2,d3;
      mux m1({D_parallel[3],q2,D_right,q3}, sel, d3);
      mux m2({D_parallel[2],q1,q3,q2}, sel, d2);
      mux m3({D_parallel[1],q0,q2,q1}, sel, d1);
      mux m4({D_parallel[0],D_left,q1,q0}, sel, d0); 
      
      flip_flop f1(clk,reset,d3,q3);
      flip_flop f2(clk,reset,d2,q2);
      flip_flop f3(clk,reset,d1,q1);
      flip_flop f4(clk,reset,d0,q0);
      assign Q_parallel = {q3,q2,q1,q0};
      assign Q_series = q0;
endmodule
