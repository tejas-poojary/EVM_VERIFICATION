class evm_active_monitor extends uvm_monitor;
  `uvm_component_utils(evm_active_monitor)
  virtual evm_interface vif;
  evm_sequence_item seq_item;
  uvm_analysis_port#(evm_sequence_item) act_mon_port;
  function new(string name = "evm_active_monitor",uvm_component parent = null);
    super.new(name,parent);
    act_mon_port = new("act_mon_port",this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual evm_interface)::get(this,"","vif",vif))
    `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction
  virtual task run_phase(uvm_phase phase);
    seq_item = evm_sequence_item :: type_id :: create("seq_item");
    repeat(4)@(vif.act_monitor_cb);
    forever begin
      seq_item.vote_candidate_1 = vif.vote_candidate_1;
      seq_item.vote_candidate_2 = vif.vote_candidate_2;
      seq_item.vote_candidate_3 = vif.vote_candidate_3;
      seq_item.switch_on_evm = vif.switch_on_evm;
      seq_item.candidate_ready = vif.candidate_ready;
      seq_item.voting_session_done = vif.voting_session_done;
      seq_item.display_results = vif.display_results;
      seq_item.display_winner = vif.display_winner;
      $display("ACTIVE MONITOR RECEIVES @%0t",$time);
      seq_item.print();
      act_mon_port.write(seq_item);
      @(vif.act_monitor_cb);
    end
  endtask
endclass
