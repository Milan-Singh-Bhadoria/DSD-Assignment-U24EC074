`timescale 1ns / 1ps
module Direct_cache #(parameter width = 32,
   parameter size = 8,
   parameter block_size = 4,
   parameter block_number = 1024,
   parameter tag_bits = width - $clog2(block_number)- $clog2(block_size)  // 20bits
)(
  input clk,rst,
  input [width-1:0]core_out,          // address from core
  input core_wr_en,                    // 1 = core writes , 0 = read
  input [size-1:0]core_wdata,          // data core wants to write
  input [block_size*size-1:0]memory_out,   // block data returned by main memory 
  output reg read_en,                  // main_mem read enable
  output reg mem_wr_en,                // main_mem write enable (for writeback)
  output reg [block_size*size-1:0]memory_wdata, // block data sent to main memory (writeback)
  output reg[size-1:0]core_in,         // data returned to core (reads)
  output reg [width-1:0]memory_in,     // address sent to main memory (read or write)
  output reg flag_hit,
  output reg flag_miss,
  output reg core_ready
  );

  localparam init        = 4'b0000;
  localparam check       = 4'b0001;
  localparam hit_read    = 4'b0010;
  localparam hit_write   = 4'b0011;
  localparam writeback   = 4'b0100;
  localparam wb_wait     = 4'b0101;
  localparam refill      = 4'b0110;
  localparam refill_wait = 4'b0111;
  localparam fill        = 4'b1000;

  reg [3:0] curr_state,next_state;

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

   wire [($clog2(block_number)-1):0] index  = addr_buffer[(width-tag_bits)-1:$clog2(block_size)];
   wire [tag_bits-1:0]               req_tag = addr_buffer[width-1:$clog2(block_number)+$clog2(block_size)];
   wire [$clog2(block_size)-1:0]     offset = addr_buffer[$clog2(block_size)-1:0];

   // Reconstructed address of whatever block currently occupies index needed to write it back correctly if it's dirty and about to be evicted.
   wire [width-1:0] evict_addr = {tag[index], index, {$clog2(block_size){1'b0}}};

   // Merge core's write data into a freshly-fetched block (write-miss path)
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

   // Merge core's write data directly into the resident block (write-hit path)
   reg [(4*size)-1:0] hit_merged_block;
   always@(*) begin
     case(offset)
      2'b00: hit_merged_block = {block[index][4*size-1:size],   wdata_buffer};
      2'b01: hit_merged_block = {block[index][4*size-1:2*size], wdata_buffer, block[index][size-1:0]};
      2'b10: hit_merged_block = {block[index][4*size-1:3*size], wdata_buffer, block[index][2*size-1:0]};
      2'b11: hit_merged_block = {wdata_buffer,                  block[index][3*size-1:0]};
     endcase
   end

   always@(posedge clk or posedge rst)begin
     if(rst)begin
       curr_state <= init;
     end
     else begin
       curr_state <= next_state;
       // Freeze the request ONCE, at entry, so nothing downstream can drift even if core_out/core_wr_en/core_wdata change mid-transaction.
       if(curr_state==init) begin
         addr_buffer  <= core_out;
         wr_buffer    <= core_wr_en;
         wdata_buffer <= core_wdata;
       end
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
    next_state    = init;

    case(curr_state)
      init: begin
       next_state = check;
      end

      check: begin
        if(valid[index] && tag[index]==req_tag) begin
          next_state = wr_buffer ? hit_write : hit_read;
        end
        else begin
          flag_miss = 1'b1;
          if(valid[index] && dirty[index])
            next_state = writeback;   // dirty block occupies this slot  flush it first
          else
            next_state = refill;      // slot is empty or clean safe to overwrite directly
        end
      end

      hit_read: begin
        flag_hit   = 1'b1;
        core_ready = 1'b1;
        case(offset)
         2'b00 : core_in = block[index][size-1:0];
         2'b01 : core_in = block[index][2*size-1:size];
         2'b10 : core_in = block[index][3*size-1:2*size];
         2'b11 : core_in = block[index][4*size-1:3*size];
        endcase
        next_state = init;
      end

      hit_write: begin
        flag_hit   = 1'b1;
        core_ready = 1'b1;
        next_state = init;
        // actual array write happens in the clocked block below
      end

      writeback: begin
        mem_wr_en    = 1'b1;
        memory_in    = evict_addr;
        memory_wdata = block[index];
        next_state   = wb_wait;
      end

      wb_wait: begin
        mem_wr_en  = 1'b1;   // hold write valid one more cycle for memory to latch
        memory_in  = evict_addr;
        memory_wdata = block[index]; 
        next_state = refill;
      end

      refill: begin
        read_en    = 1'b1;
        memory_in  = addr_buffer;
        next_state = refill_wait;
      end

      refill_wait: begin
        read_en    = 1'b1;
        memory_in  = addr_buffer;
        next_state = fill;
      end

      fill: begin
        case(offset)
         2'b00 : core_in = memory_out[size-1:0];
         2'b01 : core_in = memory_out[2*size-1:size];
         2'b10 : core_in = memory_out[3*size-1:2*size];
         2'b11 : core_in = memory_out[4*size-1:3*size];
        endcase
        core_ready = 1'b1;
        next_state = init;
      end

     default : next_state = init;
    endcase
   end

   always@(posedge clk)begin
     if(curr_state==hit_write) begin
       block[index] <= hit_merged_block;
       dirty[index] <= 1'b1;
     end
     else if(curr_state==fill) begin
       block[index] <= wr_buffer ? merged_block : memory_out;
       tag[index]   <= req_tag;
       valid[index] <= 1'b1;
       dirty[index] <= wr_buffer;   // dirty only if this fill came from a write-miss
     end
   end

   always @(posedge clk) begin
   $display("T=%0t | st=%0d idx=%0d valid=%b dirty=%b tag=%h block=%h flag_hit=%h flag_miss=%h",
           $time,
           curr_state,
           index,
           valid[index],
           dirty[index],
           tag[index],
           block[index],
           flag_hit,
           flag_miss);
  end

   memory m1(
     .clk(clk),
     .read_en(read_en),
     .write_en(mem_wr_en),
     .memory_in(memory_in),
     .memory_wdata(memory_wdata),
     .memory_out(memory_out)
   );

 endmodule


/////////////////// MAIN MEMORY ////////////////////
module memory#(parameter width = 32,
   parameter depth = 65536,
   parameter size = 8
  )(
   input clk,
   input read_en,
   input write_en,
   input [width-1:0]memory_in,
   input [4*size-1:0]memory_wdata,
   output reg [4*size-1:0]memory_out
 );
   reg [size-1:0]memory[depth-1:0];
   integer i;

   initial begin
     for(i=0;i<depth;i=i+1)begin
         memory[i] = (2*i)+1;
     end
   end

   always@(posedge clk)begin
    if(write_en) begin
     memory[memory_in]   <= memory_wdata[size-1:0];
     memory[memory_in+1] <= memory_wdata[2*size-1:size];
     memory[memory_in+2] <= memory_wdata[3*size-1:2*size];
     memory[memory_in+3] <= memory_wdata[4*size-1:3*size];
    end
    else if(read_en )begin
     memory_out <= {memory[memory_in+3],memory[memory_in+2],memory[memory_in+1],memory[memory_in]};
    end
   end
 endmodule
