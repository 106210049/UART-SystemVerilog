`timescale 1ns / 1ps

module tb_PISO;

  // Inputs
  reg baud_clk;
  reg rst_n;
  reg send;
  reg parity_bit;
  reg [7:0] data_in;

  // Outputs
  wire data_tx;
  wire active_flag;
  wire done_flag;

  // Instantiate the PISO module
  PISO uut (
    .baud_clk(baud_clk),
    .rst_n(rst_n),
    .send(send),
    .parity_bit(parity_bit),
    .data_in(data_in),
    .data_tx(data_tx),
    .active_flag(active_flag),
    .done_flag(done_flag)
  );

  // Generate a clock signal
  always #5 baud_clk = ~baud_clk;

  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    // Initialize Inputs
    baud_clk = 0;
    rst_n = 0;
    send = 0;
    parity_bit = 0;
    data_in = 8'b0;

    // Apply reset
    #20;
    rst_n = 1;

    // Load data and send
    data_in = 8'b10101010;
    parity_bit = 1'b1;
    send = 1;
    #10;
    send = 0;
    
    // Wait for transmission to complete
    #200;
    
    // Another transmission
    data_in = 8'b11001100;
    parity_bit = 1'b0;
    send = 1;
    #10;
    send = 0;
    
    // Wait for transmission to complete
    #200;

    // End simulation
    $stop;
  end
endmodule
