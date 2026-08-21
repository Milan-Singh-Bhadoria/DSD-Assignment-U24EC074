module HA(
    input a,b,
    output sum,cout
);
assign {cout,sum} = a+b;
    
endmodule

module FA(
   input a,b,cin,
   output sum,cout
);
   assign {cout,sum} = a+b+cin;
endmodule


module multi_8(
    input [7:0] a,
    input [7:0] b,
    output [15:0] o
);
    wire [55:0] c;      
    wire [21:0] ps; 
  wire carry[0:37];

  assign o[0] = a[0] & b[0];
  HA ha1(.a(a[1]&b[0]), .b(a[0]&b[1]), .sum(o[1]), .cout(c[0])); 
  
  FA fa1(.a(a[2]&b[0]), .b(a[1]&b[1]), .cin(c[0]), .sum(ps[0]), .cout(c[1]));
  HA ha2(.a(ps[0]), .b(a[0]&b[2]), .sum(o[2]), .cout(c[2]));
  
  HA ha3(.a(c[1]), .b(c[2]), .sum(carry[0]), .cout(carry[1]));
  
  FA fa2(.a(a[3]&b[0]), .b(a[2]&b[1]), .cin(carry[0]), .sum(ps[1]), .cout(c[3]));
  FA fa3(.a(a[1]&b[2]), .b(a[0]&b[3]), .cin(ps[1]), .sum(o[3]), .cout(c[4]));
  
  FA fa4(.a(carry[1]), .b(c[3]), .cin(c[4]), .sum(carry[2]), .cout(carry[3]));

  FA fa5(.a(a[4]&b[0]), .b(a[3]&b[1]), .cin(carry[2]), .sum(ps[2]), .cout(c[5]));
  FA fa6(.a(a[2]&b[2]), .b(a[1]&b[3]), .cin(ps[2]), .sum(ps[3]), .cout(c[6]));
  HA ha4(.a(ps[3]), .b(a[0]&b[4]), .sum(o[4]), .cout(c[7]));

  FA fa7(.a(carry[3]), .b(c[5]), .cin(c[6]), .sum(carry[4]), .cout(carry[5]));
  HA ha5(.a(carry[4]), .b(c[7]), .sum(carry[6]), .cout(c[8]));

  FA fa8(.a(a[5]&b[0]), .b(a[4]&b[1]), .cin(carry[6]), .sum(ps[4]), .cout(c[9]));
  FA fa9(.a(a[3]&b[2]), .b(a[2]&b[3]), .cin(ps[4]), .sum(ps[5]), .cout(c[10]));
  FA fa10(.a(a[1]&b[4]), .b(a[0]&b[5]), .cin(ps[5]), .sum(o[5]), .cout(c[11]));

  FA fa11(.a(carry[5]), .b(c[8]), .cin(c[9]), .sum(carry[7]), .cout(carry[8]));
  FA fa12(.a(carry[7]), .b(c[10]), .cin(c[11]), .sum(carry[9]), .cout(c[12]));

  FA fa13(.a(a[6]&b[0]), .b(a[5]&b[1]), .cin(carry[9]), .sum(ps[6]), .cout(c[13]));
  FA fa14(.a(a[4]&b[2]), .b(a[3]&b[3]), .cin(ps[6]), .sum(ps[7]), .cout(c[14]));
  FA fa15(.a(a[2]&b[4]), .b(a[1]&b[5]), .cin(ps[7]), .sum(ps[8]), .cout(c[15]));
  HA ha6(.a(ps[8]), .b(a[0]&b[6]), .sum(o[6]), .cout(c[16]));

  FA fa16(.a(carry[8]), .b(c[12]), .cin(c[13]), .sum(carry[10]), .cout(carry[11]));
  FA fa17(.a(carry[10]), .b(c[14]), .cin(c[15]), .sum(carry[12]), .cout(c[17]));
  HA ha7(.a(carry[12]), .b(c[16]), .sum(carry[13]), .cout(c[18]));

  FA fa18(.a(a[7]&b[0]), .b(a[6]&b[1]), .cin(carry[13]), .sum(ps[9]), .cout(c[19]));
  FA fa19(.a(a[5]&b[2]), .b(a[4]&b[3]), .cin(ps[9]), .sum(ps[10]), .cout(c[20]));
  FA fa20(.a(a[3]&b[4]), .b(a[2]&b[5]), .cin(ps[10]), .sum(ps[11]), .cout(c[21]));
  FA fa21(.a(a[1]&b[6]), .b(a[0]&b[7]), .cin(ps[11]), .sum(o[7]), .cout(c[22]));

  FA fa22(.a(carry[11]), .b(c[17]), .cin(c[18]), .sum(carry[14]), .cout(carry[15]));
  FA fa23(.a(carry[14]), .b(c[19]), .cin(c[20]), .sum(carry[16]), .cout(c[23]));
  FA fa24(.a(carry[16]), .b(c[21]), .cin(c[22]), .sum(carry[17]), .cout(c[24]));

  FA fa25(.a(a[7]&b[1]), .b(a[6]&b[2]), .cin(carry[17]), .sum(ps[12]), .cout(c[25]));
  FA fa26(.a(a[5]&b[3]), .b(a[4]&b[4]), .cin(ps[12]), .sum(ps[13]), .cout(c[26]));
  FA fa27(.a(a[3]&b[5]), .b(a[2]&b[6]), .cin(ps[13]), .sum(ps[14]), .cout(c[27]));
  HA ha8(.a(ps[14]), .b(a[1]&b[7]), .sum(o[8]), .cout(c[28]));

  FA fa28(.a(carry[15]), .b(c[23]), .cin(c[24]), .sum(carry[18]), .cout(carry[19]));
  FA fa29(.a(carry[18]), .b(c[25]), .cin(c[26]), .sum(carry[20]), .cout(c[29]));
  FA fa30(.a(carry[20]), .b(c[27]), .cin(c[28]), .sum(carry[21]), .cout(c[30]));

  FA fa31(.a(a[7]&b[2]), .b(a[6]&b[3]), .cin(carry[21]), .sum(ps[15]), .cout(c[31]));
  FA fa32(.a(a[5]&b[4]), .b(a[4]&b[5]), .cin(ps[15]), .sum(ps[16]), .cout(c[32]));
  FA fa33(.a(a[3]&b[6]), .b(a[2]&b[7]), .cin(ps[16]), .sum(o[9]), .cout(c[33]));

  FA fa34(.a(carry[19]), .b(c[29]), .cin(c[30]), .sum(carry[22]), .cout(carry[23]));
  FA fa35(.a(carry[22]), .b(c[31]), .cin(c[32]), .sum(carry[24]), .cout(c[34]));
  HA ha9(.a(carry[24]), .b(c[33]), .sum(carry[25]), .cout(c[35]));

  FA fa36(.a(a[7]&b[3]), .b(a[6]&b[4]), .cin(carry[25]), .sum(ps[17]), .cout(c[36]));
  FA fa37(.a(a[5]&b[5]), .b(a[4]&b[6]), .cin(ps[17]), .sum(ps[18]), .cout(c[37]));
  HA ha10(.a(ps[18]), .b(a[3]&b[7]), .sum(o[10]), .cout(c[38]));  

  FA fa38(.a(carry[23]), .b(c[34]), .cin(c[35]), .sum(carry[26]), .cout(carry[27]));
  FA fa39(.a(carry[26]), .b(c[36]), .cin(c[37]), .sum(carry[28]), .cout(c[39]));
  HA ha11(.a(carry[28]), .b(c[38]), .sum(carry[29]), .cout(c[40]));

  FA fa40(.a(a[7]&b[4]), .b(a[6]&b[5]), .cin(carry[29]), .sum(ps[19]), .cout(c[41]));
  FA fa41(.a(a[5]&b[6]), .b(a[4]&b[7]), .cin(ps[19]), .sum(o[11]), .cout(c[42]));

  FA fa42(.a(carry[27]), .b(c[39]), .cin(c[40]), .sum(carry[30]), .cout(carry[31]));
  FA fa43(.a(carry[30]), .b(c[41]), .cin(c[42]), .sum(carry[32]), .cout(c[43]));

  FA fa44(.a(a[7]&b[5]), .b(a[6]&b[6]), .cin(carry[32]), .sum(ps[20]), .cout(c[44]));
  HA ha12(.a(ps[20]), .b(a[5]&b[7]), .sum(o[12]), .cout(c[45]));  

  FA fa45(.a(carry[31]), .b(c[43]), .cin(c[44]), .sum(carry[33]), .cout(carry[34]));
  HA ha13(.a(carry[33]), .b(c[45]), .sum(carry[35]), .cout(c[46]));

  FA fa46(.a(a[7]&b[6]), .b(a[6]&b[7]), .cin(carry[35]), .sum(o[13]), .cout(c[47]));

  FA fa45(.a(carry[34]), .b(c[46]), .cin(c[47]), .sum(carry[36]), .cout(carry[37]));

  HA ha14(.a(a[7]&b[7]), .b(carry[36]), .sum(o[14]), .cout(c[48])); 

  HA ha15(.a(carry[37]), .b(c[48]), .sum(c[49]), .cout(c[50])); 

  assign o[15] = c[49] | c[50];
endmodule