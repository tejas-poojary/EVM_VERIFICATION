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
endinterface
