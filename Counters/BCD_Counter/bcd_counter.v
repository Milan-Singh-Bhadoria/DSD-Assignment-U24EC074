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

module bcd_counter(
    input clk,reset,
    output [3:0] Q
);
    wire q0 , q1, q2 , q3;
    wire D0, D1, D2 ,D3;
    wire k1,k2,k3,k4,k5,k6,k7;
    
  and a1(k1,q3,~q1,~q0);
  and a2(k2,q2,q1,q0);
  or o1(D3,k1,k2);
  
  and a3(k3,q2,~q1);
  and a4(k4,~q3,q2,~q0);
  and a5(k5,~q2,q1,q0);
  or o2(D2,k3,k4,k5);
  
  and a6(k6,q1,~q0);
  and a7(k7,~q3,~q1,q0);
  or o3(D1,k6,k7);
  
  not n1(D0,q0);

    flip_flop t1(.D(D0), .clk(clk), .reset(reset), .Q(q0));
    flip_flop t2(.D(D1), .clk(clk), .reset(reset), .Q(q1));
    flip_flop t3(.D(D2), .clk(clk), .reset(reset), .Q(q2));
    flip_flop t4(.D(D3), .clk(clk), .reset(reset), .Q(q3));

   not n2(Q[0],~q0);
   not n3(Q[1],~q1);
   not n4(Q[2],~q2);
   not n5(Q[3],~q3);
endmodule
