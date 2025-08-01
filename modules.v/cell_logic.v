`timescale 1ns/1ns
////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: cell_logic
// Project Name: Cellular Automata Traffic Simulator
/////////////////////////////////////////////////////////////////////////////////
module cell_logic #(parameter NUM_INPUTS = 9) (
  // inputs
  input clk,                           // clk signal
  input init,                          // init signal
  input [NUM_INPUTS-1:0] logic_in,                      // logic input
  input [2**NUM_INPUTS-1:0] logic_inputs, // for initialization
  // outputs
  output logic_out,
  output [2**NUM_INPUTS-1:0] logic_outputs // for initialization next cell
);
  
  // logic registers
  reg [2**NUM_INPUTS-1:0] logic_regs;

  // assign internal registers to the output for next logic cell
  assign logic_outputs = logic_regs;

  // this is for inializing the logic registers
  always @(posedge clk) begin
    if (init == 1'b1) begin // initialize the logic registers
      logic_regs = logic_inputs; 
    end
  end

  // this is for the output logic
  assign logic_out = logic_regs[logic_in];

endmodule 
