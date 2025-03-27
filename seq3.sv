import uvm_pkg::*;
`include "uvm_macros.svh"

class seqr extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(seqr)

  function new(string name = "seqr", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

class driver extends uvm_driver #(uvm_sequence_item);
  `uvm_component_utils(driver)

  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction
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
    `uvm_info("agent", "completed the seqr driver connection", UVM_MEDIUM)
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

  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h = env::type_id::create("env_h", this);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass

module top;
  initial begin
    run_test("base_test");
  end
endmodule
