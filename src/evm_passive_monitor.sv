class evm_passive_monitor extends uvm_monitor;
  `uvm_component_utils(evm_passive_monitor)
  virtual evm_interface vif;
  evm_sequence_item seq_item;
  uvm_analysis_port#(evm_sequence_item) pass_mon_port;
  function new(string name = "evm_passive_monitor",uvm_component parent = null);
    super.new(name,parent);
    pass_mon_port = new("pass_mon_port",this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual evm_interface)::get(this,"","evm_inf",vif))
    `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction
  virtual task run_phase(uvm_phase phase);
    seq_item = evm_sequence_item :: type_id :: create("seq_item");
    repeat(4)@(vif.evm_monitor_cb);
    forever begin
      seq_item.candidate_name = vif.candidate_name;
      seq_item.invalid_results = vif.invalid_results;
      seq_item.results = vif.results;
      seq_item.voting_in_progress = vif.voting_in_progress;
      seq_item.voting_done = vif.voting_done;
      $display("PASSIVE MONITOR RECEIVES @%0t",$time);
      seq_item.print();
      pass_mon_port.write(seq_item);
      @(vif.evm_monitor_cb);
    end
  endtask
endclass
