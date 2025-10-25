class evm_agent extends uvm_agent;
 `uvm_component_utils(evm_agent);

 function new(string name="evm_agent",uvm_component parent=null);
  super.new(name,parent);
 endfunction

 endclass
