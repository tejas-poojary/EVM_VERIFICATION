class evm_sequencer extends uvm_sequencer#(evm_sequence_item)
  `uvm_object_utils(evm_sequencer)
  function new(string name ="evm_sequencer")
    super.new(name);
  endfunction 
endclass
