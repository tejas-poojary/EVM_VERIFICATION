`uvm_analysis_imp_decl(_act_mon)
`uvm_analysis_imp_decl(_pas_mon)

typedef bit [`WIDTH-1:0] vote_t;

class evm_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(evm_scoreboard)
  uvm_analysis_imp_act_mon#(evm_sequence_item, evm_scoreboard) act_mon_scb_imp;
  uvm_analysis_imp_pas_mon#(evm_sequence_item, evm_scoreboard) pass_mon_scb_imp;
  //used to control assertion and deassertion of candidate_ready
  bit ready;
  //to count matches and mismatches
  int MISMATCH, MATCH;
  //To store multiple candidates votes used for winner selection
  vote_t temp_votes[$];
  //to map the candidates_votes with their index
  int idx_map[$];

  bit counter1_flag, counter2_flag;

  //To push multiple votes to the queue
  vote_t vote[`NUM_CANDIDATES];
  //counters for timing control in 2 states
  static int candidate_ready_count,waiting_for_candidate_to_vote_count;
  virtual evm_interface vif;
  //queues to collect the sequence item from both moitors
  evm_sequence_item act_mon_q[$], pas_mon_q[$];
  //counters to collect the votes
  static vote_t vote_candidate_1, vote_candidate_2, vote_candidate_3;

  function new(string name ="evm_scoreboard", uvm_component parent =null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual evm_interface)::get(this,"","vif",vif))
      `uvm_info(get_type_name(), "VIF not found!!", UVM_LOW)
    act_mon_scb_imp = new("act_mon_imp",this);
    pass_mon_scb_imp = new("pass_mon_imp",this);
  endfunction

  virtual function void write_act_mon(evm_sequence_item pack);
    $display("Scoreboard received from active monitor:: Packet");
    act_mon_q.push_back(pack);
  endfunction

  virtual function void write_pas_mon(evm_sequence_item pack);
    $display("Scoreboard received from passive monitor:: Packet");
    pas_mon_q.push_back(pack);
  endfunction

  task run_phase(uvm_phase phase);
    evm_sequence_item inp_seq, exp_out, act_out;
    exp_out=evm_sequence_item::type_id::create("exp_out");
    forever begin
      wait(act_mon_q.size() > 0 && pas_mon_q.size() > 0);
      inp_seq = act_mon_q.pop_front();
      act_out = pas_mon_q.pop_front();
      // ..... reference model to compare here .......
      evm_reference_model(inp_seq, exp_out);
      compare_exp_act_res(exp_out, act_out);
    end
  endtask

  task evm_reference_model(input  evm_sequence_item inp_seq,
                           ref evm_sequence_item exp_out);
    //to store the index of the candidate with maximum votes
        int max_idx;
    //maximum votes
        vote_t max_val;
    //to calculate tie conditions
      bit tie;
    if(inp_seq.switch_on_evm == 0)
     begin : EVM_SWITCH_OFF
      // state = IDLE;
      vote_candidate_1 = 0; // internal counter to count the candidate votes
      vote_candidate_2 = 0;
      vote_candidate_3 = 0;
      // evm outputs ....
      //exp_out.voting_in_progress = 0;
      //exp_out.voting_done = 0;
      exp_out.invalid_results = 0;
      exp_out.results = 0; // default
      exp_out.candidate_name = 2'b00; // default !!
      // ................
      ready = 0;
      counter1_flag = 0;
      counter2_flag = 0;
    end : EVM_SWITCH_OFF

    else begin
       // Flag_ready for candidate_selection
      if(inp_seq.candidate_ready)begin:candidate_ready
         ready=1;    //indicates that we have moved from waiting_for_candidate to waiting_for_candidate_to_vote state
         candidate_ready_count = 0;
         counter2_flag = 0;
     end
       else begin
         if(!ready && !inp_seq.candidate_ready)
         candidate_ready_count++;
       end

        // vote_candidate_x
        if(~inp_seq.candidate_ready && ready && inp_seq.vote_candidate_1)begin
           waiting_for_candidate_to_vote_count=0;
           vote_candidate_1++;
           ready = 0;
         end
        else if(~inp_seq.candidate_ready && ready && inp_seq.vote_candidate_2 )begin
           waiting_for_candidate_to_vote_count=0;
           vote_candidate_2++;
           ready = 0;
         end
        else if(~inp_seq.candidate_ready && ready && inp_seq.vote_candidate_3)begin
           waiting_for_candidate_to_vote_count=0;
           vote_candidate_3++;
           ready = 0;
         end
        else if(ready && ~inp_seq.candidate_ready)begin
           waiting_for_candidate_to_vote_count++;
         end
       end

    $display("candidate_1_vote=%0d ||candidate_2_vote=%0d ||candidate_3_vote=%0d",vote_candidate_1,vote_candidate_2,vote_candidate_3);

  temp_votes.delete();
  idx_map.delete();
  tie = 0;

  vote = '{vote_candidate_1, vote_candidate_2, vote_candidate_3};
  for (int i = 0; i < `NUM_CANDIDATES; i++) begin
    temp_votes.push_back(vote[i]);
    idx_map.push_back(i);
  end
  // Find max and check tie in one pass
  max_val = temp_votes[0];

  for (int i = 1; i < temp_votes.size(); i++) begin
    if (temp_votes[i] > max_val) begin
      max_val = temp_votes[i];
      max_idx = i;
      tie = 0;
    end
    else if (temp_votes[i] == max_val) begin
      tie = 1;
    end
  end
 $display("tie = %0d",tie);

// ----------------------
// Decide final result
// ----------------------
  if ((inp_seq.voting_session_done && inp_seq.display_winner && inp_seq.switch_on_evm) ||
      (counter1_flag && inp_seq.display_winner && inp_seq.switch_on_evm)) begin
    if (tie)begin
     exp_out.invalid_results = 1;
     exp_out.results = 0;
     exp_out.candidate_name = 0;
      counter1_flag = 0;
 end
   else begin
     counter1_flag = 0;
     exp_out.invalid_results = 0;
     exp_out.results = max_val;
     exp_out.candidate_name = idx_map[max_idx] + 1; // Candidate index ? name
   end
end
// ----------------------
// Display individual results
// ----------------------
  else if (inp_seq.voting_session_done && inp_seq.switch_on_evm) begin
  if(tie)begin
       exp_out.invalid_results = 1;
       exp_out.results = 0;
       exp_out.candidate_name = 0;

  end
  else begin
    exp_out.candidate_name = (inp_seq.display_results) +1;
    exp_out.results = vote[inp_seq.display_results];
end
end
  $display("candidate_ready_count = %0d || waiting_for_candidate_to_count = %0d",candidate_ready_count,waiting_for_candidate_to_vote_count);
     if(candidate_ready_count==100)
      begin
        candidate_ready_count=0;
        counter1_flag = 1;
      end

     if(waiting_for_candidate_to_vote_count==100)
      begin
       waiting_for_candidate_to_vote_count=0;
       ready=0;
       counter2_flag = 1;
      end
endtask

task compare_exp_act_res(input  evm_sequence_item exp_out,input evm_sequence_item act_out);
    bit match_flag = 1;
    if(exp_out.invalid_results === act_out.invalid_results)
      `uvm_info(get_type_name(), $sformatf("INVALID_RESULT HAS MATCHED\n exp : %0d | act : %0d ",exp_out.invalid_results,act_out.invalid_results), UVM_LOW)
  else begin
      `uvm_info(get_type_name(), $sformatf("INVALID_RESULT HAS MISMATCHED\n exp : %0d | act : %0d ",exp_out.invalid_results,act_out.invalid_results), UVM_LOW)
match_flag = 0;
end
    if(exp_out.results === act_out.results)
      `uvm_info(get_type_name(), $sformatf("RESULTS HAS MATCHED\n exp : %0d | act : %0d",exp_out.results,act_out.results), UVM_LOW)
  else begin
      `uvm_info(get_type_name(), $sformatf("RESULTS HAS MISMATCHED\n exp : %0d | act : %0d",exp_out.results,act_out.results), UVM_LOW)
    match_flag = 0;
end
    if(exp_out.candidate_name === act_out.candidate_name)
      `uvm_info(get_type_name(), $sformatf("CANDIDATE_NAME HAS MATCHED\n exp : %0d | act : %0d",exp_out.candidate_name,act_out.candidate_name), UVM_LOW)
  else begin
      `uvm_info(get_type_name(), $sformatf("CANDIDATE_NAME HAS MISMATCHED\n exp : %0d | act : %0d",exp_out.candidate_name,act_out.candidate_name), UVM_LOW)
    match_flag = 0;
end
    if(match_flag)
     begin
      MATCH++;
      `uvm_info(get_full_name(), "MATCH", UVM_LOW)
     end
    else
     begin
      MISMATCH++;
      `uvm_info(get_full_name(), "MISMATCH", UVM_LOW)
     end

  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("TOTAL: \nMATCH : %0d  | MISMATCH : %0d", MATCH, MISMATCH), UVM_LOW)
  endfunction

endclass


