`include "uvm_macros.svh"
import uvm_pkg::*;

// Driver
class driver extends uvm_driver;

  `uvm_component_utils(driver)
  
  function new(string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("driver", "am in the build of driver", UVM_MEDIUM);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("driver", "am in the connect of driver", UVM_MEDIUM);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("driver", "am in the run phase of driver", UVM_MEDIUM);
    phase.drop_objection(this);
  endtask

endclass

// Agent
class agent extends uvm_agent;

  `uvm_component_utils(agent)

  driver drv_h;
  
  function new(string name = "agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("agent", "am in the build of agent", UVM_MEDIUM);
    drv_h = driver::type_id::create("drv_h", this);
	  drv_h.set_report_verbosity_level(UVM_MEDIUM);

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("agent", "am in the connect of agent", UVM_MEDIUM);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("agent", "am in the run phase of agent", UVM_MEDIUM);
    phase.drop_objection(this);
  endtask
  
endclass

// Environment
class env extends uvm_env;

  `uvm_component_utils(env)

  agent agnt_h;

  function new(string name = "env", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("env", "am in the build of env", UVM_MEDIUM);
    agnt_h = agent::type_id::create("agnt_h", this);
	  agnt_h.set_report_verbosity_level(UVM_MEDIUM);

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("env", "am in the connect of env", UVM_MEDIUM);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("env", "am in the run phase of env", UVM_MEDIUM);
    phase.drop_objection(this);
  endtask

endclass

// Test
class basetest extends uvm_test;

  `uvm_component_utils(basetest)

  env env_h;

  function new(string name = "basetest", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("test", "am in the build of test", UVM_MEDIUM);
    env_h = env::type_id::create("env_h", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("test", "am in the connect of test", UVM_MEDIUM);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    `uvm_info("test", "am in the end_of_elaboration of test", UVM_MEDIUM);
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    #10;
    `uvm_info("test", "am in the run phase of test", UVM_MEDIUM);
    phase.drop_objection(this);
  endtask

endclass

// Top Module
module top;

  initial begin
    uvm_top.set_report_verbosity_level(UVM_MEDIUM);
    run_test("basetest");
  end

endmodule