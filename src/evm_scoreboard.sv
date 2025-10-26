`uvm_analysis_imp_decl(_act_mon)
`uvm_analysis_imp_decl(_pas_mon)

class evm_scoreboard extends uvm_scoreboard;
  `uvm_object_utils(evm_scoreboard)
  uvm_analysis_imp#(evm_sequence_item, evm_scoreboard) act_mon_scb_imp;
  uvm_analysis_imp#(evm_sequence_item, evm_scoreboard) pas_mon_scb_imp;

  virtual evm_interface vif;
  evm_sequence_item act_mon_q[$], pas_mon_q[$];

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
    evm_sequence_item inp_seq, expected_out, actual_out;
    forever begin
      wait(act_mon_q.size() > 0 && pas_mon_q.size() > 0);
      inp_seq = act_mon_q.pop_front();
      actual_out = pas_mon_q.pop_front();
      // ..... scoreboard logic and reference model to compare here .......

    end
  endtask


endclass
