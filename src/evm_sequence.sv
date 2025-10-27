class evm_sequence extends uvm_sequence #(evm_sequence_item);

	`uvm_object_utils(evm_sequence)

	evm_sequence_item seq_item;

	function new(string name = "evm_sequence");
		super.new(name);
	endfunction

	virtual task body();
			req = evm_sequence_item::type_id::create("req");
			wait_for_grant();
			req.randomize();
			send_request(req);
			wait_for_item_done();
	endtask
endclass


class base_seq extends uvm_sequence #(apb_sequence_item); 
	`uvm_object_utils(base_seq)

	function new(string name = "base_seq");
		super.new(name);
	endfunction

	virtual task body();
		`uvm_do_with(req,{req.PRESETn == 1;});
	endtask
endclass
