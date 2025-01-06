`include "FSM.sv"
`include "frame_counter.sv"
`include "stop_counter.sv"
module SIPO_Controller(
  input wire baud_clk,
  input wire rst_n,
  input wire data_tx,
  
  output reg [3:0] frame_count,
  output reg [1:0] next_state,
  output reg [1:0] current_state,
  output wire shift
);
  reg [3:0] stop_count;
  
  SIPO_FSM fsm_inst(
    .baud_clk(baud_clk),
    .rst_n(rst_n),
    .data_tx(data_tx),
    .stop_count(stop_count),
    .frame_count(frame_count),
    
    .next_state(next_state),
    .current_state(current_state),
    .shift(shift)
  );
  
  Frame_counter frame_counter_inst(
    .baud_clk(baud_clk),
    .rst_n(rst_n),
    .current_state(current_state),
    .stop_count(stop_count),
    .frame_count(frame_count)
  );
  
  Stop_counter stop_counter_inst(
    .baud_clk(baud_clk),
    .rst_n(rst_n),
    .current_state(current_state),
    .stop_count(stop_count)
  );
endmodule: SIPO_Controller