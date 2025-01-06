module SIPO(
  input wire baud_clk,
  input wire rst_n,
  input wire data_tx,
  input wire [1:0] current_state,
  input wire shift,
  
  output reg [10:0] data_parll_temp
);
  reg [10:0] temp;
  always@(posedge baud_clk or negedge rst_n)	begin
    if(!rst_n)	begin
      data_parll_temp<={11{1'b1}};
    end
    else begin
      if(current_state==2'b10||current_state==2'b11)	begin
        temp <= data_parll_temp;
      end
      else	begin
        temp <=temp;
      end
    end
  end
  always@(posedge shift or negedge rst_n)	begin
    if(!rst_n)	begin
      data_parll_temp<={11{1'b1}};
    end
    else	begin
    if(shift)	begin
      	data_parll_temp     <= temp >> 1;
        data_parll_temp[10] <= data_tx;
    end
    else	begin
      data_parll_temp  <= temp;
    end
   end
  end
endmodule: SIPO