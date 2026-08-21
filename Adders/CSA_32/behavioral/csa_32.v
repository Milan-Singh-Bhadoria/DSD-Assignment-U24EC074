module csa_32(
    input [31:0] a, b,
    input cin,
    output reg [31:0] sum,
    output reg cout
);
    reg [7:0] sum_low;
    reg [7:0] sum_mid0, sum_mid1;
    reg [7:0] sum_high0, sum_high1;
    reg [7:0] sum_top0, sum_top1;
    
    reg cout_mid0, cout_mid1;
    reg cout_high0, cout_high1;
    reg cout_top0, cout_top1;
    
    reg c8, c16, c24;
    
   always @(*) begin
    {c8, sum[7:0]} = a[7:0] + b[7:0] + cin;
    
    {cout_mid0, sum_mid0} = a[15:8] + b[15:8] + 1'b0; 
    {cout_mid1, sum_mid1} = a[15:8] + b[15:8] + 1'b1;  
    
    sum[15:8] = c8 ? sum_mid1 : sum_mid0;
    c16 = c8 ? cout_mid1 : cout_mid0;
    
    {cout_high0, sum_high0} = a[23:16] + b[23:16] + 1'b0;
    {cout_high1, sum_high1} = a[23:16] + b[23:16] + 1'b1;  
    
    sum[23:16] = c16 ? sum_high1 : sum_high0;
    c24 = c16 ? cout_high1 : cout_high0;
    
    {cout_top0, sum_top0} = a[31:24] + b[31:24] + 1'b0;  
    {cout_top1, sum_top1} = a[31:24] + b[31:24] + 1'b1; 
    
    sum[31:24] = c24 ? sum_top1 : sum_top0;
    cout = c24 ? cout_top1 : cout_top0;
    end
endmodule