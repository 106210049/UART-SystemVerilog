
// Code your design here
`include "PISO_controller.sv"
`include "PISO_Frame_Gen.sv"
`include "PISO.sv"
module PISO_top(
  input wire baud_clk,
  input wire rst_n,				//  Active low reset.
  input wire send,				//  An enable to start sending data.
  input wire [7:0] data_in,		//  The data input.
  input wire parity_bit,
  
  output reg active_flag,
  output reg done_flag,
  output reg data_tx
);
  
  reg [10:0] data_frame_r;
  reg [3:0] stop_count;
  
  controller controller_inst (		// Controller Instance
    .baud_clk(baud_clk),
    .rst_n(rst_n),
    .send(send),
    .load(load),
    .shift(shift),
    .stop_count(stop_count)
  );
  
  Frame_Gen frame_gen_inst(			// Frame Generation
     .baud_clk(baud_clk),
     .rst_n(rst_n),
     .load(load),
     .shift(shift),
     .data_in(data_in),
     .parity_bit(parity_bit),
     .data_frame_r(data_frame_r)
   );
  
  PISO_reg piso_reg_inst(			// PISO shift reg
     .baud_clk(baud_clk),
     .rst_n(rst_n),
     .load(load),
     .shift(shift),
     .stop_count(stop_count),
     .data_frame_r(data_frame_r),
     .data_tx(data_tx),
     .active_flag(active_flag),
     .done_flag(done_flag)
    
  );
  
endmodule: PISO_top