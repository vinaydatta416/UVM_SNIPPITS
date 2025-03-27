//program for factory

import uvm_pkg::*;      //importing the uvm package
 `include "uvm_macros.svh"      //including the macro file


  class write_xtn extends uvm_sequence_item;
        `uvm_object_utils(write_xtn)  //factory registration
         rand int a;

         function new(string name = "write_xtn");
                super.new(name);
         endfunction

        constraint valid_a{ a > 5; a < 15;}
  endclass


  class small_xtn extends write_xtn;

        `uvm_object_utils(small_xtn)
        function new(string name = "small_xtn");
                super.new(name);
        endfunction

        constraint valid_a{a == 9;}
  endclass



  write_xtn xtn_h;

  module top;

 function call();
xtn_h = write_xtn::type_id::create("xtn_h");
  xtn_h.randomize();

 $display("the value of a is %d",xtn_h.a);

 endfunction

        initial
             begin
             call();
             factory.set_type_override_by_type(write_xtn::get_type(),small_xtn::get_type());
             call();
             factory.print();
             end
endmodule
