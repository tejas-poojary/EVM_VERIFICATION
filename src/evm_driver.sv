class evm_driver extends uvm_driver#(evm_sequence_item);
 `uvm_component_utils(evm_driver)
 evm_sequence_item req;
 virtual evm_interface vif_drv;


 function new(string name="evm_driver",uvm_component parent=null);
  super.new(name,parent);
 endfunction

 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual evm_interface)::get(this,"","evm_inf",vif_drv))
   `uvm_fatal(get_full_name(),"Driver didnt get interface handle")
 endfunction

 virtual task run_phase(uvm_phase phase);
  super.run_phase(phase);
  //repeat(2)@(vif_drv.evm_driver_cb);
  forever begin
   seq_item_port.get_next_item(req);
   drive();
   seq_item_port.item_done();
  end
 endtask

 task drive();
  vif_drv.evm_driver_cb.switch_on_evm <= req.switch_on_evm;
  vif_drv.evm_driver_cb.candidate_ready <= req.candidate_ready;
  vif_drv.evm_driver_cb.vote_candidate_1 <= req.vote_candidate_1;
  vif_drv.evm_driver_cb.vote_candidate_2 <= req.vote_candidate_2;
  vif_drv.evm_driver_cb.vote_candidate_3 <= req.vote_candidate_3;
  vif_drv.evm_driver_cb.voting_session_done <= req.voting_session_done;
  vif_drv.evm_driver_cb.display_results <= req.display_results;
  vif_drv.evm_driver_cb.display_winner <= req.display_winner;
  $display("driving",$time);
  @(vif_drv.evm_driver_cb);
 endtask

endclass

