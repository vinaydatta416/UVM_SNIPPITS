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


/* Exp Output 

Running test base_test...


# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(277) @ 0: reporter [Questa UVM] QUESTA_UVM-1.2.3
# UVM_INFO verilog_src/questa_uvm_pkg-1.2/src/questa_uvm_pkg.sv(278) @ 0: reporter [Questa UVM]  questa_uvm::init(+struct)
# UVM_INFO @ 0: reporter [RNTST] Running test base_test...
# UVM_INFO @ 0: reporter [UVMTOP] UVM testbench topology:
# --------------------------------------------------------------
# Name                       Type                    Size  Value
# --------------------------------------------------------------
# uvm_test_top               base_test               -     @466
#   env_h                    env                     -     @473
#     agent_h                agent                   -     @484
#       drvr_h               driver                  -     @601
#         rsp_port           uvm_analysis_port       -     @616
#         seq_item_port      uvm_seq_item_pull_port  -     @608
#       mntr_h               monitor                 -     @624
#       seqr_h               seqr                    -     @492
#         rsp_export         uvm_analysis_export     -     @499
#         seq_item_export    uvm_seq_item_pull_imp   -     @593
#         arbitration_queue  array                   0     -
#         lock_queue         array                   0     -
#         num_last_reqs      integral                32    'd1
#         num_last_rsps      integral                32    'd1
# --------------------------------------------------------------
#
#
# --- UVM Report Summary ---
#
# ** Report counts by severity
# UVM_INFO :    4
# UVM_WARNING :    0
# UVM_ERROR :    0
# UVM_FATAL :    0
# ** Report counts by id
# [Questa UVM]     2
# [RNTST]     1
# [UVMTOP]     1
 
 */

