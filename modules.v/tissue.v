`timescale 1ns/1ns
////////////////////////////////////////////////////////////////////////////////
// Course: Bio-Inspired-Design
// Engineer: Matin Firoozbakht
// Module Name: tissue
// Project Name: Cellular Automata Traffic Simulator
////////////////////////////////////////////////////////////////////////////////
module tissue #(
  parameter TISSUE_WIDTH = 90,                  // width of the tissue
  parameter TISSUE_HEIGHT = 3,                  // height of the tissue
  parameter NUM_STATUS = 8,                     // number of status bits that others have  
  parameter RANDOMIZED_LEN = 2                  // number of bits that are randomized
) (
  input clk,                                           // clock signal
  input rst,                                           // reset signal
  input init,                                          // initialization signal
  input cell_init_status_in,                           // initial status input
  input [32:0] number_of_steps,                        // number of steps to simulate
  input [RANDOMIZED_LEN*8-1:0] flip_chance_in,         // for initialization of the chances
  input [2**(NUM_STATUS+1)-1:0] cell_logic_inputs_in,  // initialization logic cell truth table
  input [RANDOMIZED_LEN*8-1:0] cell_lfsr_seed_in,      // for initialization of the lfsr_seed
  output reg done                                      // this will be 1 when simulation is complete
);

  // all internal wires
  wire in_cell_init_status [0:TISSUE_WIDTH*TISSUE_HEIGHT-1];
  wire [RANDOMIZED_LEN*8-1:0] in_flip_chance [0:TISSUE_WIDTH*TISSUE_HEIGHT-1];
  wire [2**(NUM_STATUS+1)-1:0] in_cell_logic_inputs [0:TISSUE_WIDTH*TISSUE_HEIGHT-1];
  wire [RANDOMIZED_LEN*8-1:0] in_cell_lfsr_seed [0:TISSUE_WIDTH*TISSUE_HEIGHT-1];

  wire out_cell_init_status [0:TISSUE_WIDTH*TISSUE_HEIGHT-1];
  wire [RANDOMIZED_LEN*8-1:0] out_flip_chance [0:TISSUE_WIDTH*TISSUE_HEIGHT-1];
  wire [2**(NUM_STATUS+1)-1:0] out_cell_logic_inputs [0:TISSUE_WIDTH*TISSUE_HEIGHT-1];
  wire [RANDOMIZED_LEN*8-1:0] out_cell_lfsr_seed [0:TISSUE_WIDTH*TISSUE_HEIGHT-1];

  // status bits
  wire [NUM_STATUS-1:0] status_bits [0:TISSUE_WIDTH*TISSUE_HEIGHT-1];

  // now cell status
  wire cell_status [0:TISSUE_WIDTH*TISSUE_HEIGHT-1];

  // next cell status
  wire next_status [0:TISSUE_WIDTH*TISSUE_HEIGHT-1];

  // now step
  reg [31:0] step;
  
  // assign the inputs
  assign in_cell_init_status[0] = cell_init_status_in;
  assign in_flip_chance[0] = flip_chance_in;
  assign in_cell_logic_inputs[0] = cell_logic_inputs_in;
  assign in_cell_lfsr_seed[0] = cell_lfsr_seed_in;

  // this generate block is for wiring the inputs to the cells
  genvar a;
  generate
    for (a=0;a<(TISSUE_WIDTH*TISSUE_HEIGHT);a=a+1) begin
      if (a<(TISSUE_WIDTH*TISSUE_HEIGHT-1)) begin
        assign in_cell_init_status[a+1] = out_cell_init_status[a];
        assign in_flip_chance[a+1] = out_flip_chance[a];
        assign in_cell_logic_inputs[a+1] = out_cell_logic_inputs[a];
        assign in_cell_lfsr_seed[a+1] = out_cell_lfsr_seed[a];
      end

      single_cell #(NUM_STATUS, RANDOMIZED_LEN) s_cell (
        .clk(clk & ~done), // update until not done
        .rst(rst),
        .init(init),
        // ----------------------------------------------
        .init_status_in(in_cell_init_status[a]),
        .in_chance(in_flip_chance[a]),
        .clg_inputs(in_cell_logic_inputs[a]),
        .in_lfsr_seed(in_cell_lfsr_seed[a]),
        // ----------------------------------------------
        .init_status_out(out_cell_init_status[a]),
        .out_chance(out_flip_chance[a]),
        .clg_outputs(out_cell_logic_inputs[a]),
        .out_lfsr_seed(out_cell_lfsr_seed[a]),
        // ----------------------------------------------
        .others_status(status_bits[a]), // status bits
        // ----------------------------------------------
        .now_status(cell_status[a]), // now_status
        .next_status(next_status[a]) // next_status
      );
    end
  endgenerate

  // this generate block is for status bits
  genvar b, c;
  generate
    for (b=0;b<TISSUE_HEIGHT;b=b+1) begin
      for (c=0;c<TISSUE_WIDTH;c=c+1) begin
        if (c == 0) begin
          assign status_bits[b*TISSUE_WIDTH+c] = {1'b0, cell_status[b*TISSUE_WIDTH+c+1]};
        end else if (c == TISSUE_WIDTH-1) begin
          assign status_bits[b*TISSUE_WIDTH+c] = {cell_status[b*TISSUE_WIDTH+c-1], 1'b0};
        end else begin
          assign status_bits[b*TISSUE_WIDTH+c] = {cell_status[b*TISSUE_WIDTH+c-1], cell_status[b*TISSUE_WIDTH+c+1]};
        end
      end
    end
  endgenerate

  // step counter
  always @(posedge clk) begin
    if (rst) step = 0;
    else if (init) step = 0;
    else if (step == number_of_steps) done = 1'b1;
    else step = step + 1;
  end

  // this is just for us to see all state of the cells remove this if you want synthesis
  integer f, x, y;

  // save now status to a file for visualization as a bitmap
  always @(posedge clk) begin
    if (!rst && !init) begin
      // open file as append mode with 
      f = $fopen("z_cell_satatus.dat", "a");
      $fwrite(f, "%0d\n", step);
      // write data to the file with for loop
      for (y=0;y<TISSUE_HEIGHT;y=y+1) begin
        for (x=0;x<TISSUE_WIDTH;x=x+1) begin
          $fwrite(f, "%b", cell_status[y*TISSUE_WIDTH+x]);
        end
        $fwrite(f, "\n");
      end
      $fwrite(f, "\n");
      // close file
      $fclose(f);
    end
  end

endmodule 
