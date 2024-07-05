// Code your design here
module Error_check(
  
  input logic rst_n,
  input logic recieved_flag,
  input logic [1:0] parity_type,
  input logic start_bit,
  input logic stop_bit,
  input logic parity_bit,
  input logic [7:0] raw_data,
  
  output logic [2:0] error_flag
);
  
  logic start_error, stop_error, parity_flag;
  logic parity_error;
  localparam ODD=2'b01,
  			 EVEN=2'b10;
  
  always_comb	begin: Calculate_Parity_Bit
    case(parity_type)
      ODD:	parity_flag=(^raw_data)? 1'b0:1'b1;
      EVEN: parity_flag=(^raw_data)? 1'b1:1'b0;
      default:	parity_flag=0;
    endcase
  end: Calculate_Parity_Bit
  
  always_comb	begin: Check_error
    parity_error=(parity_flag^parity_bit);
    start_error=(start_bit|1'b0);
    stop_error=~(stop_bit&1'b1);
  end:  Check_error
  assign error_flag=(rst_n&&recieved_flag)? {stop_error,start_error,parity_error}:3'b0;
endmodule: Error_check