class evm_agent extends uvm_agent;
 `uvm_component_utils(evm_agent)
 evm_driver drv;
 evm_active_monitor act_mon;
 evm_passive_monitor pas_mon;
 evm_sequencer seqr;

 function new(string name="evm_agent",uvm_component parent=null);
  super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(uvm_active_passive_enum)::get(this,"","is_active",is_active))
   `uvm_error(get_full_name(),"Agent not set")
   if(get_is_active()==UVM_ACTIVE)
    begin
     drv=evm_driver::type_id::create("drv",this);
     seqr=evm_sequencer::type_id::create("seqr",this);
     act_mon=evm_active_monitor::type_id::create("act_mon",this);
    end
     pas_mon=evm_passive_monitor::type_id::create("pas_mon",this);
  endfunction

 function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(get_is_active()==UVM_ACTIVE)
   drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

 endclass
