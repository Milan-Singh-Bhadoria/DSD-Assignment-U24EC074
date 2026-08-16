`timescale 1ns / 1ps
 module tb_set_associative();
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

  reg [7:0] captured_core_in;

  set_associative dut (
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
      captured_core_in = core_in;
      $display("T=%0t | addr=%h wr=%b wdata=%h -> core_in=%h hit=%b miss=%b",
                $time, addr, wr, wdata, core_in, flag_hit, flag_miss);
      @(posedge clk);
    end
  endtask

  initial begin
    $dumpfile("set_associative.vcd");
    $dumpvars(0, tb_set_associative);
    clk = 0;
    rst = 1;
    core_out = 0;
    core_wr_en = 0;
    core_wdata = 0;
    #10 rst = 0;

    // --- basic hit/miss sweep across several distinct sets/tags ---
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

    // fill ALL 8 ways of index=0 to force a genuine dirty eviction 
    // (with ways=8, two addresses sharing an index just occupy separate
    //  ways -- nothing gets evicted until the set is completely full)
    send_op(32'h0000_0000, 0, 8'h00);   // tag=0 -> miss, allocate way0
    send_op(32'h0000_0000, 1, 8'hAA);   // write hit -> dirty way0 (0xAA)
    send_op(32'h0000_0200, 0, 8'h00);   // tag=1 -> miss, allocate way1
    send_op(32'h0000_0400, 0, 8'h00);   // tag=2 -> miss, allocate way2
    send_op(32'h0000_0600, 0, 8'h00);   // tag=3 -> miss, allocate way3
    send_op(32'h0000_0800, 0, 8'h00);   // tag=4 -> miss, allocate way4
    send_op(32'h0000_0A00, 0, 8'h00);   // tag=5 -> miss, allocate way5
    send_op(32'h0000_0C00, 0, 8'h00);   // tag=6 -> miss, allocate way6
    send_op(32'h0000_0E00, 0, 8'h00);   // tag=7 -> miss, allocate way7 (set now full)
    send_op(32'h0000_1000, 0, 8'h00);   // tag=8 -> miss, round-robin wraps -> EVICTS dirty way0

    send_op(32'h0000_0000, 0, 8'h00);
    if(captured_core_in === 8'hAA)
  $display("PASS: dirty data correctly written back before eviction");
     else
  $display("FAIL: expected 8'hAA after eviction+writeback, got %h", captured_core_in);
    // addr 0x00002322 -> index=72 (unused so far), offset=2 (non-zero, on purpose)
    send_op(32'h0000_2322, 1, 8'h77);   // write MISS -> refill, merge 0x77 at offset 2, mark dirty
    send_op(32'h0000_2322, 0, 8'h00);   // read hit -> core_in must be 0x77
    if(captured_core_in === 8'h77)
      $display("PASS: write-allocate merge landed correctly at non-zero offset");
    else
      $display("FAIL: expected 8'h77 from write-allocate merge, got %h", captured_core_in);

    #50 $finish;
  end
endmodule
