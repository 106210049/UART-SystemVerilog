module PISO(
  input logic baud_clk,
  input logic rst_n,
  input logic send,
  input logic parity_bit,
  input logic [7:0] data_in,
  
  output logic data_tx,
  output logic active_flag,
  output logic done_flag
);
  logic [10:0] data_frame_r;
  logic [10:0] data_frame_man;
  logic [3:0] stop_count;
  logic count_full;
  typedef enum logic [1:0] {
    IDLE,
    ACTIVE
  } PISO_State;
  
  PISO_State current_state, next_state;
  
  always_ff @(posedge baud_clk or negedge rst_n) begin : fsm_ff_proc
    if (!rst_n) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end : fsm_ff_proc
  
  always_comb begin : fsm_comb_proc
    next_state = IDLE;
    
    case (current_state)
      IDLE: begin
        if (send == 1) begin
          next_state = ACTIVE;
        end else begin
          next_state = IDLE;
        end
      end
      ACTIVE: begin
        if (count_full) begin
          next_state = IDLE;
        end else begin
          next_state = ACTIVE;
        end
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end : fsm_comb_proc
  
  always_ff @(posedge baud_clk or negedge rst_n) begin : Frame_Generation
    if (!rst_n) begin
      data_frame_r <= {11{1'b1}};
    end else if (current_state == ACTIVE) begin
      data_frame_r <= data_frame_r;
    end else begin
      data_frame_r <= {1'b1, parity_bit, data_in, 1'b0};
    end
  end : Frame_Generation
  
  always_ff @(posedge baud_clk or negedge rst_n) begin
    if (!rst_n || current_state == IDLE || count_full) 
      stop_count <= 4'd0;
    else 
      stop_count <= stop_count + 4'd1;
  end

  assign count_full = (stop_count == 4'd11);
  
  always_ff @(posedge baud_clk or negedge rst_n) begin : Transmission
    if (!rst_n) begin
      data_tx <= 1'b1;
      data_frame_man <= {11{1'b1}};
      active_flag <= 1'b0;
      done_flag <= 1'b0;
    end else if (current_state == ACTIVE && stop_count != 4'd0) begin
      data_tx <= data_frame_man[0];
      data_frame_man <= data_frame_man >> 1;
      active_flag <= 1'b1;
      done_flag <= 1'b0;
    end else begin
      data_tx <= 1'b1;
      data_frame_man <= data_frame_r;
      active_flag <= 1'b0;
      done_flag <= 1'b1;
    end
  end : Transmission

endmodule : PISO
