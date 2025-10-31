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

   repeat(100)
    begin
     `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;req.voting_session_done == 0;});
     `uvm_do_with(req,{req.switch_on_evm==1;req.voting_session_done==0;req.candidate_ready dist {0:=70,1:=30};{req.vote_candidate_1,req.vote_candidate_2,req.vote_candidate_3} dist {4:=15,2:=15,1:=15,6:=15,3:=15,5:=15,7:=10};});

    end
     `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;req.candidate_ready ==0;req.display_results inside {[0:2]};});
     `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 1;req.display_results inside{[0:2]};});
     `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results inside{[0:3]};});
     `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results ==3;});
     `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results ==1;});
     `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results ==2;});
     `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results ==0;});
     `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
     `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
 endtask
endclass

class pure_maj_seq extends uvm_sequence #(evm_sequence_item);
 `uvm_object_utils(pure_maj_seq)

 function new(string name = "pure_maj_seq");
  super.new(name);
 endfunction

 virtual task body();
   `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});
    repeat(500)
     begin
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} dist {0:=0, 1:=50, 2:=40, 4:=10};req.voting_session_done == 0;});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} dist {0:=0, 1:=50, 2:=40, 4:=10};req.voting_session_done == 0;});
     end
      `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;req.candidate_ready ==0;req.display_results inside {[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 1;req.display_results inside{[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results inside{[0:3]};});
      `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
  endtask
endclass

class top_2tie_seq1 extends uvm_sequence #(evm_sequence_item);
  `uvm_object_utils(top_2tie_seq1)
   bit candidate_selection;

   function new(string name = "top_2tie_seq1");
    super.new(name);
   endfunction

   virtual task body();
    `uvm_do_with(req, {req.switch_on_evm ==1;voting_session_done == 0;});

     repeat(20)
      begin
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;voting_session_done == 0;});
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;(candidate_selection) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 1;(!candidate_selection) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 2;req.voting_session_done == 0;});
       candidate_selection = ~candidate_selection;
      end
       `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;req.candidate_ready ==0;req.display_results inside {[0:2]};});
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 1;req.display_results inside{[0:2]};});
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results inside{[0:3]};});
        `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    endtask
endclass

class top_2tie_seq2 extends uvm_sequence #(evm_sequence_item);
  `uvm_object_utils(top_2tie_seq2)
   bit candidate_selection;

   function new(string name = "top_2tie_seq2");
    super.new(name);
   endfunction

   virtual task body();
    `uvm_do_with(req, {req.switch_on_evm ==1;voting_session_done == 0;});

     repeat(20)
      begin
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;voting_session_done == 0;});
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;(candidate_selection) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 4;(!candidate_selection) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 1;req.voting_session_done == 0;});
       candidate_selection = ~candidate_selection;
      end
       `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;req.candidate_ready ==0;req.display_results inside {[0:2]};});
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 1;req.display_results inside{[0:2]};});
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results inside{[0:3]};});
        `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    endtask
endclass

class top_2tie_seq3 extends uvm_sequence #(evm_sequence_item);
  `uvm_object_utils(top_2tie_seq3)
   bit candidate_selection;

   function new(string name = "top_2tie_seq3");
    super.new(name);
   endfunction

   virtual task body();
    `uvm_do_with(req, {req.switch_on_evm ==1;voting_session_done == 0;});

     repeat(20)
      begin
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;voting_session_done == 0;});
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;(candidate_selection) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 2;(!candidate_selection) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 4;req.voting_session_done == 0;});
       candidate_selection = ~candidate_selection;
      end
       `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;req.candidate_ready ==0;req.display_results inside {[0:2]};});
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 1;req.display_results inside{[0:2]};});
       `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results inside{[0:3]};});
        `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    endtask
endclass

class bottom_Two_tie_seq1 extends uvm_sequence #(evm_sequence_item);
  `uvm_object_utils(bottom_Two_tie_seq1)
   bit[1:0] count;

  function new(string name = "bottom_Two_tie_seq1");
    super.new(name);
  endfunction

  virtual task body();
   `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});

    repeat(20)
     begin
      `uvm_do_with(req,{req.switch_on_evm ==1;req.candidate_ready == 1;req.voting_session_done ==0;});
      `uvm_do_with(req, {req.switch_on_evm==1;req.candidate_ready ==0;(count %2 == 0) -> ({req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 4);(count == 1) -> ({req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 1);(count == 3) -> ({req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 2);req.voting_session_done == 0;});
      count++;
     end
      `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;req.candidate_ready ==0;req.display_results inside {[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 1;req.display_results inside{[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results inside{[0:3]};});
      `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
  endtask
endclass

class bottom_Two_tie_seq2 extends uvm_sequence #(evm_sequence_item);
  `uvm_object_utils(bottom_Two_tie_seq2)
   bit[1:0] count;

  function new(string name = "bottom_Two_tie_seq2");
    super.new(name);
  endfunction

  virtual task body();
   `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});

    repeat(20)
     begin
      `uvm_do_with(req,{req.switch_on_evm ==1;req.candidate_ready == 1;req.voting_session_done ==0;});
      `uvm_do_with(req, {req.switch_on_evm==1;req.candidate_ready ==0;(count %2 == 0) -> ({req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 1);(count == 1) -> ({req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 2);(count == 3) -> ({req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 4);req.voting_session_done == 0;});
      count++;
     end
      `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;req.candidate_ready ==0;req.display_results inside {[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 1;req.display_results inside{[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results inside{[0:3]};});
      `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
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

   repeat(18)
    begin
     `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;voting_session_done == 0;});
     `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;(candidate_selection == 0) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 1;(candidate_selection == 1) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 2;(candidate_selection == 2) -> {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 4;req.voting_session_done == 0;voting_session_done == 0;});
   candidate_selection++;
      if(candidate_selection == 3) candidate_selection = 0;
    end
     `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;req.candidate_ready ==0;req.display_results inside {[0:2]};});
     `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 1;req.display_results inside{[0:2]};});
     `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results inside{[0:3]};});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
  endtask
endclass

class fsm_timeout_in_waiting_for_candidate_seq extends uvm_sequence #(evm_sequence_item);
 `uvm_object_utils(fsm_timeout_in_waiting_for_candidate_seq)

 function new(string name = "fsm_timeout_in_waiting_for_candidate_seq");
   super.new(name);
 endfunction

 virtual task body();
   `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});
    repeat(107)
     begin
      `uvm_do_with(req,{req.switch_on_evm ==1;req.candidate_ready == 0;req.voting_session_done ==0;});
      end
      `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;req.candidate_ready ==0;req.display_results inside {[0:2]};});
           `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 1;req.display_results inside{[0:2]};});
                `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results inside{[0:3]};});
`uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
endtask
endclass

class fsm_timeout_in_waiting_for_candidate_to_vote_seq extends uvm_sequence #(evm_sequence_item);
  `uvm_object_utils(fsm_timeout_in_waiting_for_candidate_to_vote_seq)

 function new(string name = "fsm_timeout_in_waiting_for_candidate_to_vote_seq");
   super.new(name);
 endfunction

 virtual task body();
   `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});
   `uvm_do_with(req,{req.switch_on_evm ==1;req.candidate_ready == 1;req.voting_session_done ==0;});
    repeat(100)
     begin
      `uvm_do_with(req,{req.switch_on_evm ==1;req.candidate_ready == 0;req.voting_session_done ==0;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 0;});
     end
      `uvm_do_with(req,{req.switch_on_evm ==1;req.candidate_ready == 0;req.voting_session_done ==0;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} == 0;});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==0;req.display_winner == 1;req.display_results inside{[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==0;req.display_winner == 0;req.display_results inside{[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});                                     `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
   endtask
endclass

class max_count_seq extends uvm_sequence #(evm_sequence_item);
 `uvm_object_utils(max_count_seq)

  function new(string name = "max_count_seq");
   super.new(name);
  endfunction

  virtual task body();
   `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});
    repeat(20)
     begin
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3}==1;req.voting_session_done == 0;});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} ==1;req.voting_session_done == 0;});
     end
      `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;req.candidate_ready ==0;req.display_results inside {[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 1;req.display_results inside{[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results inside{[0:3]};});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
   endtask
endclass

class multiple_candidate_selection_seq extends uvm_sequence #(evm_sequence_item);
 `uvm_object_utils(multiple_candidate_selection_seq)

 function new(string name = "multiple_candidate_selection_seq");
  super.new(name);
 endfunction

 virtual task body();
  `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;});
   repeat(20)
    begin
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3}==3;req.voting_session_done == 0;});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} ==3;req.voting_session_done == 0;});
    end
      `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done ==0;req.candidate_ready ==0;req.display_results inside {[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 1;req.display_results inside{[0:2]};});
      `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;req.voting_session_done ==1;req.display_winner == 0;req.display_results inside{[0:3]};});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
    `uvm_do_with(req, {req.switch_on_evm ==0;req.candidate_ready ==0;req.voting_session_done ==0;});
  endtask
endclass


class different_state_trans_seq extends uvm_sequence #(evm_sequence_item);
 `uvm_object_utils(different_state_trans_seq)

 function new(string name = "different_state_trans_seq");
  super.new(name);
 endfunction

 virtual task body();
        $display("nav bandeva");
  `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done == 0;});
  `uvm_do_with(req, {req.switch_on_evm ==0;req.voting_session_done == 0;});
  `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done == 0;});
  `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;req.voting_session_done == 0;});
  `uvm_do_with(req, {req.switch_on_evm ==0;req.voting_session_done == 0;});
  `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done == 0;});
  `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;req.voting_session_done == 0;});
  `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} ==3;req.voting_session_done == 0;});
  `uvm_do_with(req, {req.switch_on_evm ==0;req.voting_session_done == 0;});
   `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;req.voting_session_done == 0;});
  `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==1;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} ==3;req.voting_session_done == 0;});
  `uvm_do_with(req, {req.switch_on_evm ==1;req.candidate_ready ==0;{req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} ==3;req.voting_session_done == 0;});
  `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done == 0s;req.candidate_ready==0;req.display_winner==0;req.display_results == 3;});
  `uvm_do_with(req, {req.switch_on_evm ==1;req.voting_session_done == 1;req.candidate_ready==0;req.display_winner==0;req.display_results == 3;});
  `uvm_do_with(req, {req.switch_on_evm ==0;});
 endtask
endclass

class third_cand_maj_seq extends uvm_sequence #(evm_sequence_item);
 `uvm_object_utils(third_cand_maj_seq)

 function new(string name = "third_cand_maj_seq");
  super.new(name);
 endfunction

 virtual task body();
   `uvm_do_with(req, {req.switch_on_evm ==1; req.voting_session_done ==0;});
   repeat(100) begin
      `uvm_do_with(req, {req.switch_on_evm ==1; req.candidate_ready ==1; {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} dist {1:=10, 2:=40, 4:=80}; req.voting_session_done ==0;});
      `uvm_do_with(req, {req.switch_on_evm ==1; req.candidate_ready ==0; {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} dist {1:=10, 2:=40, 4:=80}; req.voting_session_done ==0;});
   end
   `uvm_do_with(req, {req.switch_on_evm ==1; req.voting_session_done ==0; req.candidate_ready ==0; req.display_results inside {[0:2]};});
   `uvm_do_with(req, {req.switch_on_evm ==1; req.candidate_ready ==0; req.voting_session_done ==1; req.display_winner ==1; req.display_results inside {[0:2]};});
   `uvm_do_with(req, {req.switch_on_evm ==1; req.candidate_ready ==0; req.voting_session_done ==1; req.display_winner ==0; req.display_results inside {[0:3]};});
   `uvm_do_with(req, {req.switch_on_evm ==1; req.voting_session_done ==1; req.display_winner ==1; req.display_results ==2;});
   `uvm_do_with(req, {req.switch_on_evm ==0; req.candidate_ready ==0; req.voting_session_done ==0;});
endtask

endclass

class sec_cand_maj_seq extends uvm_sequence #(evm_sequence_item);
 `uvm_object_utils(sec_cand_maj_seq)

 function new(string name = "sec_cand_maj_seq");
  super.new(name);
 endfunction

 virtual task body();
   `uvm_do_with(req, {req.switch_on_evm ==1; req.voting_session_done ==0;});
   repeat(100) begin
      `uvm_do_with(req, {req.switch_on_evm ==1; req.candidate_ready ==1; {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} ==2; req.voting_session_done ==0;});
      `uvm_do_with(req, {req.switch_on_evm ==1; req.candidate_ready ==0; {req.vote_candidate_1, req.vote_candidate_2, req.vote_candidate_3} ==2; req.voting_session_done ==0;});
   end
   `uvm_do_with(req, {req.switch_on_evm ==1; req.voting_session_done ==0; req.candidate_ready ==0; req.display_results inside {[0:2]};});
   `uvm_do_with(req, {req.switch_on_evm ==1; req.candidate_ready ==0; req.voting_session_done ==1; req.display_winner ==1; req.display_results inside {[0:2]};});
   `uvm_do_with(req, {req.switch_on_evm ==1; req.candidate_ready ==0; req.voting_session_done ==1; req.display_winner ==0; req.display_results inside {[0:3]};});
   `uvm_do_with(req, {req.switch_on_evm ==1; req.voting_session_done ==1; req.display_winner ==1; req.display_results ==2;});
   `uvm_do_with(req, {req.switch_on_evm ==0; req.candidate_ready ==0; req.voting_session_done ==0;});
endtask

endclass

class maj_regression_seq extends uvm_sequence #(evm_sequence_item);
 `uvm_object_utils(maj_regression_seq)

  pure_maj_seq seq1;
  top_2tie_seq1 seq2;
  bottom_Two_tie_seq1 seq3;
  all_3tie_seq seq4;
  fsm_timeout_in_waiting_for_candidate_seq seq5;
  fsm_timeout_in_waiting_for_candidate_to_vote_seq seq6;
  multiple_candidate_selection_seq seq7;
  max_count_seq seq8;
  rand_seq seq9;
  different_state_trans_seq seq10;
  third_cand_maj_seq seq11;
  sec_cand_maj_seq seq12;
  top_2tie_seq2 seq13;
  top_2tie_seq3 seq14;
  bottom_Two_tie_seq2 seq15;

 function new(string name = "maj_regression_seq");
  super.new(name);
 endfunction

 virtual task body();
  `uvm_do(seq1);
  `uvm_do(seq2);
  `uvm_do(seq13);
  `uvm_do(seq14);
  `uvm_do(seq3);
  `uvm_do(seq15);
  `uvm_do(seq4);
  `uvm_do(seq5);
  `uvm_do(seq6);
  `uvm_do(seq7);
  `uvm_do(seq8);
  `uvm_do(seq9);
  `uvm_do(seq10);
  `uvm_do(seq11);
  `uvm_do(seq12);
  //`uvm_do(seq5);
 endtask
endclass

