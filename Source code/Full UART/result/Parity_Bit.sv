module Parity_Bit(
  input logic [7:0] data_in,
  input logic [1:0] parity_type,
  input logic rst_n,
  output logic parity_bit
);

  localparam ODD  = 2'b01,
             EVEN = 2'b10;

  always_comb begin : Cal_Parity_bit
    if (!rst_n) begin
      parity_bit = 0;
    end else begin
      case (parity_type)
        ODD:  parity_bit = (^data_in) ? 1'b0 : 1'b1;
        EVEN: parity_bit = (^data_in) ? 1'b1 : 1'b0;
        default: parity_bit = 1'b1;
      endcase
    end
  end : Cal_Parity_bit
endmodule : Parity_Bit
