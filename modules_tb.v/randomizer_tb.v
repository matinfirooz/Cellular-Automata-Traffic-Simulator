`timescale 1ns/1ns
/////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: randomizer_tb
// Project Name: Cellular Automata Traffic Simulator
/////////////////////////////////////////////////////////////////////////////////
module randomizer_tb;

  // Inputs
  reg clk = 1'b0;
  reg rst = 1'b0;
  reg init = 1'b0;
  reg in_bit = 1'b0;
  reg [7:0] in_chance = 8'h80;
  reg [7:0] in_lfsr_seed = 8'hFF;

  // Outputs
  wire out_bit;
  wire [7:0] out_chance;
  wire [7:0] out_lfsr_seed;

  // checks the deffrence
  wire diff = in_bit ^ out_bit;

  // in this test we want to check that if in_bit is 1 and have been changed
  wire check = in_bit & diff;

  // Instantiate the DUT
  randomizer dut (
    .clk(clk),
    .rst(rst),
    .init(init),
    .in_chance(in_chance),
    .in_lfsr_seed(in_lfsr_seed),
    .in_bit(in_bit),
    .out_bit(out_bit),
    .out_chance(out_chance),
    .out_lfsr_seed(out_lfsr_seed)
  );

  // Clock generator
  always #5 clk = ~clk;

  integer i;

  // Stimulus
  initial begin
    // initialization
    rst = 1'b0;
    init = 1'b1;
    @(posedge clk);
    init = 1'b0;

    for (i = 0;i<256;i=i+1) begin
      // assign a random input bit
      in_bit = 1'b1;
      @(posedge clk);
    end

    for (i = 0;i<256;i=i+1) begin
      // assign a random input bit
      in_bit = 1'b0;
      @(posedge clk);
    end

    $stop;
  end

endmodule // randomizer_tb
