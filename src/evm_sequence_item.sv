class evm_sequence_item extends uvm_sequence_item;
  //inputs
  rand logic vote_candidate_1;
	rand logic vote_candidate_2;
	rand logic vote_candidate_3;
	rand logic switch_on_evm;
	rand logic candidate_ready;
	rand logic voting_session_done;
	rand logic [1:0]display_results;
	rand logic display_winner;

	//outputs
	logic [2:0]candidate_name;
	logic invalid_results;
  logic [7-1:0]results;
  logic voting_in_progress;
  logic voting_done;

  `uvm_object_utils_begin(evm_sequence_item)
		`uvm_field_int(vote_candidate_1, UVM_ALL_ON | UVM_DEC)
  	`uvm_field_int(vote_candidate_2, UVM_ALL_ON | UVM_DEC)
  	`uvm_field_int(vote_candidate_3, UVM_ALL_ON | UVM_DEC)
  	`uvm_field_int(switch_on_evm, UVM_ALL_ON | UVM_DEC)
  	`uvm_field_int(candidate_ready, UVM_ALL_ON | UVM_DEC)
  	`uvm_field_int(voting_session_done, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(display_results, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(display_winner, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(candidate_name, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(invalid_results, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(results, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(voting_in_progress, UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(voting_done, UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end

  function new(string name = "evm_sequence_item");
     super.new(name);
  endfunction
endclass
