`include "evm_.sv"
`include "afifo_pkg.sv"
`include "design.sv"
//`include "uvm_macros.svh"

import uvm_pkg::*;
import afifo_pkg::*;

module top();
  
  localparam DSIZE = 8;
  localparam ASIZE = 4;
  
  bit wclk, rclk, wrst_n, rrst_n;

 
  afifo_if  vif(rclk, wclk, rrst_n, wrst_n);

  FIFO DUT(
    .wclk(wclk),
    .wrst_n(wrst_n),
    .wdata  (vif.wdata),
    .winc  (vif.winc),
    .wfull  (vif.wfull),
    
    .rclk(rclk),
    .rrst_n (rrst_n),
    .rdata  (vif.rdata),
    .rinc  (vif.rinc),
    .rempty (vif.rempty)
  );

  always #10  wclk = ~wclk;
  always #20  rclk = ~rclk;

  initial
  begin
    wclk = 0;
    rclk = 0;
    vif.winc=0;
    vif.rinc=0;
    wrst_n = 0;
    rrst_n = 0;
    #10;
    wrst_n = 1;
    rrst_n = 1;
  end

  initial
  begin
    uvm_config_db #(virtual afifo_if)::set(uvm_root::get(),"*","vif",vif);

    $dumpfile("dump.vcd");
    $dumpvars;
  end

  initial
  begin
    run_test("test1");
    #100 $finish;
  end
 endmodule
