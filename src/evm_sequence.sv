class evm_sequence extends uvm_sequence #(evm_sequence_item);

	`uvm_object_utils(evm_sequence)

	evm_sequence_item seq_item;

	function new(string name = "evm_sequence");
		super.new(name);
	endfunction

	virtual task body();
			req = evm_sequence_item::type_id::create("req");
			wait_for_grant();
			req.randomize();
			send_request(req);
			wait_for_item_done();
	endtask
endclass


class rand_seq extends uvm_sequence #(evm_sequence_item); 
	`uvm_object_utils(rand_seq)

	function new(string name = "rand_seq");
		super.new(name);
	endfunction

	virtual task body();
		`uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});
		
		repeat(100)begin
		  `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;});
	          `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} inside {0, 1, 2, 4};req.voting_session_done == 0;});
		end
		`uvm_do_with(req, {req.voting_session_done ==1;req.display_result inside {[0:2]};});
		`uvm_do_with(req, {req.voting_session_done ==1;req.display_winner == 1;});	

	endtask
endclass



class pure_maj_seq extends uvm_sequence #(evm_sequence_item); 
	`uvm_object_utils(pure_maj_seq)
	function new(string name = "pure_maj_seq");
		super.new(name);
	endfunction
	virtual task body();
       `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});
		repeat(100)begin
		`uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;});
          	`uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} dist {0:=10, 1:=70, 2:=10, 4:=10};req.voting_session_done == 0;});
		end
		`uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==1;req.display_result inside {[0:2]};});
		`uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==1;req.display_winner == 1;});	
	endtask
endclass


class top_2tie_seq extends uvm_sequence #(evm_sequence_item); 
	`uvm_object_utils(top_2tie_seq)
    bit candidate_selection;
	function new(string name = "top_2tie_seq");
		super.new(name);
	endfunction

	virtual task body();
		`uvm_do_with(req, {req.switch_on_evm ==1;voting_session_done == 0;});
        
		repeat(100)begin
			`uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;voting_session_done == 0;};
		  	`uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;
		                     (candidate_selection) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 1;
		                     (!candidate_selection) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 2;req.voting_session_done == 0;});
		  	candidate_selection = ~candidate_selection;
		end
		`uvm_do_with(req, {req.voting_session_done ==1;req.display_result inside {[0:2]};});
		`uvm_do_with(req, {req.voting_session_done ==1;req.display_winner == 1;});	

	endtask
endclass
                     
class bottom_Two_tie_seq extends uvm_sequence #(evm_sequence_item); 
	`uvm_object_utils(bottom_Two_tie_seq)
   	bit[1:0] count;
	function new(string name = "bottom_Two_tie_seq");
		super.new(name);
	endfunction
	virtual task body();
       `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});
       
		repeat(100)begin
			`uvm_do_with(req,{req.switch_on_evm ==1;req.candidate_ready == 1;req.voting_session_done ==0;});
		  	`uvm_do_with(req, {req.candidate_ready ==0;
		                     (count %2 == 0) - > ({req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 1);
		                     (count == 1) - > ({req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 2);
		                     (count == 3) - > ({req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 4);
		                     req.voting_session_done == 0;});
		  	count++;
		end
		`uvm_do_with(req, {req.voting_session_done ==1;req.display_result inside {[0:2]};});
		`uvm_do_with(req, {req.voting_session_done ==1;req.display_winner == 1;});	
	endtask
endclass                     
                     
class all_3tie_seq extends uvm_sequence #(evm_sequence_item); 
	`uvm_object_utils(all_3tie_seq)
    bit [1:0]candidate_selection;
	function new(string name = "all_3tie_seq");
		super.new(name);
	endfunction

	virtual task body();
      	`uvm_do_with(req, {req.switch_on_evm ==1;voting_session_done == 0;});
        
        repeat(99)begin
	  `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;voting_session_done == 0;};
          `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;
                             (candidate_selection == 0) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 1;
                             (candidate_selection == 1) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 2;
                             (candidate_selection == 2) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 4;req.voting_session_done == 0;voting_session_done == 0;});
          candidate_selection++;
          if(candidate_selection == 3) candidate_selection = 0;
		end
		`uvm_do_with(req, {req.voting_session_done ==1;req.display_result inside {[0:2]};});
		`uvm_do_with(req, {req.voting_session_done ==1;req.display_winner == 1;});	

	endtask
endclass                  
                     
                     
 
class fsm_hang_in_waiting_for_candidate_seq extends uvm_sequence #(evm_sequence_item); 
	`uvm_object_utils(fsm_hang_in_waiting_for_candidate_seq)
	function new(string name = "fsm_hang_in_waiting_for_candidate_seq");
		super.new(name);
	endfunction
	virtual task body();
      `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});
      repeat(10)begin
      `uvm_do_with(req,{req.switch_on_evm ==1;req.candidate_ready == 0;req.voting_session_done ==0;});
      end
	endtask
endclass
 
class fsm_hang_in_waiting_for_candidate_to_vote_seq extends uvm_sequence #(evm_sequence_item); 
  `uvm_object_utils(fsm_hang_in_waiting_for_candidate_to_vote_seq)
  function new(string name = "fsm_hang_in_waiting_for_candidate_to_vote_seq");
		super.new(name);
	endfunction
	virtual task body();
      `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});
      `uvm_do_with(req,{req.switch_on_evm ==1;req.candidate_ready == 1;req.voting_session_done ==0;});
      repeat(10)begin
        `uvm_do_with(req,{req.switch_on_evm ==1;req.candidate_ready == 1;req.voting_session_done ==0;
                          {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 0;});
      end
	endtask
endclass






                     

