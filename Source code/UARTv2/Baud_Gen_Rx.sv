// Code your design here
module BaudGenRx (
    input logic clk,
    input logic [1:0] baud_rate,
    input logic rst_n,
    output logic baud_clk
);
  logic [10:0] final_value;
  logic [10:0] clock_count;

    localparam BAUD24  = 2'b00,
               BAUD48  = 2'b01,
               BAUD96  = 2'b10,
               BAUD192 = 2'b11;

    always_comb begin : Baud_rate_mux
        case (baud_rate)
           BAUD24: final_value  = 10'd651;     //  16 * 2400 BaudRate.
           BAUD48: final_value  = 10'd326;     //  16 * 4800 BaudRate.
           BAUD96: final_value  = 10'd163;     //  16 * 9600 BaudRate.
           BAUD192: final_value = 10'd81;      //  16 * 19200 BaudRate.
           default: final_value = 10'd163;     //  16 * 9600 BaudRate.
        endcase
    end : Baud_rate_mux

    always_ff @(posedge clk or negedge rst_n) begin : ff_counter
        if (!rst_n) begin
            clock_count <= 11'd0;
            baud_clk <= 1'b0;
        end else begin
            if (clock_count == final_value) begin
                clock_count <= 11'd0;
                baud_clk <= ~baud_clk;
            end else begin
                clock_count <= clock_count + 1'd1;
                baud_clk <= baud_clk;
            end
        end
    end : ff_counter
endmodule : BaudGenRx