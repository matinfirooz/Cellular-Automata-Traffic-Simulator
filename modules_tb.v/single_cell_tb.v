`timescale 1ns/1ns
/////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: single_cell_tb
// Project Name: Cellular Automata Traffic Simulator
/////////////////////////////////////////////////////////////////////////////////
module single_cell_tb;

  parameter NUM_STATUS = 2;
  parameter RANDOMIZED_LEN = 1;

  // Inputs
  reg clk = 1'b0;
  reg rst = 1'b0;
  reg init = 1'b0;
  reg init_status_in = 1'b0;
  reg [(NUM_STATUS-1):0] others_status = 0;
  reg [(RANDOMIZED_LEN*8)-1:0] in_chance = 0;
  reg [2**(NUM_STATUS+1)-1:0] clg_inputs = 0;
  reg [(RANDOMIZED_LEN*8)-1:0] in_lfsr_seed = 0;

  // Outputs
  wire now_status;
  wire next_status;
  wire init_status_out;
  wire [(RANDOMIZED_LEN*8)-1:0] out_chance;
  wire [2**(NUM_STATUS+1)-1:0] clg_outputs;
  wire [(RANDOMIZED_LEN*8)-1:0] out_lfsr_seed;

  // Instantiate the DUT
  single_cell #(NUM_STATUS, RANDOMIZED_LEN) dut (
    .clk(clk),
    .rst(rst),
    .init(init),
    .init_status_in(init_status_in),
    .others_status(others_status),
    .in_chance(in_chance),
    .clg_inputs(clg_inputs),
    .in_lfsr_seed(in_lfsr_seed),
    .now_status(now_status),
    .next_status(next_status),
    .init_status_out(init_status_out),
    .out_chance(out_chance),
    .clg_outputs(clg_outputs),
    .out_lfsr_seed(out_lfsr_seed)
  );

  // Clock generator
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    // Initialize
    init = 1'b1;
    init_status_in = 1'b0;
    others_status = 2'b0;
    in_chance = 8'h00;        // this chance is "move forward if you can 100% move forward"
    clg_inputs = 8'b10101100; // this is simple model for the trafic flow
    in_lfsr_seed = 8'hff;
    @(posedge clk);
    init = 1'b0;
    @(posedge clk);

    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0;

    // Run

    // 1st cycle
    others_status = 2'b00;
    @(posedge clk);
    // must be 0
    if (next_status != 1'b0) begin
      $display("1_ ERROR: now_status is not 0");
      $stop;
    end

    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0;

    // 2nd cycle
    others_status = 2'b01;
    @(posedge clk);
    // must be 0
    if (next_status != 1'b0) begin
      $display("2_ ERROR: now_status is not 0");
      $stop;
    end

    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0;

    // 3rd cycle
    others_status = 2'b10;
    @(posedge clk);
    // must be 1
    if (next_status != 1'b1) begin
      $display("3_ ERROR: now_status is not 1");
      $stop;
    end

    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0;

    // 4rd cycle
    others_status = 2'b11;
    @(posedge clk);
    // must be 1
    if (next_status != 1'b1) begin
      $display("4_ ERROR: now_status is not 1");
      $stop;
    end

    @(posedge clk);
    @(posedge clk);
    
    // Initialize
    init = 1'b1;
    init_status_in = 1'b1;
    in_chance = 8'h00;        // this chance is "move forward if you can 100% move forward"
    clg_inputs = 8'b10101100; // this is simple model for the trafic flow
    in_lfsr_seed = 8'hff;
    @(posedge clk);
    init = 1'b0;
    @(posedge clk);

    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0;

    // 1st cycle
    others_status = 2'b00;
    @(posedge clk);
    // must be 0
    if (next_status != 1'b0) begin
      $display("5_ ERROR: now_status is not 0");
      $stop;
    end

    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0;

    // 2nd cycle
    others_status = 2'b01;
    @(posedge clk);
    // must be 1
    if (next_status != 1'b1) begin
      $display("6_ ERROR: now_status is not 1");
      $stop;
    end

    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0;

    // 3rd cycle
    others_status = 2'b10;
    @(posedge clk);
    // must be 0
    if (next_status != 1'b0) begin
      $display("7_ ERROR: now_status is not 0");
      $stop;
    end

    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0;

    // 4rd cycle
    others_status = 2'b11;
    @(posedge clk);
    // must be 1
    if (next_status != 1'b1) begin
      $display("8_ ERROR: now_status is not 1");
      $stop;
    end

    @(posedge clk);
    @(posedge clk);

    $stop;
  end

endmodule // single_cell_tb
