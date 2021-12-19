/******************************************************************************* 
 * Module   : sram_4k
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 19-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * BRAM to be used as data or instruction memory for the FRiscv CPU. This
 * version is fixed at 32bx1024b = 4096B.
 * The CPU is expecting the memory to be byte addressable, but the BRAM will be 
 * word addressable. Therefore address conversion logic is implemented in this 
 * module.
 * Based on the Xilinx Simple Dual Port Single Clock RAM language template.
 * TODO: Implement this using xilinx parameterised macros (XPMs)
 ******************************************************************************/

import friscv_pkg::*;

module sram_4k #(
  parameter RAM_WIDTH = ARCH,  // Specify RAM data width
  parameter RAM_DEPTH = 4096,  // Specify RAM depth (number of entries)
  parameter INIT_FILE = ""     // Specify name/location of RAM initialization 
                               // file if using one (leave blank if not)
) (
  input  logic clk,                                    // Clock
  input  logic [$clog2(RAM_DEPTH)-1:0] addr_a_byte_in, // Wr addr byte aligned
  input  logic [$clog2(RAM_DEPTH)-1:0] addr_b_byte_in, // Rd addr byte aligned 
  input  logic [RAM_WIDTH-1:0] din_a_in,               // RAM input data
  input  logic we_a_in,                                // Write enable
  input  logic en_b_in,                                // Read Enable
  
  output logic [RAM_WIDTH-1:0] dout_b_out              // RAM output data
);
  
  /* use local params to define values which will allow word aligned addresses 
     to be calculated in an architecture agnostic way.
     ADDR_SHIFT_AMOUNT is the number of r-shift operations which need to be
     performed on the input address to convert to word aligned address.
     e.g. if ARCH is 64-bits, ARCH_BYTES will be 8 and ADDR_SHIFT_AMOUNT will be
     3, such the that address 5'b01101 -> 5'b00001 as byte 13 will be contained
     within the word at addr 1 of memory. */
  localparam RAM_ADDR_WIDTH = $clog2(RAM_DEPTH);
  localparam ARCH_BYTES = ARCH / 8;
  localparam ADDR_SHIFT_AMOUNT = $clog2(ARCH_BYTES);

  logic [RAM_WIDTH-1:0] sram_mem [RAM_DEPTH-1:0];
  logic [RAM_WIDTH-1:0] ram_data = '0;
  logic [$clog2(RAM_DEPTH)-ADDR_SHIFT_AMOUNT-1:0] addr_a_word_s;
  logic [$clog2(RAM_DEPTH)-ADDR_SHIFT_AMOUNT-1:0] addr_b_word_s;

  /* Take slice of byte aligned addr to conver to the word aligned*/
  assign addr_a_word_s = addr_a_byte_in[RAM_ADDR_WIDTH-1:ADDR_SHIFT_AMOUNT];
  assign addr_b_word_s = addr_b_byte_in[RAM_ADDR_WIDTH-1:ADDR_SHIFT_AMOUNT];

  // The following code either initializes the memory values to a specified file
  // or to all zeros to match hardware
  generate
    
    if (INIT_FILE != "") begin: use_init_file

      initial begin
        $readmemh(INIT_FILE, sram_mem, 0, RAM_DEPTH-1);
      end
    
    end else begin: init_bram_to_zero
      
      integer ram_index;
      initial begin
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1) begin
          sram_mem[ram_index] = '0;
        end
      end

    end

  endgenerate

  always_ff @(posedge clk) begin
    if (we_a_in)
      sram_mem[addr_a_word_s] <= din_a_in;
    if (en_b_in)
      ram_data <= sram_mem[addr_b_word_s];
  end

  // removed output registers
  assign dout_b_out = ram_data;

endmodule