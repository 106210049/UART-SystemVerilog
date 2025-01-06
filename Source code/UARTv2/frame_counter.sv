module Frame_counter(
  input wire baud_clk,
  input wire rst_n,
  input wire [1:0] current_state,
  input wire [3:0] stop_count,
  
  output reg [3:0] frame_count
);
  always @(posedge baud_clk or negedge rst_n) begin
    if (!rst_n) begin
      frame_count <= 4'd0;  // Reset frame count
    end else if (current_state == 2'b10) begin
      if (frame_count == 4'd10)
        frame_count <= 4'd0;  // Reset when reaching the limit
      else	if(stop_count == 4'd14)	begin
        frame_count <= frame_count + 1;  // Increment frame count
      end
      else begin
        frame_count <= frame_count;
      end
    end
  end
endmodule: Frame_counter
