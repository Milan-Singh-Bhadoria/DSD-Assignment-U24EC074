`timescale 1ns / 1ps
module Traffic(
    input clk,reset,
    output reg Red, Green ,Yellow   
);

  reg [3:0]Timer;
localparam R = 3'b000,     
           G = 3'b010,            
           Y = 3'b100;          
    reg [2:0] p_s,n_s;  
  always @(posedge clk or posedge reset)begin
      if(reset)begin
       p_s<=R;
       Timer<=0;
       end
      else begin 
      p_s<=n_s;
      Timer <= Timer +1 ;
    end
  end     
  
  always@(*)begin
    case(p_s)
     R : if(Timer==4'd15) n_s = G;
     G : if(Timer>=4'd10 && Timer<=4'd14) n_s = Y;
     Y : if(Timer<=4'd9) n_s = R;
     default : n_s = R;
    endcase
  end
  
  always@(*)begin
    if(p_s==R)begin
    Red = 1;
    Yellow = 0;
    Green = 0;
    end
    else if(p_s==G)begin
     Red = 0;
    Yellow = 0;
    Green = 1;
    end
    else if(p_s==Y) begin
      Red = 0;
    Yellow = 1;
    Green = 0;
    end
  end
endmodule
