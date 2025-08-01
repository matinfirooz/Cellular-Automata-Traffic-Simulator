`timescale 1ns/1ns
/////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: lfsr_8_tb
// Project Name: Cellular Automata Traffic Simulator
/////////////////////////////////////////////////////////////////////////////////
module lfsr_8_tb;

  // Inputs
  reg clk = 1'b0;
  reg rst = 1'b0;
  reg init = 1'b0;
  reg [7:0] seed = 8'hFF;

  // Outputs
  wire [7:0] out;

  // Instantiate the DUT
  lfsr_8 dut (
    .clk(clk),
    .rst(rst),
    .init(init),
    .seed(seed),
    .out(out)
  );

  // Clock generator
  always #5 clk = ~clk;

  integer i;

  // Stimulus
  initial begin
    // initialization
    rst = 1'b0;
    init = 1'b1;
    seed = 8'hFF;
    @(posedge clk);

    init = 1'b0;

    for (i = 0;i<256;i=i+1) begin
      @(posedge clk);
    end

    $stop;
  end

endmodule // lfsr_8_tb
