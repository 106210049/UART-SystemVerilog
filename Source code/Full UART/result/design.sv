// Code your design here
`include "UART_Tx.sv"
`include "UART_Rx.sv"

module UART (
    input   logic         rst_n,       //  Active low reset.
    input   logic         send,          //  An enable to start sending data.
    input   logic         clk,         //  The main system's clock.
    input   logic  [1:0]  parity_type,   //  Parity type agreed upon by the Tx and Rx units.
    input   logic  [1:0]  baud_rate,     //  Baud Rate agreed upon by the Tx and Rx units.
    input   logic  [7:0]  data_in,       //  The data input.

    output  logic         tx_active_flag, //  outputs logic 1 when data is in progress.
    output  logic         tx_done_flag,   //  Outputs logic 1 when data is transmitted
    output  logic         rx_active_flag, //  outputs logic 1 when data is in progress.
    output  logic         rx_done_flag,   //  Outputs logic 1 when data is recieved
    output  logic  [7:0]  data_out,       //  The 8-bits data separated from the frame.
    output  logic  [2:0]  error_flag
    
);

//  logics for interconnection
logic        data_tx_w;        //  Serial transmitter's data out.

//  Transmitter unit instance
UART_Tx Transmitter(
    //  Inputs
  	.rst_n(rst_n),
    .send(send),
  	.clk(clk),
    .parity_type(parity_type),
    .baud_rate(baud_rate),
    .data_in(data_in),

    //  Outputs
    .data_tx(data_tx_w),
    .active_flag(tx_active_flag),
    .done_flag(tx_done_flag)
);

//  Reciever unit instance
UART_Rx Reciever(
    //  Inputs
  	.rst_n(rst_n),
    .clk(clk),
    .parity_type(parity_type),
    .baud_rate(baud_rate),
    .data_tx(data_tx_w),

    //  Outputs
    .data_out(data_out),
    .error_flag(error_flag),
    .active_flag(rx_active_flag),
    .done_flag(rx_done_flag)
);

endmodule: UART