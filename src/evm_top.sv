`include "evm_interface.sv"
`include "evm_package.sv"
`include "design.sv"
`include "uvm_macros.svh"

import uvm_pkg::*;
import evm_pkg::*;

module top();
  
  
  bit clk,rst;

 
  evm_interface  vif(clk,rst);
  evm DUT(
    .clk(clk),
    .rst(rst),
    .vote_candidate_1(vif.vote_candidate_1),
    .vote_candidate_2(vif.vote_candidate_2),
    .vote_candidate_3(vif.vote_candidate_3),
		.switch_on_evm(vif.switch_on_evm),
		.candidate_ready(vif.candidate_ready),
		.voting_session_done(vif.voting_session_done),
		.display_results(vif.display_results),
		.display_winner(vif.display_winner),
    
    //outputs
    .candidate_name(vif.candidate_name),
    .invalid_results(vif.invalid_results),
    .results(vif.results),
    .voting_in_progress(vif.voting_in_progress),
    .voting_done(vif.voting_done)
  );

  always #10  clk = ~clk;

  initial
  begin
    clk = 0;
    rst = 0;
    #10;
  
    rst = 1;
  end

  initial
  begin
    uvm_config_db #(virtual evm_interface)::set(uvm_root::get(),"*","evm_inf",vif);

    $dumpfile("dump.vcd");
    $dumpvars;
  end

  initial
  begin
    run_test("pure_maj_test");
    #100 $finish;
  end
 endmodule
