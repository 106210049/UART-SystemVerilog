// Code your design here
`include "SIPO_Controller.sv"
`include "SIPO.sv"
module SIPO_top(
  input wire baud_clk,
  input wire rst_n,
  input wire data_tx,
  
  output reg [10:0] data_parll,
  output wire recieved_flag,
  output wire active_flag
);
  reg [3:0] frame_count;
  reg [1:0] next_state,current_state;
  reg [10:0] data_parll_temp;
  wire shift;
  SIPO_Controller sipo_controller_inst(
        .baud_clk(baud_clk),
        .rst_n(rst_n),
        .data_tx(data_tx),
        .frame_count(frame_count),
        .next_state(next_state),
      	.current_state(current_state),
      	.shift(shift)
    );
  SIPO sipo_inst(
    	.baud_clk(baud_clk),
        .rst_n(rst_n),
        .data_tx(data_tx),
    	.current_state(current_state),
    	.shift(shift),
    	.data_parll_temp(data_parll_temp)
  	);
  assign data_parll = (recieved_flag)? data_parll_temp: {11{1'b1}};
  assign recieved_flag = (frame_count==4'd10)? 1'b1:1'b0;
  assign active_flag = !(recieved_flag);
  
endmodule: SIPO_top

