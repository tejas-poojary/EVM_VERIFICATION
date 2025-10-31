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

    virtual task run_phase(uvm_phase phase);
         pure_maj_seq seq;
        super.run_phase(phase);
        phase.raise_objection(this, "Objection Raised");
        seq = pure_maj_seq::type_id::create("seq");
        seq.start(env.evm_active_agent.seqr);
        phase.drop_objection(this, "Objection Dropped");
    endtask


        virtual function void end_of_elaboration();
                print();
        endfunction
endclass


class rand_test extends uvm_test;
        `uvm_component_utils(rand_test)
        evm_environment env;
        function new(string name = "rand_test", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                env = evm_environment::type_id::create("env", this);
        endfunction

        virtual task run_phase(uvm_phase phase);
                rand_seq seq;
                super.run_phase(phase);
                phase.raise_objection(this, "Objection Raised");
                seq = rand_seq::type_id::create("seq");
                seq.start(env.evm_active_agent.seqr);
                phase.drop_objection(this, "Objection Dropped");
        endtask
endclass


class pure_maj_test extends uvm_test;
        `uvm_component_utils(pure_maj_test)
        evm_environment env;
        function new(string name = "pure_maj_test", uvm_component parent = null);
                super.new(name, parent);
        endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = evm_environment::type_id::create("env",this);
    endfunction

        virtual task run_phase(uvm_phase phase);
                pure_maj_seq seq;
                super.run_phase(phase);
                phase.raise_objection(this, "Objection Raised");
                seq = pure_maj_seq::type_id::create("seq");
                seq.start(env.evm_active_agent.seqr);
                phase.drop_objection(this, "Objection Dropped");
        endtask
endclass

class top_2tie_test extends uvm_test;
        `uvm_component_utils(top_2tie_test)
        evm_environment env;
        function new(string name = "top_2tie_test", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                env = evm_environment::type_id::create("env",this);
        endfunction

        virtual task run_phase(uvm_phase phase);
                top_2tie_seq1 seq;
                super.run_phase(phase);
                phase.raise_objection(this, "Objection Raised");
                seq = top_2tie_seq1::type_id::create("seq");
                seq.start(env.evm_active_agent.seqr);
                phase.drop_objection(this, "Objection Dropped");
        endtask
endclass

class bottom_Two_tie_test extends uvm_test;
        `uvm_component_utils(bottom_Two_tie_test)
        evm_environment env;
        function new(string name = "bottom_Two_tie_test", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                env = evm_environment::type_id::create("env",this);
        endfunction

        virtual task run_phase(uvm_phase phase);
                bottom_Two_tie_seq1 seq;
                super.run_phase(phase);
                phase.raise_objection(this, "Objection Raised");
                seq = bottom_Two_tie_seq1::type_id::create("seq");
                seq.start(env.evm_active_agent.seqr);
                phase.drop_objection(this, "Objection Dropped");
        endtask
endclass

class all_3tie_test extends uvm_test;
        `uvm_component_utils(all_3tie_test)
        evm_environment env;
        function new(string name = "all_3tie_test", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                env = evm_environment::type_id::create("env",this);
        endfunction

        virtual task run_phase(uvm_phase phase);
                all_3tie_seq seq;
                super.run_phase(phase);
                phase.raise_objection(this, "Objection Raised");
                seq = all_3tie_seq::type_id::create("seq");
                seq.start(env.evm_active_agent.seqr);
                phase.drop_objection(this, "Objection Dropped");
        endtask
endclass

class fsm_timeout_in_waiting_for_candidate_test extends uvm_test;
        `uvm_component_utils(fsm_timeout_in_waiting_for_candidate_test)
        evm_environment env;
        function new(string name = "fsm_timeout_in_waiting_for_candidate_test", uvm_component parent = null);
                super.new(name, parent);
        endfunction


   function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = evm_environment::type_id::create("env",this);
    endfunction


        virtual task run_phase(uvm_phase phase);
                fsm_timeout_in_waiting_for_candidate_seq seq;
                super.run_phase(phase);
                phase.raise_objection(this, "Objection Raised");
                seq = fsm_timeout_in_waiting_for_candidate_seq::type_id::create("seq");
                seq.start(env.evm_active_agent.seqr);
                #20;
                phase.drop_objection(this, "Objection Dropped");
        endtask
endclass

class fsm_timeout_in_waiting_for_candidate_to_vote_test extends uvm_test;
        `uvm_component_utils(fsm_timeout_in_waiting_for_candidate_to_vote_test)

    evm_environment env;
        function new(string name = "fsm_timeout_in_waiting_for_candidate_to_vote_test", uvm_component parent = null);
                super.new(name, parent);
        endfunction

   function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = evm_environment::type_id::create("env",this);
    endfunction


        virtual task run_phase(uvm_phase phase);
                fsm_timeout_in_waiting_for_candidate_to_vote_seq seq;
                super.run_phase(phase);
                phase.raise_objection(this, "Objection Raised");
                seq = fsm_timeout_in_waiting_for_candidate_to_vote_seq::type_id::create("seq");
                seq.start(env.evm_active_agent.seqr);
                phase.drop_objection(this, "Objection Dropped");
        endtask
endclass

class max_count_test extends uvm_test;
        `uvm_component_utils(max_count_test)
    evm_environment env;
        function new(string name = "max_count_test", uvm_component parent = null);
                super.new(name, parent);
        endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = evm_environment::type_id::create("env",this);
    endfunction

        virtual task run_phase(uvm_phase phase);
                max_count_seq seq;
                super.run_phase(phase);
                phase.raise_objection(this, "Objection Raised");
                seq = max_count_seq::type_id::create("seq");
                seq.start(env.evm_active_agent.seqr);
                phase.drop_objection(this, "Objection Dropped");
        endtask
endclass


class multiple_candidate_selection_test extends uvm_test;
        `uvm_component_utils(multiple_candidate_selection_test)
    evm_environment env;
        function new(string name = "multiple_candidate_selection_test", uvm_component parent = null);
                super.new(name, parent);
        endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = evm_environment::type_id::create("env",this);
    endfunction

        virtual task run_phase(uvm_phase phase);
                multiple_candidate_selection_seq seq;
                super.run_phase(phase);
                phase.raise_objection(this, "Objection Raised");
                seq = multiple_candidate_selection_seq::type_id::create("seq");
                seq.start(env.evm_active_agent.seqr);
                phase.drop_objection(this, "Objection Dropped");
        endtask
endclass


class maj_regression_test extends uvm_test;
    `uvm_component_utils(maj_regression_test)

        evm_environment env;
        function new(string name = "multiple_candidate_selection_test", uvm_component parent = null);
                super.new(name, parent);
        endfunction
        function void build_phase(uvm_phase phase);
        super.build_phase(phase);
            env = evm_environment::type_id::create("env",this);
        endfunction


        virtual task run_phase(uvm_phase phase);
                maj_regression_seq seq;
                super.run_phase(phase);
                phase.raise_objection(this, "Objection Raised");
                seq = maj_regression_seq::type_id::create("seq");
                seq.start(env.evm_active_agent.seqr);
                phase.drop_objection(this, "Objection Dropped");
        endtask
endclass


