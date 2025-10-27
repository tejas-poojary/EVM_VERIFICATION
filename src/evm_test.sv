class evm_base_test extends uvm_test;
	evm_environment env;

	`uvm_component_utils(evm_base_test)

	function new(string name = "evm_base_test", uvm_component parent = null);
	super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = evm_environment::type_id::create("env", this);
	endfunction

	virtual function void end_of_elaboration();
		print();
	endfunction
endclass


class evm_test1 extends evm_base_test;
	`uvm_component_utils(evm_test1)

	function new(string name = "evm_test1", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual task run_phase(uvm_phase phase);
		base_seq seq;
		super.run_phase(phase);
		phase.raise_objection(this, "Objection Raised");
		seq = base_seq::type_id::create("seq");
		seq.start(env.evm_active_agent.evm_sequencer);
		phase.drop_objection(this, "Objection Dropped");
	endtask
endclass
