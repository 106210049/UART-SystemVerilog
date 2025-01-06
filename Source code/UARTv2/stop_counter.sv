module Stop_counter(
  input wire baud_clk,
  input wire rst_n,
  input wire [1:0] current_state,
  
  output reg [3:0] stop_count
);
  // Parameterized threshold values for flexibility
  parameter STOP_THRESHOLD_1 = 4'd6;
  parameter STOP_THRESHOLD_2 = 4'd14;

  always @(posedge baud_clk or negedge rst_n) begin
    if (!rst_n) begin
      stop_count <= 4'd0;  // Reset stop count
    end else if (current_state == 2'b01 && stop_count == STOP_THRESHOLD_1) begin
      stop_count <= 4'd0;  // Reset when threshold 1 is reached
    end else if (current_state == 2'b10 && stop_count == STOP_THRESHOLD_2) begin
      stop_count <= 4'd0;  // Reset when threshold 2 is reached
    end else if (current_state == 2'b10 || current_state == 2'b01) begin
      stop_count <= stop_count + 1;  // Increment stop count
    end
  end
endmodule: Stop_counter
