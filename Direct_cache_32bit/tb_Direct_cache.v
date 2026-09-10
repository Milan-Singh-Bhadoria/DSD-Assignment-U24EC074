`timescale 1ns / 1ps
module mem_model #(
  parameter width   = 32,
  parameter depth   = 16384,
  parameter size    = 8,
  parameter LATENCY = 5
)(
  input clk,
  input read_en,
  input write_en,
  input [width-1:0] memory_in,
  input [4*size-1:0] memory_wdata,
  output reg [4*size-1:0] memory_out,
  output reg mem_valid
);
  reg [4*size-1:0] memory [0:depth-1];
  integer i;
  integer b0,b1,b2,b3;
  initial begin
    for(i=0;i<depth;i=i+1) begin
      b0 = (2*(4*i+0)+1) % 256;
      b1 = (2*(4*i+1)+1) % 256;
      b2 = (2*(4*i+2)+1) % 256;
      b3 = (2*(4*i+3)+1) % 256;
      memory[i] = {b3[7:0], b2[7:0], b1[7:0], b0[7:0]};
    end
  end

  localparam IDLE = 0, BUSY = 1;
  reg state;
  reg [31:0] cnt;
  reg is_write;
  reg [width-1:0] addr_r;
  reg [4*size-1:0] wdata_r;

  initial begin
    state     = IDLE;
    cnt       = 0;
    is_write  = 0;
    mem_valid = 0;
  end

  always @(posedge clk) begin
    mem_valid <= 1'b0;
    case(state)
      IDLE: if(read_en || write_en) begin
        addr_r   <= memory_in;
        wdata_r  <= memory_wdata;
        is_write <= write_en;
        cnt      <= LATENCY - 1;
        state    <= BUSY;
      end

      BUSY: begin
        if(cnt == 0) begin
          if(is_write) begin
            memory[addr_r] <= wdata_r;
            $display("T=%0t | MEM WRITE  addr=%0d  data=%h", $time, addr_r, wdata_r);
          end
          else begin
            memory_out <= memory[addr_r];
            $display("T=%0t | MEM READ   addr=%0d  data=%h", $time, addr_r, memory[addr_r]);
          end
          mem_valid <= 1'b1;
          state     <= IDLE;
        end
        else cnt <= cnt - 1;
      end
    endcase
  end
endmodule


module tb_Direct_cache;
  reg clk;
  reg rst;
  reg [31:0] core_out;
  reg core_wr_en;
  reg [7:0] core_wdata;
  wire read_en;
  wire mem_wr_en;
  wire [31:0] memory_out;
  wire mem_valid;
  wire [7:0] core_in;
  wire [31:0] memory_in;
  wire [31:0] memory_wdata;
  wire flag_hit;
  wire flag_miss;
  wire core_ready;

  Direct_cache dut (
    .clk(clk), .rst(rst),
    .core_out(core_out), .core_wr_en(core_wr_en), .core_wdata(core_wdata),
    .memory_out(memory_out), .mem_valid(mem_valid),
    .read_en(read_en), .mem_wr_en(mem_wr_en), .memory_wdata(memory_wdata),
    .core_in(core_in), .memory_in(memory_in),
    .flag_hit(flag_hit), .flag_miss(flag_miss), .core_ready(core_ready)
  );

  mem_model #(.LATENCY(5)) mem (
    .clk(clk),
    .read_en(read_en), .write_en(mem_wr_en),
    .memory_in(memory_in), .memory_wdata(memory_wdata),
    .memory_out(memory_out), .mem_valid(mem_valid)
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
    clk = 0; rst = 1; core_out = 0; core_wr_en = 0; core_wdata = 0;
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

    send_op(32'h0000_0000, 0, 8'h00);
    send_op(32'h0000_0000, 1, 8'hAA);
    send_op(32'h0000_0000, 0, 8'h00);
    send_op(32'h0000_1000, 0, 8'h00);
    send_op(32'h0000_0000, 0, 8'h00);
    send_op(32'h0000_2322, 1, 8'h77);
    send_op(32'h0000_2322, 0, 8'h00);

    #100 $finish;
  end
endmodule
