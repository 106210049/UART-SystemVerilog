module PISO_reg(
  input wire baud_clk,
  input wire rst_n,
  input wire load,
  input wire shift,
  input wire [3:0] stop_count,
  input wire [10:0] data_frame_r,
  
  output reg data_tx,
  output reg done_flag,
  output reg active_flag
);
  reg [10:0] data_frame_man;

  always_ff @(posedge baud_clk or negedge rst_n) begin : Transmission
    if (!rst_n) begin
      data_tx <= 1'b1;
      data_frame_man <= {11{1'b1}};
      active_flag <= 1'b0;
      done_flag <= 1'b0;
    end else if (shift & (|stop_count)) begin
      data_tx <= data_frame_man[0];
      data_frame_man <= data_frame_man >>1;
      active_flag <= 1'b1;
      done_flag <= 1'b0;
    end else begin // IDLE
      data_tx <= 1'b1;
      data_frame_man <= data_frame_r;
      active_flag <= 1'b0;
      done_flag <= 1'b1;
    end
  end : Transmission

endmodule: PISO_reg
