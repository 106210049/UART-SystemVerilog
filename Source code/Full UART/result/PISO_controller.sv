// Code your design here
`include "PISO_FSM.sv"
`include "PISO_counter.sv"
module controller(
  input wire baud_clk,
  input wire rst_n,
  input wire send,
  
  output reg load,
  output reg shift,
  output reg [3:0] stop_count
  
);
  reg count_full,shift_signal,load_signal;
  FSM fsm_inst(							// FSM instance to give control signal
    .baud_clk(baud_clk),
    .rst_n(rst_n),
    .send(send),
    .count_full(count_full),
    .load(load_signal),
    .shift(shift_signal)
  );
  counter counter_inst(				// Counter to check 11 bit data transmision
    .baud_clk(baud_clk),
    .rst_n(rst_n),
    .load(load_signal),
    .shift(shift_signal),
    
    .stop_count(stop_count),
    .count_full(count_full)
  );
  
  assign load=load_signal;
  assign shift=shift_signal;
endmodule: controller