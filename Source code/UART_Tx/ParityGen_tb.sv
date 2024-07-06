// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_Parity_Bit;

  // Inputs
  reg [7:0] data_in;
  reg [1:0] parity_type;
  reg rst_n;

  // Outputs
  wire parity_bit;

  // Instantiate the Parity_Bit module
  Parity_Bit uut (
    .data_in(data_in),
    .parity_type(parity_type),
    .rst_n(rst_n),
    .parity_bit(parity_bit)
  );

  // Test sequence
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    // Initialize inputs
    data_in = 8'b0;
    parity_type = 2'b00;
    rst_n = 0;

    // Apply reset
    #10;
    rst_n = 1;

    // Test ODD parity
    parity_type = 2'b01;
    data_in = 8'b10101010; // 4 ones (even), so parity bit should be 1 for ODD parity
    #10;
    data_in = 8'b10101011; // 5 ones (odd), so parity bit should be 0 for ODD parity
    #10;

    // Test EVEN parity
    parity_type = 2'b10;
    data_in = 8'b10101010; // 4 ones (even), so parity bit should be 0 for EVEN parity
    #10;
    data_in = 8'b10101011; // 5 ones (odd), so parity bit should be 1 for EVEN parity
    #10;

    // Test default case
    parity_type = 2'b00;
    data_in = 8'b11110000;
    #10;

    // End simulation
    $stop;
  end

endmodule
