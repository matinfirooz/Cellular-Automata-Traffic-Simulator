`timescale 1ns/1ns
////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: single_cell
// Project Name: Cellular Automata Traffic Simulator
////////////////////////////////////////////////////////////////////////////////
module single_cell #(
  parameter NUM_STATUS = 8,      // number of status bits that others have  
  parameter RANDOMIZED_LEN = 2   // number of bits that are randomized
) (
  input clk,                                    // clock signal
  input rst,                                    // reset signal
  input init,                                   // initialization signal
  input init_status_in,                         // initial status input
  input [NUM_STATUS-1:0] others_status,         // status of other cells
  input [RANDOMIZED_LEN*8-1:0] in_chance,       // for initialization of the chances
  input [2**(NUM_STATUS+1)-1:0] clg_inputs,     // initialization logic cell truth table
  input [RANDOMIZED_LEN*8-1:0] in_lfsr_seed,    // for initialization of the lfsr_seed
  output now_status,                            // now cell status
  output next_status,                           // next cell status
  output init_status_out,                       // initial status output
  output [RANDOMIZED_LEN*8-1:0] out_chance,     // for initialization of the chances
  output [2**(NUM_STATUS+1)-1:0] clg_outputs,   // initialization logic cell
  output [RANDOMIZED_LEN*8-1:0] out_lfsr_seed   // for initialization of the lfsr_seed
);

  reg init_status; // initial status
  reg cell_status; // cell status

  // randomize the status bits that are ment to be randomized
  wire randomized_bits [RANDOMIZED_LEN-1:0];

  // Instantiate the lg
  cell_logic #(NUM_STATUS+1) lg (
    .clk(clk),
    .init(init),
    .logic_in({cell_status, others_status[NUM_STATUS-1:RANDOMIZED_LEN], randomized_bits}),
    .logic_inputs(clg_inputs),
    .logic_out(next_status),
    .logic_outputs(clg_outputs)
  );

  genvar i;
  generate
    for (i=0;i<RANDOMIZED_LEN;i=i+1) begin
      // Instantiate the randomizer
      randomizer rb (
        .clk(clk),
        .rst(rst),
        .init(init),
        .in_chance(in_chance[i*8+7:i*8]),
        .in_lfsr_seed(in_lfsr_seed[i*8+7:i*8]),
        .in_bit(others_status[i]),
        .out_bit(randomized_bits[i]),
        .out_chance(out_chance[i*8+7:i*8]),
        .out_lfsr_seed(out_lfsr_seed[i*8+7:i*8])
      );
    end
  endgenerate

  // determine the now cell status in posegde clk
  always @(posedge clk or posedge rst) begin
    if (rst == 1'b1) cell_status = init_status;
    else cell_status = next_status;
  end

  // for initialization
  always @(posedge clk) begin
    if (init == 1'b1) init_status = init_status_in;
  end

  assign now_status = cell_status; // output the

  assign init_status_out = init_status; // output the initial status

endmodule
