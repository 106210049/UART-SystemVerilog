module Frame_Gen(
  input wire baud_clk,
  input wire rst_n,
  input wire load,
  input wire shift,
  input wire [7:0] data_in,
  input wire parity_bit,
  
  output reg [10:0] data_frame_r
  
);
  
  reg [10:0] data_frame;
  always_ff @(posedge baud_clk or negedge rst_n) begin : Frame_Generation
    if (!rst_n) begin
      data_frame <= {11{1'b1}};
    end else if (shift) begin
      data_frame <= data_frame;
    end else begin	//IDLE --> set lại giá giá trị truyền đi
      data_frame <= {1'b1, parity_bit, data_in, 1'b0};
    end
  end : Frame_Generation
  
  assign data_frame_r=data_frame;
endmodule: Frame_Gen