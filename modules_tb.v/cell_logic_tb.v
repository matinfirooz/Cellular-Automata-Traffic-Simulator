`timescale 1ns/1ns
////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: cell_logic_tb
// Project Name: Cellular Automata Traffic Simulator
///////////////////////////////////////////////////////////////////////////////
module cell_logic_tb;

  // Parameters
  parameter NUM_INPUTS = 3;

  // Inputs
  reg clk = 1'b0;
  reg init = 1'b0;
  reg [NUM_INPUTS-1:0] logic_in = 3'b0;
  reg [2**NUM_INPUTS-1:0] logic_inputs = 8'b0;

  // Outputs
  wire logic_out;
  wire [2**NUM_INPUTS-1:0] logic_outputs;

  // Instantiate the DUT
  cell_logic #(NUM_INPUTS) dut (
    .clk(clk),
    .init(init),
    .logic_in(logic_in),
    .logic_inputs(logic_inputs),
    .logic_out(logic_out),
    .logic_outputs(logic_outputs)
  );

  // Clock generator
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    // Initialize inputs
    init = 1'b1;
    // full adder truth table
    logic_inputs = 8'b10010110;
    // wait for one clock
    @(posedge clk);
    init = 1'b0;
    @(posedge clk);

    // Test 0
    logic_in = 3'b000; #2;
    if (logic_out != 1'b0) $error("Test 0 failed");

    // Test 1
    logic_in = 3'b001; #2;
    if (logic_out != 1'b1) $error("Test 1 failed");

    // Test 2
    logic_in = 3'b010; #2;
    if (logic_out != 1'b1) $error("Test 2 failed");
    
    // Test 3
    logic_in = 3'b011; #2;
    if (logic_out != 1'b0) $error("Test 3 failed");

    // Test 4
    logic_in = 3'b100; #2;
    if (logic_out != 1'b1) $error("Test 4 failed");

    // Test 5
    logic_in = 3'b101; #2;
    if (logic_out != 1'b0) $error("Test 5 failed");

    // Test 6
    logic_in = 3'b110; #2;
    if (logic_out != 1'b0) $error("Test 6 failed");

    // Test 7
    logic_in = 3'b111; #2;
    if (logic_out != 1'b1) $error("Test 7 failed");

    // Stop simulation
    $stop;
  end

endmodule