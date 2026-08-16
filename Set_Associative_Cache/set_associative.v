`timescale 1ns / 1ps
 module set_associative #(parameter width = 32,
   parameter size = 8,
   parameter block_size = 4,
   parameter ways = 8,
   parameter cache_lines = 1024,
   parameter set = cache_lines/ways,
   parameter tag_bits = width - $clog2(set)- $clog2(block_size)  // 22bits
)(
  input clk,rst,
  input [width-1:0]core_out,
  input core_wr_en,
  input [size-1:0]core_wdata,
  input [block_size*size-1:0]memory_out,
  output reg read_en,
  output reg mem_wr_en,
  output reg [block_size*size-1:0]memory_wdata,
  output reg[size-1:0]core_in,
  output reg [width-1:0]memory_in,
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

   reg [ways-1:0]valid[set-1:0];
   reg [ways-1:0]dirty[set-1:0];
  
   integer i,j;
   initial begin
    for (i=0; i<set; i=i+1)begin
     for (j=0; j<ways; j=j+1)begin
       valid[i][j] = 0;
       dirty[i][j] = 0;
       end
      end
     end

   reg [(4*size)-1:0]block[set-1:0][ways-1:0];
   reg [tag_bits-1:0]tag[set-1:0][ways-1:0];

   // Frozen request -- captured ONCE at init, held for the whole transaction
   reg [width-1:0] addr_buffer;
   reg             wr_buffer;
   reg [size-1:0]  wdata_buffer;

   wire [($clog2(set)-1):0] index    = addr_buffer[(width-tag_bits)-1:$clog2(block_size)];
   wire [tag_bits-1:0]      tag_addr = addr_buffer[width-1:$clog2(set)+$clog2(block_size)];
   wire [$clog2(block_size)-1:0] offset = addr_buffer[$clog2(block_size)-1:0];

   reg [$clog2(ways)-1:0] hit_way;
   reg                    hit_check;
   reg [$clog2(ways)-1:0] rr_pointer[set-1:0];
   reg [$clog2(ways)-1:0] replacement_way;   // victim way, captured once per miss

   // Reconstructed address of the block currently occupying [index][replacement_way],
   // needed to write it back correctly if dirty and about to be evicted.
   wire [width-1:0] evict_addr = {tag[index][replacement_way], index, {$clog2(block_size){1'b0}}};

   integer k;

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
      2'b00: hit_merged_block = {block[index][hit_way][4*size-1:size],   wdata_buffer};
      2'b01: hit_merged_block = {block[index][hit_way][4*size-1:2*size], wdata_buffer, block[index][hit_way][size-1:0]};
      2'b10: hit_merged_block = {block[index][hit_way][4*size-1:3*size], wdata_buffer, block[index][hit_way][2*size-1:0]};
      2'b11: hit_merged_block = {wdata_buffer,                           block[index][hit_way][3*size-1:0]};
     endcase
   end

   always@(posedge clk or posedge rst)begin
     if(rst)begin
       curr_state <= init;
     end
     else begin
       curr_state <= next_state;
       if(curr_state==init) begin
         addr_buffer  <= core_out;
         wr_buffer    <= core_wr_en;
         wdata_buffer <= core_wdata;
       end
       if(curr_state==check && (next_state==refill || next_state==writeback))
           replacement_way <= rr_pointer[index];   // capture victim way once, at miss detection
     end
   end

   always@(*)begin
    hit_way   = 0;
    hit_check = 0;
     for(k=0; k<ways; k=k+1)begin
      if(!hit_check && valid[index][k] && (tag[index][k] == tag_addr))begin
            hit_way   = k[$clog2(ways)-1:0];
            hit_check = 1'b1;
      end
    end
   end

    always @(posedge clk or posedge rst) begin
     if (rst) begin
       for(i=0;i<set;i=i+1)
       rr_pointer[i] <= 0;
     end else if (curr_state == fill) begin
       rr_pointer[index] <= rr_pointer[index] + 1;
     end
    end

   always@(*)begin
    // Defaults every pass -- prevents inferred latches / stale outputs
    core_ready   = 1'b0;
    flag_hit     = 1'b0;
    flag_miss    = 1'b0;
    read_en      = 1'b0;
    mem_wr_en    = 1'b0;
    core_in      = {size{1'b0}};
    memory_in    = {width{1'b0}};
    memory_wdata = {(block_size*size){1'b0}};
    next_state   = init;

    case(curr_state)
      init: begin
       next_state = check;
      end

      check: begin
        if(hit_check) begin
          next_state = wr_buffer ? hit_write : hit_read;
        end
        else begin
          flag_miss = 1'b1;
          // NOTE: uses rr_pointer[index] directly here (same value latched above)
          // to decide dirty status of the about-to-be-evicted way
          if(valid[index][rr_pointer[index]] && dirty[index][rr_pointer[index]])
            next_state = writeback;
          else
            next_state = refill;
        end
      end

      hit_read: begin
        flag_hit   = 1'b1;
        core_ready = 1'b1;
        case(offset)
         2'b00 : core_in = block[index][hit_way][size-1:0];
         2'b01 : core_in = block[index][hit_way][2*size-1:size];
         2'b10 : core_in = block[index][hit_way][3*size-1:2*size];
         2'b11 : core_in = block[index][hit_way][4*size-1:3*size];
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
        memory_wdata = block[index][replacement_way];
        next_state   = wb_wait;
      end

      wb_wait: begin
        mem_wr_en    = 1'b1;
        memory_in    = evict_addr;
        memory_wdata = block[index][replacement_way];
        next_state   = refill;
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
        // actual array write happens in the clocked block below
      end

     default : next_state = init;
    endcase
   end

   // Cache-array writes, clocked, one-shot per transaction.
   always@(posedge clk)begin
     if(curr_state==hit_write) begin
       block[index][hit_way] <= hit_merged_block;
       dirty[index][hit_way] <= 1'b1;
     end
     else if(curr_state==fill) begin
       block[index][replacement_way] <= wr_buffer ? merged_block : memory_out;
       tag[index][replacement_way]   <= tag_addr;
       valid[index][replacement_way] <= 1'b1;
       dirty[index][replacement_way] <= wr_buffer;
     end
   end

   main_memory m1(
     .clk(clk),
     .read_en(read_en),
     .write_en(mem_wr_en),
     .memory_in(memory_in),
     .memory_wdata(memory_wdata),
     .memory_out(memory_out)
   );

  always @(posedge clk) begin
   $display("T=%0t | st=%0d idx=%0d hit_way=%0d rep_way=%0d hit=%b miss=%b valid=%b dirty=%b tag=%h block=%h",
           $time,
           curr_state,
           index,
           hit_way,
           replacement_way,
           flag_hit,
           flag_miss,
           valid[index][hit_way],
           dirty[index][hit_way],
           tag[index][hit_way],
           block[index][hit_way]);
  end
 endmodule
 
 
 
 //////////////////// MAIN MEMORY //////////////////
 module main_memory#(parameter width = 32,
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
