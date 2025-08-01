`timescale 1ns/1ns
////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: randomizer
// Project Name: Cellular Automata Traffic Simulator
////////////////////////////////////////////////////////////////////////////////
module randomizer (
  input clk,                    // clock signal
  input rst,                    // reset signal
  input init,                   // initialization signal
  input in_bit,                 // input bit
  input [7:0] in_chance,        // for initialization of the chances
  input [7:0] in_lfsr_seed,     // for initialization of the lfsr_seed
  output out_bit,               // output bit
  output [7:0] out_chance,      // for initialization of the chances
  output [7:0] out_lfsr_seed   // for initialization of the lfsr_seed
);

  // {zero_one_chance, one_zero_chance}

  // chance to filp one to zero
  reg [3:0] one_zero_chance;

  // chance to filp zero to one
  reg [3:0] zero_one_chance;

  // lfsr seed
  reg [7:0] lfsr_seed;

  // 8-bit random number
  wire [7:0] rand8;

  // random 4-bits from 8-bit random number
  wire [3:0] rand4A = {rand8[2:0], |rand8[7:3]};
  wire [3:0] rand4B = {rand8[7:5], |rand8[4:0]};

  // instance of lfsr
  lfsr_8 lfsr (
    .clk(clk),
    .rst(rst),
    .init(init),
    .seed(in_lfsr_seed),
    .out(rand8)
  );

  // initialization process
  always @(posedge clk) begin
    // initialization
    if (init == 1'b1) begin
      // load the chances 
      // (xxxx) upper is the chance for 0 to flip to 1 
      // (xxxx) lower is the chance for 1 to flip to 0
      {zero_one_chance, one_zero_chance} = in_chance;
      // load the lfsr seed
      lfsr_seed = in_lfsr_seed;
    end
  end

  // chance to filp for initialization
  assign out_chance = {zero_one_chance, one_zero_chance};

  // assign out_chance
  assign out_bit = (in_bit == 1'b1 & rand4A <= one_zero_chance) ? 1'b0 : 
                   (in_bit == 1'b0 & rand4B <= zero_one_chance) ? 1'b1 : in_bit;

  // assign lfsr seed
  assign out_lfsr_seed = lfsr_seed;

endmodule 
