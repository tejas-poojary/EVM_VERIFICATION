`uvm_analysis_imp_decl(_pas_mon)

class evm_subscriber extends uvm_subscriber#(evm_sequence_item);

`uvm_component_utils(evm_subscriber)

uvm_analysis_imp_pas_mon#(evm_sequence_item, evm_subscriber) pas_mon_export;

evm_sequence_item act_item;
evm_sequence_item pas_item;

real active_cov, passive_cov;

covergroup act_mon_cov;
option.per_instance = 1;
VOTE_CANDIDATE_1_CHECK : coverpoint act_item.vote_candidate_1 { bins cand1[] = {0, 1};}
VOTE_CANDIDATE_2_CHECK : coverpoint act_item.vote_candidate_2 { bins cand2[] = {0, 1};}
VOTE_CANDIDATE_3_CHECK : coverpoint act_item.vote_candidate_3 { bins cand3[]  = {0, 1};}
SWITCH_ON_EVM_CHECK : coverpoint act_item.switch_on_evm { bins switch_on_evm[] = {0,1}; }
CANDIDATE_READY_CHECK : coverpoint act_item.candidate_ready { bins candidate_ready[] = {0,1}; }
VOTING_SESSION_DONE_CHECK : coverpoint act_item.voting_session_done { bins voting_session_done[] = {0,1}; }
DISPLAY_RESULT_CHECK : coverpoint act_item.display_results { bins display_result[] = {[0:3]};
DISPLAY_WINNER_CHECK : coverpoint act_item.display_winner { bins display_winner[] = {0,1}; }

endgroup

covergroup pas_mon_cov;
option.per_instance = 1;
CANDIDATE_NAME_CHECK : coverpoint pas_item.candidate_name { bins candidate_name[] = {[0:3]}; }
INVALID_RESULT_CHECK : coverpoint pas_item.invalid_results { bins invalid_result[] = {0,1}; }
RESULT_CHECK : coverpoint pas_item.results { bins result[] = {[0:127]}; }
VOTING_IN_PROGRESS : coverpoint pas_item.voting_in_progress { bins voting_in_progress[] = {0,1}; }
VOTING_DONE_CHECK : coverpoint pas_item.voting_done { bins voting_done[] = {0,1}; }
endgroup

function new(string name="evm_subscriber", uvm_component parent=null);
super.new(name,parent);
act_item = new("active_monitor");
pas_item = new("passive_monitor");

act_mon_cov = new();
pas_mon_cov = new();

pas_mon_export = new("pas_mon_export", this);
endfunction

virtual function void write(evm_transaction t);
act_item = t;
act_mon_cov.sample();
endfunction

virtual function void write_pas_mon(evm_transaction t);  //  passive monitor
pas_item = t;
pas_mon_cov.sample();
endfunction

function void extract_phase(uvm_phase phase);
super.extract_phase(phase);
active_cov = act_mon_cov.get_coverage();
passive_cov = pas_mon_cov.get_coverage();
endfunction

function void report_phase(uvm_phase phase);
super.report_phase(phase);
`uvm_info(get_type_name(), $sformatf("[INPUT] Coverage ------> %0.2f%%", active_cov), UVM_MEDIUM)
`uvm_info(get_type_name(), $sformatf("[OUTPUT] Coverage -----> %0.2f%%", passive_cov), UVM_MEDIUM)
endfunction

endclass

