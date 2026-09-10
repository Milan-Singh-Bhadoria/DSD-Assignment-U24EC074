`timescale 1ns / 1ps
module Direct_cache #(parameter width = 32,
   parameter size = 8,
   parameter block_size = 4,
   parameter block_number = 1024,
   parameter tag_bits = width - $clog2(block_number)- $clog2(block_size)  // 20bits
)(
  input clk,rst,
  input [width-1:0]core_out,
  input core_wr_en,
  input [size-1:0]core_wdata,
  input [block_size*size-1:0]memory_out,
  input mem_valid,                     // pulses when memory completes read OR write
  output reg read_en,
  output reg mem_wr_en,
  output reg [block_size*size-1:0]memory_wdata,
  output reg[size-1:0]core_in,
  output reg [width-1:0]memory_in,
  output reg flag_hit,
  output reg flag_miss,
  output reg core_ready
  );
   localparam latch     = 3'b000;   
   localparam check     = 3'b001;
   localparam hit       = 3'b010;
   localparam writeback = 3'b011;
   localparam refill    = 3'b100;
   localparam fill      = 3'b101;

  reg [2:0] curr_state,next_state;

   reg valid[block_number-1:0];
   reg dirty[block_number-1:0];
   integer i;
   initial begin
    for (i=0; i<block_number; i=i+1) begin
     valid[i] = 0;
     dirty[i] = 0;
    end
   end
   reg [(4*size)-1:0]block[block_number-1:0];
   reg [tag_bits-1:0]tag[block_number-1:0];

   reg [width-1:0] addr_buffer;
   reg             wr_buffer;
   reg [size-1:0]  wdata_buffer;

   wire [($clog2(block_number)-1):0] index   = addr_buffer[(width-tag_bits)-1:$clog2(block_size)];
   wire [tag_bits-1:0]               req_tag = addr_buffer[width-1:$clog2(block_number)+$clog2(block_size)];
   wire [$clog2(block_size)-1:0]     offset  = addr_buffer[$clog2(block_size)-1:0];

   wire [width-1:0] evict_addr = {tag[index], index};

   reg [(4*size)-1:0] merged_block;
   always@(*) begin
     merged_block = memory_out;
     if(wr_buffer) begin
       case(offset)
        2'b00: merged_block = {memory_out[4*size-1:size],    wdata_buffer};
        2'b01: merged_block = {memory_out[4*size-1:2*size],  wdata_buffer, memory_out[size-1:0]};
        2'b10: merged_block = {memory_out[4*size-1:3*size],  wdata_buffer, memory_out[2*size-1:0]};
        2'b11: merged_block = {wdata_buffer,                 memory_out[3*size-1:0]};
       endcase
     end
   end

   reg [(4*size)-1:0] hit_merged_block;
   always@(*) begin
     case(offset)
      2'b00: hit_merged_block = {block[index][4*size-1:size],   wdata_buffer};
      2'b01: hit_merged_block = {block[index][4*size-1:2*size], wdata_buffer, block[index][size-1:0]};
      2'b10: hit_merged_block = {block[index][4*size-1:3*size], wdata_buffer, block[index][2*size-1:0]};
      2'b11: hit_merged_block = {wdata_buffer,                  block[index][3*size-1:0]};
     endcase
   end

   // Capture the request on the edge that ENTERS check 
   always@(posedge clk or posedge rst)begin
    if(rst)
    curr_state <= latch;
   else
    curr_state <= next_state;
   end

  always@(posedge clk)begin
   if(curr_state==latch) begin
    addr_buffer  <= core_out;
    wr_buffer    <= core_wr_en;
    wdata_buffer <= core_wdata;
   end
  end

   always@(*)begin
    core_ready    = 1'b0;
    flag_hit      = 1'b0;
    flag_miss     = 1'b0;
    read_en       = 1'b0;
    mem_wr_en     = 1'b0;
    core_in       = {size{1'b0}};
    memory_in     = {width{1'b0}};
    memory_wdata  = {(block_size*size){1'b0}};
    next_state    = check;

    case(curr_state)
  latch: begin
    next_state = check;
  end

  check: begin
    if(valid[index] && tag[index]==req_tag) begin
      next_state = hit;
    end
    else begin
      flag_miss = 1'b1;
      next_state = (valid[index] && dirty[index]) ? writeback : refill;
    end
  end

  hit: begin
    flag_hit   = 1'b1;
    core_ready = 1'b1;
    if(!wr_buffer) begin
      case(offset)
       2'b00 : core_in = block[index][size-1:0];
       2'b01 : core_in = block[index][2*size-1:size];
       2'b10 : core_in = block[index][3*size-1:2*size];
       2'b11 : core_in = block[index][4*size-1:3*size];
      endcase
    end
    next_state = latch;   // now returns through latch to re-capture
  end

    writeback: begin
       mem_wr_en    = ~mem_valid;            
       memory_in    = evict_addr;
       memory_wdata = block[index];
       next_state   = mem_valid ? refill : writeback;
    end

    refill: begin
      read_en    = ~mem_valid;              // drop the request the instant it's acknowledged
      memory_in  = addr_buffer[width-1:$clog2(block_size)];
      next_state = mem_valid ? fill : refill;
    end

  fill: begin
    case(offset)
     2'b00 : core_in = memory_out[size-1:0];
     2'b01 : core_in = memory_out[2*size-1:size];
     2'b10 : core_in = memory_out[3*size-1:2*size];
     2'b11 : core_in = memory_out[4*size-1:3*size];
    endcase
    core_ready = 1'b1;
    next_state = latch;   // returns through latch to re-capture
  end

 default : next_state = latch;
endcase
end

   always@(posedge clk)begin
     if(curr_state==hit && wr_buffer) begin
       block[index] <= hit_merged_block;
       dirty[index] <= 1'b1;
     end
     else if(curr_state==fill) begin
       block[index] <= wr_buffer ? merged_block : memory_out;
       tag[index]   <= req_tag;
       valid[index] <= 1'b1;
       dirty[index] <= wr_buffer;
     end
   end

  always @(posedge clk) begin
 $display("T=%0t | st=%0d idx=%0d valid=%b dirty=%b tag=%h block=%h hit=%b miss=%b | ren=%b wen=%b mvalid=%b mem_in=%0d mem_wdata=%h mem_out=%h",
         $time, curr_state, index, valid[index], dirty[index], tag[index], block[index],
         flag_hit, flag_miss,
         read_en, mem_wr_en, mem_valid, memory_in, memory_wdata, memory_out);
end

 endmodule
