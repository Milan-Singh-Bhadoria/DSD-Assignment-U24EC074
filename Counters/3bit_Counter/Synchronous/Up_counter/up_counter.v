`timescale 1ns / 1ps
module flip_flop(
    input D,
    input clk,reset,
    output reg Q
    );
    always@(posedge clk)begin
    if(reset)begin
    Q<=0;
    end
    else begin 
    Q <= D;
    end
   end
endmodule


module Up_counter_3bit(
    input clk,reset,
    output [2:0] Q
);
    wire q0 , q1, q2;
    wire D0, D1, D2;
    wire k;

    not n0(D0, q0);
    xor x1(D1, q1, q0);
    and a1(k, q0, q1);
    xor x2(D2, q2,k);

    flip_flop t1(.D(D0), .clk(clk), .reset(reset), .Q(q0));
    flip_flop t2(.D(D1), .clk(clk), .reset(reset), .Q(q1));
    flip_flop t3(.D(D2), .clk(clk), .reset(reset), .Q(q2));

   not n1(Q[0],~q0);
   not n2(Q[1],~q1);
   not n3(Q[2],~q2);
endmodule
