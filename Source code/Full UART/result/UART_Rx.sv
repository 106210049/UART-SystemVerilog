`include"SIPO.sv"
`include"Error_Check.sv"
`include"Deframe.sv"
`include"BaudGen_Rx.sv"
module UART_Rx(
    input logic         rst_n,        // Active low reset.
    input logic         data_tx,      // Serial data received from the transmitter.
    input logic         clk,        // The System's main clock.
    input logic  [1:0]  parity_type,  // Parity type agreed upon by the Tx and Rx units.
    input logic  [1:0]  baud_rate,    // Baud Rate agreed upon by the Tx and Rx units.

    output logic        active_flag,  // Outputs logic 1 when data is in progress.
    output logic        done_flag,    // Outputs logic 1 when data is received.
    output logic [2:0]  error_flag,   // Three bits for different error flags.
    output logic [7:0]  data_out      // The 8-bit data separated from the frame.
);

// Intermediate signals
logic baud_clk_w;          // Clocking signal from the baud generator.
logic [10:0] data_parll_w; // Parallel data from the SIPO unit.
logic recieved_flag_w;     // Enable signal for the DeFrame unit.
logic def_par_bit_w;       // Parity bit from the DeFrame unit.
logic def_strt_bit_w;      // Start bit from the DeFrame unit.
logic def_stp_bit_w;       // Stop bit from the DeFrame unit.

// Baud Rate Generator Instance
BaudGenRx Unit1(
    .rst_n(rst_n),
    .clk(clk),
    .baud_rate(baud_rate),
    .baud_clk(baud_clk_w)
);

// Serial-In Parallel-Out Shift Register Instance
SIPO Unit2(
    .rst_n(rst_n),
    .data_tx(data_tx),
    .baud_clk(baud_clk_w),
    .active_flag(active_flag),
    .recieved_flag(recieved_flag_w),
    .data_parll(data_parll_w)
);

// DeFrame Unit Instance
DeFrame Unit3(
    .data_parll(data_parll_w),
    .recieved_flag(recieved_flag_w),
    .parity_bit(def_par_bit_w),
    .start_bit(def_strt_bit_w),
    .stop_bit(def_stp_bit_w),
    .done_flag(done_flag),
    .raw_data(data_out)
);

// Error Checking Unit Instance
Error_check Unit4(
    .rst_n(rst_n),
    .recieved_flag(done_flag),
    .parity_bit(def_par_bit_w),
    .start_bit(def_strt_bit_w),
    .stop_bit(def_stp_bit_w),
    .parity_type(parity_type),
    .raw_data(data_out),
    .error_flag(error_flag)
);

endmodule
