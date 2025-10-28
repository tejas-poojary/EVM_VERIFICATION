class evm_sequencer extends uvm_sequencer#(evm_sequence_item);
  `uvm_component_utils(evm_sequencer)

  function new(string name ="evm_sequencer",uvm_component parent=null);
    super.new(name,parent);
  endfunction

endclass
