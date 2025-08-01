`timescale 1ns/1ns
/////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: tissue_tb
// Project Name: Cellular Automata Traffic Simulator
/////////////////////////////////////////////////////////////////////////////////
module tissue_tb;

  parameter TISSUE_WIDTH = 30;
  parameter TISSUE_HEIGHT = 3;
  parameter NUM_STATUS = 2;
  parameter RANDOMIZED_LEN = 1;

  // Inputs
  reg clk = 1'b0;
  reg rst = 1'b0;
  reg init = 1'b0;
  reg cell_init_status_in;
  reg [32:0] number_of_steps = 32;
  reg [RANDOMIZED_LEN*8-1:0] flip_chance_in;
  reg [RANDOMIZED_LEN*8-1:0] cell_lfsr_seed_in;
  reg [2**(NUM_STATUS+1)-1:0] cell_logic_inputs_in;
  
  // Outputs
  wire done;

  // Instantiate the Unit Under Test (UUT)
  tissue #(
    .TISSUE_WIDTH(TISSUE_WIDTH),
    .TISSUE_HEIGHT(TISSUE_HEIGHT),
    .NUM_STATUS(NUM_STATUS),
    .RANDOMIZED_LEN(RANDOMIZED_LEN)
  ) uut (
    .clk(clk),
    .rst(rst),
    .init(init),
    .cell_init_status_in(cell_init_status_in),
    .number_of_steps(number_of_steps),
    .flip_chance_in(flip_chance_in),
    .cell_logic_inputs_in(cell_logic_inputs_in),
    .cell_lfsr_seed_in(cell_lfsr_seed_in),
    .done(done)
  );

  // clock generator
  always #5 clk = ~clk;

  // cell init status
  reg [TISSUE_WIDTH-1:0] cell_init_status [0:TISSUE_HEIGHT-1];

  // varialbes
  integer f, x, y;
  reg [TISSUE_WIDTH-1:0] line;

  // read itinial status from file
  initial begin
    // Open file for reading
    f = $fopen("z_cell_init_status.dat", "r");

    // read and display each line
    y = 0;
    while (!$feof(f)) begin
      $fscanf(f, "%b", line);
      for (x=0;x<TISSUE_WIDTH;x=x+1) begin
        cell_init_status[y][x] = line[x];
      end
      y = y + 1;
    end

    // Close file
    $fclose(f);
  end

  integer i, j;

  initial begin

    // Initialize
    init = 1'b1;
    flip_chance_in = 8'h00;             // this chance is "move forward if you can 100% move forward"
    cell_lfsr_seed_in = 8'hff;          // lfsr seed
    cell_logic_inputs_in = 8'b10101100; // this is simple model for the trafic flow

    // init cell_init_status_in
    for (j=0;j<TISSUE_HEIGHT;j=j+1) begin
      for (i=0;i<TISSUE_WIDTH;i=i+1) begin
        cell_init_status_in = cell_init_status[j][i];
        @(posedge clk);
      end
    end

    // done init
    init = 1'b0;

    // rest for one clock
    rst = 1'b1;
    @(posedge clk);
    rst = 1'b0;

    @(posedge done);


    $stop;
  end

endmodule // tissue_tb
