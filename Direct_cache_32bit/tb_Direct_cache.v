`timescale 1ns / 1ps
module tb_Direct_cache;
  reg clk;
  reg rst;
  reg [31:0] core_out;
  reg core_wr_en;
  reg [7:0] core_wdata;
  wire read_en;
  wire mem_wr_en;
  wire [31:0] memory_out;
  wire [7:0] core_in;
  wire [31:0] memory_in;
  wire [31:0] memory_wdata;
  wire flag_hit;
  wire flag_miss;
  wire core_ready;

  Direct_cache dut (
    .clk(clk),
    .rst(rst),
    .core_out(core_out),
    .core_wr_en(core_wr_en),
    .core_wdata(core_wdata),
    .memory_out(memory_out),
    .read_en(read_en),
    .mem_wr_en(mem_wr_en),
    .memory_wdata(memory_wdata),
    .core_in(core_in),
    .memory_in(memory_in),
    .flag_hit(flag_hit),
    .flag_miss(flag_miss),
    .core_ready(core_ready)
  );

  always #5 clk = ~clk;

  task send_op(input [31:0] addr, input wr, input [7:0] wdata);
    begin
      core_out   = addr;
      core_wr_en = wr;
      core_wdata = wdata;
      @(posedge clk);
      while (!core_ready)
       @(posedge clk);
      $display("T=%0t | addr=%h wr=%b wdata=%h -> core_in=%h hit=%b miss=%b",
                $time, addr, wr, wdata, core_in, flag_hit, flag_miss);
      @(posedge clk);
    end
  endtask

  initial begin
    $dumpfile("Direct_cache.vcd");
    $dumpvars(0, tb_Direct_cache);
    clk = 0;
    rst = 1;
    core_out = 0;
    core_wr_en = 0;
    core_wdata = 0;
    #10 rst = 0;

    send_op(32'h1461, 0, 8'h00);
    send_op(32'h512D, 0, 8'h00);
    send_op(32'h1461, 0, 8'h00);
    send_op(32'hF257, 0, 8'h00);
    send_op(32'h1461, 0, 8'h00);
    send_op(32'hF634, 0, 8'h00);
    send_op(32'h7D6B, 0, 8'h00);
    send_op(32'h8863, 0, 8'h00);
    send_op(32'h512D, 0, 8'h00);
    send_op(32'h8863, 0, 8'h00);

    // addr_A and addr_B share index=0, different tag -> addr_B forces
    // eviction of addr_A's line.
    send_op(32'h0000_0000, 0, 8'h00);   // read miss -> refill addr_A
    send_op(32'h0000_0000, 1, 8'hAA);   // write hit -> dirty addr_A's line
    send_op(32'h0000_0000, 0, 8'h00);   // read hit -> should show 0xAA
    send_op(32'h0000_1000, 0, 8'h00);   // read miss on addr_B -> evicts addr_A (dirty!) then refills addr_B
    send_op(32'h0000_0000, 0, 8'h00);   // read miss on addr_A again -> re-fetched from MAIN MEMORY
    send_op(32'h0000_2322, 1, 8'h77);   // write MISS -> must refill first, then merge 0x77 at offset 2, set dirty
    send_op(32'h0000_2322, 0, 8'h00);                          

    #50 $finish;
  end
endmodule
