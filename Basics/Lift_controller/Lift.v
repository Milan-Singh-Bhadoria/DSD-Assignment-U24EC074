`timescale 1ns / 1ps
module Lift(
   input clk,reset,[1:0]in,
   output reg [2:0]floor
    
);
reg [1:0]p_s,n_s;
  localparam first = 2'b00,
             second = 2'b01,
             third = 2'b11;
   
    always@(posedge clk) begin 
      if(reset)begin 
        p_s<=first;
      end
      else begin
        p_s<=n_s;
      end
    end
    
  always@(*)begin
    if(in == 2) n_s = second;

    else if(in == 1) n_s = first;

    else if(in == 3) n_s = third;
    end
    
    always@(*)begin
    if(p_s==first) floor = 1;
    if(p_s==second) floor = 2;
    if(p_s==third) floor = 4;
    end
endmodule
