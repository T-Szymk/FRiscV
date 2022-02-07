/******************************************************************************* 
 * Module   : reg_file_tb
 * Project  : FRiscV
 * Author   : Tom Szymkowiak
 * Mod. Date: 18-Dec-2021
 *******************************************************************************
 * Description:
 * ============
 * Test bench for the register file used within the FRiscV CPU.
 ******************************************************************************/

import friscv_pkg::*;

module reg_file_tb #(
    parameter CLK_PERIOD         = 10,
    parameter SIMULATION_RUNTIME = 100_000 // determine units from timescale or 
);                                         // timeunit


  timeunit 1ns/1ps;

  bit   clk;
  bit   dut_we;
  bit   [$clog2(REGFILE_DEPTH)-1:0] dut_addr_w; 
  bit   [$clog2(REGFILE_DEPTH)-1:0] dut_addr_r1; 
  bit   [$clog2(REGFILE_DEPTH)-1:0] dut_addr_r2;
  bit   [ARCH-1:0] dut_data_w; // write-back data input
  logic [ARCH-1:0] dut_data_r1; 
  logic [ARCH-1:0] dut_data_r2; 

  class TestData;

    rand bit we;
    rand bit [$clog2(REGFILE_DEPTH)-1:0] addr_w;
    rand bit [$clog2(REGFILE_DEPTH)-1:0] addr_r1;
    rand bit [$clog2(REGFILE_DEPTH)-1:0] addr_r2;
    rand bit [ARCH-1:0] data_w;
    // demonstration of how to constrain the randomisation
    constraint valid_addr {
      addr_w  <= REGFILE_DEPTH;
      addr_r1 <= REGFILE_DEPTH;
      addr_r2 <= REGFILE_DEPTH;
    }

  endclass // reg_file_test_data;
  
  always #(CLK_PERIOD/2) clk <= ~clk;

  reg_file i_reg_file (
    .clk(clk),
    .we(dut_we),
    .addr_w(dut_addr_w),
    .addr_r1(dut_addr_r1),
    .addr_r2(dut_addr_r2),
    .data_w(dut_data_w),
    .data_r1(dut_data_r1),
    .data_r2(dut_data_r2)
  );

  task ver_reg0;
    $info("Verifying that reading from r0 produces a 0.");
    dut_addr_w  = '0;
    dut_addr_r1 = '0;
    dut_addr_r2 = '0;
    dut_data_w  = 'hBEEF;
    dut_we = 1'b1;
    @(posedge clk) begin
      assert(dut_data_r1 == '0) else 
      $warning("ver_reg0 - r1, failed! Expected 0 from reg_file_mem[0] but got",
               " 0x%0x", dut_data_r1);
      assert(dut_data_r2 == '0) else 
      $warning("ver_reg0 - r2, failed! Expected 0 from reg_file_mem[0] but got",
               " 0x%0x", dut_data_r2);
    end
  endtask // ver_reg0

  task init_mem(TestData data);

    $info("Initialising register file with random values.");
    
    dut_we = 1'b1;
    for(int idx = 0; idx < REGFILE_DEPTH; idx++) begin
      data.randomize();
      dut_addr_w = idx;
      dut_data_w = data.data_w;
      @(posedge clk);
    end
  endtask // init_mem

  initial begin 
    
    static TestData data = new();
    {dut_we, dut_addr_w, dut_addr_r1, dut_addr_r2, dut_data_w} = '0;
    init_mem(data);
    
    ver_reg0();

    $info("Verifying random reads and writes to all register locations.");

    while ($time < SIMULATION_RUNTIME) begin : main_tb_loop
      data.randomize();
      
      dut_we      = data.we;
      dut_addr_w  = data.addr_w;
      dut_addr_r1 = data.addr_r1;
      dut_addr_r2 = data.addr_r2;
      dut_data_w  = data.data_w;
      
      @(posedge clk); 
      
      dut_addr_r1 = data.addr_w;
      dut_addr_r2 = data.addr_w;

      #1;
      /* Verify that the write has completed successfully and also that the read
         paths work as expected after the write*/
      if(data.we == 1'b1) begin
        if(data.addr_w == '0) begin
          assert((dut_data_r1 == '0) && (dut_data_r2 == '0)) else 
          $warning("verify r0 wr, failed! data.data_w: 0x%0x,\n", data.data_w, 
                   "dut_data_r1: 0x%0x,\n", dut_data_r1,
                   "dut_data_r2: 0x%0x", dut_data_r2);
        end else begin
          assert((dut_data_r1 == data.data_w) && 
                 (dut_data_r2 == data.data_w)) else 
          $warning("verify r+ wr, failed! data.data_w: 0x%0x,\n", data.data_w, 
                   "dut_data_r1: 0x%0x,\n", dut_data_r1,
                   "dut_data_r2: 0x%0x", dut_data_r2);
        end
      end

    end : main_tb_loop

    $info("Simulation Complete!");
    $finish;
  end

endmodule // reg_file_tb