class evm_driver extends uvm_driver#(evm_sequence_item);
 `uvm_component_utils(evm_driver)
 evm_sequence_item req;
 virtual evm_interface vif_drv;
 event active_mon_trigger,passive_mon_trigger;

 function new(string name="evm_driver",uvm_component parent=null);
  super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(evm_interface)::get(this,"","vif",vif_drv)
   `uvm_error(get_full_name(),"Driver didnt get interface handle");
 endfunction

 virtual task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever begin
   seq_item_port.get_next_item(req);
   drive();
   seq_item_port.item_done();
  end
 endtask

 task drive();

 endtask

 endclass
