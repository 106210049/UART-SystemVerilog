module counter(
  input wire baud_clk,
  input wire rst_n,
  input wire load,
  input wire shift,
  
  output reg [3:0] stop_count,
  output reg count_full
);
  reg [3:0] count_value;
  assign count_full=(count_value==4'd11)? 1:0;
  
  always_ff @(posedge baud_clk or negedge rst_n) begin
    if (!rst_n |load| count_full) 
      count_value <= 4'd0;
    else if(shift&(!count_full)) begin
      count_value <= count_value + 4'd1;
 	 end
    else begin
      count_value<=4'd0;
    end
  end
  assign stop_count=count_value;
  
endmodule: counter