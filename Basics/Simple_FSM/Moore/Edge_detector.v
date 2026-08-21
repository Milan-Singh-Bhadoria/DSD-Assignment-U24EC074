`timescale 1ns/1ps

 module edge_detect(
  input clk,reset,x,
  output reg y
);
   localparam L = 2'b00,L_H = 2'b01, H = 2'b11,H_L = 2'b10 ;
   reg [1:0]pr_s;
   reg [1:0]nx_s;
   always@(posedge clk or posedge reset)begin
    if(reset)begin
    pr_s<=L;
    end
    else begin 
    pr_s<= nx_s;
   end
  end
  
  always@(*) begin 
    case (pr_s)
     L : nx_s = (x) ? L_H : L;
     L_H : nx_s = (x) ? H : L;
     H : nx_s = (x) ? H : H_L;
     H_L : nx_s = (x) ? H : L;
     default : nx_s = L;
    endcase
  end

   always @(*)begin
    case(pr_s)
    L_H,H_L : y = 1'b1;
    L,H : y = 1'b0;
    default : y = 1'b0;
    endcase
  end
endmodule
