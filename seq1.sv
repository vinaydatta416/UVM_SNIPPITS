import uvm_pkg::*;
`include "uvm_macros.svh"

class base_test extends uvm_component;
  `uvm_component_utils(base_test)

  function new(string name = "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass

module top;
  initial begin
    run_test("base_test");
    // uvm_test_top
  end
endmodule
