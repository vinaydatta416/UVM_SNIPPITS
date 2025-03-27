
import uvm_pkg::*;
`include "uvm_macros.svh"

class transaction extends uvm_sequence_item;
    `uvm_object_utils(transaction)
    
    rand bit [3:0] address;
    rand bit [3:0] data;

    function new(string name="transaction");
        super.new(name);
    endfunction
endclass

class seq extends uvm_sequence#(transaction);
    `uvm_object_utils(seq)
     
    function new(string name ="seq");
        super.new(name);
    endfunction
    
    task body();
	  
        req = transaction::type_id::create("req");
		repeat(4) 
		begin
        start_item(req);
        req.randomize();
        finish_item(req);
		end
    endtask : body
endclass

class seqr extends uvm_sequencer #(transaction);
    `uvm_component_utils(seqr)

    function new(string name = "seqr", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    task run_phase (uvm_phase phase);
	begin
        super.run_phase(phase);
        seq_item_port.get_next_item(req);
        $display("The address and data are %d and %d", req.address, req.data);
        seq_item_port.item_done();
		end
    endtask
endclass

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    function new(string name = "monitor", uvm_component parent);
        super.new(name, parent);
    endfunction
endclass

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    seqr seqr_h;
    driver drvr_h;
    monitor mntr_h;

    function new(string name = "agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr_h = seqr::type_id::create("seqr_h", this);
        drvr_h = driver::type_id::create("drvr_h", this);
        mntr_h = monitor::type_id::create("mntr_h", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drvr_h.seq_item_port.connect(seqr_h.seq_item_export);
        `uvm_info("agent", "completed the seqr-driver connection", UVM_MEDIUM)
    endfunction
endclass

class env extends uvm_env;
    `uvm_component_utils(env)

    agent agent_h;

    function new(string name = "env", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_h = agent::type_id::create("agent_h", this);
    endfunction
endclass

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    env env_h;
    seq seq_h;

    function new(string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_h = env::type_id::create("env_h", this);
        seq_h = seq::type_id::create("seq_h");
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction
    
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq_h.start(env_h.agent_h.seqr_h);
        phase.drop_objection(this);
    endtask
endclass

module top;
    initial begin
        run_test("base_test");
    end
endmodule

