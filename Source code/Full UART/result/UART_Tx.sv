`include "Baud_Gen_Tx.sv"
`include "Parity_Bit.sv"
`include "PISO.sv"


module UART_Tx(
  input logic clk,
  input logic rst_n,
  input logic send,
  input logic [1:0] parity_type,
  input logic [1:0] baud_rate,
  input logic [7:0] data_in,
  
  output logic data_tx,
  output logic active_flag,
  output logic done_flag

);
  logic baud_clock;
  logic parity_bit_w;
  BaudGenTx unit1(
    .rst_n(rst_n),
    .clk(clk),
    .baud_rate(baud_rate),
    .baud_clk(baud_clock)
  );
  
  Parity_Bit unit2 (
    .data_in(data_in),
    .parity_type(parity_type),
    .rst_n(rst_n),
    .parity_bit(parity_bit_w)
  );
  
  PISO unit3 (
    .baud_clk(baud_clock),
    .rst_n(rst_n),
    .send(send),
    .parity_bit(parity_bit_w),
    .data_in(data_in),
    .data_tx(data_tx),
    .active_flag(active_flag),
    .done_flag(done_flag)
  );
  
endmodule: UART_Tx