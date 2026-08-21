`timescale 1ns / 1ps
module flip_flop(
    input D,
    input clk,reset,
    output reg Q
    );
    always@(posedge clk or posedge reset)begin
    if(reset)begin
    Q<=0;
    end
    else begin 
    Q <= D;
    end
   end
endmodule

module Down_asyn(
  input clk,reset,
  output [2:0]Q
); 
  wire q0,q1,q2;
 wire q0_bar,q1_bar,q2_bar;
    flip_flop t1(.D(q0_bar), .clk(clk), .reset(reset), .Q(q0));
    not n1(q0_bar,q0);
    flip_flop t2(.D(q1_bar), .clk(q0), .reset(reset), .Q(q1));
    not n2(q1_bar,q1);
    flip_flop t3(.D(q2_bar), .clk(q1), .reset(reset), .Q(q2));
    not n3(q2_bar,q2);

   not n4(Q[0],~q0);
   not n5(Q[1],~q1);
   not n6(Q[2],~q2);
endmodule
