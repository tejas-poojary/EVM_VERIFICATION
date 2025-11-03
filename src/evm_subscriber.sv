`uvm_analysis_imp_decl(_pass_mon)

class evm_subscriber extends uvm_subscriber#(evm_sequence_item);

`uvm_component_utils(evm_subscriber)

uvm_analysis_imp_pass_mon#(evm_sequence_item, evm_subscriber) pass_mon_sub_imp;

evm_sequence_item act_item;
evm_sequence_item pas_item;

real active_cov, passive_cov;

covergroup act_mon_cov;
    VOTE_CANDIDATE_1_CHECK : coverpoint act_item.vote_candidate_1 { bins cand1_assert = {1};
                                                                    bins cand1_deassert = {0};
                                                                  }
    VOTE_CANDIDATE_2_CHECK : coverpoint act_item.vote_candidate_2 {
                                                                    bins cand2_assert = {1};
                                                                    bins cand2_deassert = {0};
                                                                  }
    VOTE_CANDIDATE_3_CHECK : coverpoint act_item.vote_candidate_3 {
                                                                    bins cand3_assert = {1};
                                                                    bins cand3_deassert = {0};
                                                                  }
    SWITCH_ON_EVM_CHECK : coverpoint act_item.switch_on_evm {
                                                               bins switch_assert = {1};
                                                               bins switch_deassert = {0};
                                                            }
    CANDIDATE_READY_CHECK : coverpoint act_item.candidate_ready {
                                                                  bins cand_ready_assert = {1};
                                                                  bins cand_ready_deassert = {0};
                                                                }
    VOTING_SESSION_DONE_CHECK : coverpoint act_item.voting_session_done { bins voting_session_done_assert = {1};
                                                                          bins voting_session_done_deassert = {0};
                                                                        }
    DISPLAY_RESULT_CHECK : coverpoint act_item.display_results { bins display_result_cand1 = {0};
                                                                 bins display_result_cand2 = {1};
                                                                 bins display_result_cand3 = {2};
                                                                 bins display_result_default = {3};
                                                               }
    DISPLAY_WINNER_CHECK : coverpoint act_item.display_winner { bins display_winner_assert = {1};
                                                                bins display_winner_deassert = {0};
                                                              }
endgroup

covergroup pas_mon_cov;
    CANDIDATE_NAME_CHECK : coverpoint pas_item.candidate_name {
                                                                bins cand1_name = {1};
                                                                bins cand2_name = {2};
                                                                bins cand3_name = {3};
                                                                bins default_name = {0};
                                                              }
    INVALID_RESULT_CHECK : coverpoint pas_item.invalid_results {
                                                                 bins invalid_result_assert = {1};
                                                                 bins invalid_result_deassert = {0};
                                                               }
    RESULT_CHECK : coverpoint pas_item.results {
                                                 option.auto_bin_max = 3;
                                               }
    VOTING_IN_PROGRESS : coverpoint pas_item.voting_in_progress {
                                                                  bins voting_in_progress_assert = {1};
                                                                  bins voting_in_progress_deassert = {0};
                                                                }
    VOTING_DONE_CHECK : coverpoint pas_item.voting_done {
                                                          bins voting_done_assert = {1};
                                                          bins voting_done_deassert = {1};
                                                        }
endgroup

function new(string name="evm_subscriber", uvm_component parent=null);
    super.new(name,parent);
    act_item = new("active_monitor");
    pas_item = new("passive_monitor");

    act_mon_cov = new();
    pas_mon_cov = new();

    pass_mon_sub_imp = new("pass_mon_sub_imp", this);
endfunction

virtual function void write(evm_sequence_item t);
act_item = t;
act_mon_cov.sample();
endfunction

virtual function void write_pass_mon(evm_sequence_item t);  //  passive monitor
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
