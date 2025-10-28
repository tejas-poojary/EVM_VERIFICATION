`uvm_analysis_imp_decl(_act_mon)
`uvm_analysis_imp_decl(_pas_mon)

`define vote_count_width 8 

typedef logic [`vote_count_width-1:0] vote_t; 

class evm_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(evm_scoreboard)
  uvm_analysis_imp#(evm_sequence_item, evm_scoreboard) act_mon_scb_imp;
  uvm_analysis_imp#(evm_sequence_item, evm_scoreboard) pas_mon_scb_imp;
  bit ready;
  int MISMATCH, MATCH; 
  
  virtual evm_interface vif;
  evm_sequence_item act_mon_q[$], pas_mon_q[$];
  static vote_t vote_candidate_1, vote_candidate_2, vote_candidate_3; // candidate vote count !
  vote_t vote [2:0]; // collective vote count for 3 candidate

  function new(string name ="evm_scoreboard", uvm_component parent =null);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual evm_interface)::get(this,"","vif",vif))
      `uvm_info(get_type_name(), "VIF not found!!", UVM_LOW))
    act_mon_scb_imp = new("act_mon_imp",this);
    pas_mon_scb_imp = new("pas_mon_imp",this);
  endfunction

  virtual function void write_act_mon(evm_sequence_item pack);
    $display("Scoreboard received from active monitor:: Packet");
    act_mon_q.push_back(pack);
  endfunction

  virtual function void write_pas_mon(evm_sequence_item pack);
    $display("Scoreboard received from passive monitor:: Packet");
    pas_mon__q.push_back(pack);
  endfunction

  virtual task run_phase();
    evm_sequence_item inp_seq, exp_out, act_out;
    forever begin
      wait(act_mon_q.size() > 0 && pas_mon_q.size() > 0);
      inp_seq = act_mon_q.pop_front();
      actual_out = pas_mon_q.pop_front();
      // ..... reference model to compare here .......
      evm_reference_model(inp_seq, exp_out);
      compare_exp_act_res(exp_out, act_out);
    end
  endtask

  task evm_reference_model(input  evm_sequence_item inp_seq,
                           output evm_sequence_item exp_out);
    // global
    if(inp_seq.switch_on_evm == 0) begin : EVM_SWITCH_OFF 
      // state = IDEL;
      vote_candidate_1 = 0; // internal counter to count the candidate votes
      vote_candidate_2 = 0;
      vote_candidate_3 = 0;
      // evm outputs ....
      exp_out.voting_in_progress = 0;
      exp_out.voting_done = 0;
      exp_out.invalid_result = 0;
      exp_out.results = 2'b00; // default
      exp_out.candidate_name = 2'b11; // default !!
      // ................
      ready = 0;
      return;
    end : EVM_SWITCH_OFF

    // Flag_ready for candidate_selection
    if(inp_seq.candidate_ready) begin
      ready = 1;
      exp_out.voting_in_progress = 1;
    end
    
    // vote_candidate_x
    if(~inp_seq.candidate_ready && ready && inp_seq.vote_candidate_1 && ~inp_seq.vote_candidate_2 && ~inp_seq.vote_candidate_3) begin
      vote_candidate_1++;
      ready = 0;
      exp_out.voting_in_progress = 0;
    end 
    else if(~inp_seq.candidate_ready && ready && ~inp_seq.vote_candidate_1 && inp_seq.vote_candidate_2 && ~inp_seq.vote_candidate_3) begin
      vote_candidate_2++;
      ready = 0;
      exp_out.voting_in_progress = 0;
    end
    else if(~inp_seq.candidate_ready && ready && ~inp_seq.vote_candidate_1 && ~inp_seq.vote_candidate_2 && inp_seq.vote_candidate_3)
      vote_candidate_3++;
      ready = 0;
      exp_out.voting_in_progress = 0;
    end
    
    // voting_session_done
    if(inp_seq.voting_session_done) begin
      exp_out.voting_done = 1;
    end
    
    vote = '{vote_candidate_1, vote_candidate_2, vote_candidate_3};
    vote.sort(); // sort it so we can compare further
    // Display winner x Display result 
    if(inp_seq.voting_session_done && inp_seq.display_winner) begin
      if(vote[1] == vote[2]) 
        exp_out.invalid_result = 1;
      else if(vote[2] > vote[1]) begin
        exp_out.results = vote[2];
        exp_out.candidate_name = (vote[2] == vote_candidate_1)? 2'b01 :
                       (vote[2] == vote_candidate_2)? 2'b10 : 2'b11;
      end
    end
    else if(inp_seq.voting_session_done) begin
      if(inp_seq.display_results == 2'b00) begin
        exp_out.candidate_name = 2'b01; // first candidate_name
        exp_out.result = vote_candidate_1; // first candidate_result
      end
      else if(inp_seq.display_results == 2'b01) begin
        exp_out.candidate_name = 2'b10; // second candidate_name
        exp_out.result = vote_candidate_1; // second candidate_result
      end
      else if(inp_seq.display_results == 2'b10) begin
        exp_out.candidate_name = 2'b11; // third candidate_name
        exp_out.result = vote_candidate_1; // third candidate_result
      end
    end
  endtask
  
  task compare_exp_act_res(input  evm_sequence_item exp_out,
                           input evm_sequence_item act_out);
    
    if(exp_out.voting_in_progress == act_out.voting_in_progress) 
      `uvm_info(get_type_name(), "VOTING_IN_PROGRESS HAS MATCHED", UVM_LOW);
    else 
      `uvm_info(get_type_name(), "VOTING_IN_PROGRESS HAS MISMATCHED", UVM_LOW);
    
    if(exp_out.voting_done == act_out.voting_done) 
      `uvm_info(get_type_name(), "VOTING_DONE HAS MATCHED", UVM_LOW);
    else 
      `uvm_info(get_type_name(), "VOTING_DONE HAS MISMATCHED", UVM_LOW);
    
    if(exp_out.invaild_result == act_out.invalid_result) 
      `uvm_info(get_type_name(), "INVALID_RESULT HAS MATCHED", UVM_LOW);
    else 
      `uvm_info(get_type_name(), "INVALID_RESULT HAS MISMATCHED", UVM_LOW);
    
    if(exp_out.results == act_out.results) 
      `uvm_info(get_type_name(), "RESULTS HAS MATCHED", UVM_LOW);
    else 
      `uvm_info(get_type_name(), "RESULTS HAS MISMATCHED", UVM_LOW);
    
    if(exp_out.candidate_name == act_candidate_name) 
      `uvm_info(get_type_name(), "CANDIDATE_NAME HAS MATCHED", UVM_LOW);
    else 
      `uvm_info(get_type_name(), "CANDIDATE_NAME HAS MISMATCHED", UVM_LOW);
    
    if(exp_out.compare(act_out)) begin
      MATCH++;
      `uvm_info(get_full_name(), "MATCH", UVM_LOW)
    end
    else begin
      MISMATCH++;
      `uvm_info(get_full_name(), "MISMATCH", UVM_LOW)
    end
    
  endtask

  function void report_phase(uvm_phase phase) begin
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("TOTAL: \nMATCH : %0d  | MISMATCH : %0d", MATCH, MISMATCH), UVM_LOW)
  end
endclass
