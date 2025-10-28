class evm_environment extends uvm_env;

`uvm_component_utils(evm_environment)

evm_agent evm_passive_agent, evm_active_agent;
evm_scoreboard scb;
evm_subscriber cov;

function new(string name="evm_env", uvm_component parent=null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
uvm_config_db#(uvm_active_passive_enum)::set(this,"evm_active_agent","is_active",UVM_ACTIVE);
uvm_config_db#(uvm_active_passive_enum)::set(this,"evm_passive_agent","is_active",UVM_PASSIVE);
evm_active_agent = evm_agent::type_id::create("evm_active_agent", this);
evm_passive_agent = evm_agent::type_id::create("evm_passive_agent", this);
scb = evm_scoreboard::type_id::create("scb", this);
cov = evm_subscriber::type_id::create("cov", this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);

evm_active_agent.act_mon.act_mon_port.connect(scb.act_mon_scb_imp);
evm_active_agent.act_mon.act_mon_port.connect(cov.analysis_export);

evm_passive_agent.pas_mon.pass_mon_port.connect(scb.pas_mon_scb_imp);
evm_passive_agent.pas_mon.pass_mon_port.connect(cov.pass_mon_sub_imp);
endfunction

endclass

