`timescale 1ns/1ns
////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: lfsr_8
// Project Name: Cellular Automata Traffic Simulator
////////////////////////////////////////////////////////////////////////////////
module lfsr_8 (
  input clk,
  input rst,
  input init,
  input [7:0] seed,
  output [7:0] out
);

  // 8-bit reg
  reg [7:0] inside;

  // load seed
  wire load_seed = rst | init;

  always @(posedge clk or posedge rst) begin
    // load the seed
    if (load_seed == 1'b1) inside <= seed;
    // poly of 'x8 + x6 + x5 + x4 + 1'
    else inside <= {inside[6:0], inside[7] ^ inside[5] ^ inside[4] ^ inside[3]};
  end

  // assign out
  assign out = inside;

endmodule 
