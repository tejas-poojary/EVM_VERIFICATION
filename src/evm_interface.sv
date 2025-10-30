`include "uvm_macros.svh"
import uvm_pkg::*;
interface evm_interface #(parameter WIDTH = 7)(input logic clk,rst);
	//inputs
  logic vote_candidate_1;
	logic vote_candidate_2;
	logic vote_candidate_3;
	logic switch_on_evm;
	logic candidate_ready;
	logic voting_session_done;
	logic [1:0]display_results;
	logic display_winner;

	//outputs
	logic [2:0]candidate_name;
	logic invalid_results;
  logic [WIDTH-1:0]results;
  logic voting_in_progress;
  logic voting_done;

  clocking evm_driver_cb@(posedge clk);
    
		default input #0 output #0;
		output vote_candidate_1,vote_candidate_2,vote_candidate_3;
		output switch_on_evm,candidate_ready,voting_session_done,display_results,display_winner;
		input candidate_name,invalid_results,results,voting_in_progress,voting_done;
  endclocking

  clocking evm_monitor_cb@(posedge clk);
    
		default input #0 output #0;
		input vote_candidate_1,vote_candidate_2,vote_candidate_3;
		input switch_on_evm,candidate_ready,voting_session_done,display_results,display_winner;
		input candidate_name,invalid_results,results,voting_in_progress,voting_done;
  endclocking

  modport DRIVER (clocking evm_driver_cb, input clk);
  modport MONITOR (clocking evm_monitor_cb, input clk);

  property rst_check;
   (!rst)|=> ((candidate_name == 0) && !invalid_results && (results == 0) && !voting_in_progress && !voting_done);
  endproperty

  property switch_on_evm_check;
   @(posedge clk) disable iff(!rst)
    $fell(switch_on_evm)|=> ((candidate_name == 0) && !invalid_results && (results == 0) && !voting_in_progress && !voting_done);
  endproperty

  property voting_in_progress_check;
   @(posedge clk) disable iff(!rst)
    $rose(candidate_ready)|=> ##[0:$](vote_candidate_1 || vote_candidate_2 || vote_candidate_3) ##1 $fell(voting_in_progress)
  endproperty

  property invalid_check;
   @(posedge clk) disable iff(!rst)
    $rose(voting_session_done)|=>(invalid_results || !invalid_results);
  endproperty

  property invalid_result_clear_check;
   @(posedge clk) disable iff(!rst)
    !voting_session_done |=> !invalid_results;
  endproperty

  property candidate_name_00;
   @(posedge clk) disable iff(!rst)
    (display_results == 0 ) |-> (candidate_name == 1);
  endproperty

  property candidate_name_01;
   @(posedge clk) disable iff(!rst)
    (display_results == 1 ) |-> (candidate_name == 2);
  endproperty

  property candidate_name_10;
   @(posedge clk) disable iff(!rst)
     (display_results == 2 ) |-> (candidate_name == 3);
  endproperty

  //assert property(rst_check)
  //  else
  //  `uvm_info("RST_CHECK","Output signals are not in default during the reset",UVM_NONE)
  assert property(switch_on_evm_check)
   else
    `uvm_info("SWITCH_ON_EVM_CHECK","Output signals are not in default during the switch_on_evm is deasserted",UVM_NONE)

  assert property(voting_in_progress_check)
   else
    `uvm_info("VOTING_IN_PROGRESS_CHECK","voting_in_progress signal is  not deasserted when vote is casted",UVM_NONE)

  assert property(invalid_check)
   else
    `uvm_info("INVALID_CHECK","invalid_results signal is asserted when fsm is not in voting_process_done state",UVM_NONE)

  assert property(invalid_result_clear_check)
   else
    `uvm_info("INVALID_RESULT_CLEAR_CHECK","invalid_results signal is not cleared  when voting_session_done is deasserted",UVM_NONE)

  assert property(candidate_name_00)
   else
    `uvm_info("CANDIDATE_NAME_00","When display_result == 00 its not displaying candidate_1 id",UVM_NONE)

  assert property(candidate_name_01)
   else
    `uvm_info("CANDIDATE_NAME_01","When display_result == 01 its not displaying candidate_2 id",UVM_NONE)

  assert property(candidate_name_10)
   else
    `uvm_info("CANDIDATE_NAME_10","When display_result == 10 its not displaying candidate_3 id",UVM_NONE)
 
endinterface
