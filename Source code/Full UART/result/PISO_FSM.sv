module FSM(
  input wire baud_clk,
  input wire rst_n,
  input wire send,
  input wire count_full,
  
  output reg load,
  output reg shift
);
  typedef enum logic [1:0] {
    IDLE,
    ACTIVE
  } PISO_State;
  
  PISO_State current_state, next_state;

  typedef struct packed {
  logic load_signal;
  logic shift_signal;
  }signal_t;
  signal_t current_signal, next_signal;

   always_ff @(posedge baud_clk or negedge rst_n) begin : fsm_ff_proc
    if (!rst_n) begin
      current_state <= IDLE;
      current_signal.load_signal<=1'b0;
      current_signal.shift_signal<=1'b0;
    end else begin
      current_state <= next_state;
      current_signal<=next_signal;
    end
  end : fsm_ff_proc
  
  always_comb begin : fsm_comb_proc
    next_state = current_state; 
    next_signal.load_signal=1'b0;
    next_signal.shift_signal=1'b0;
    case (current_state)
      IDLE: begin
        if (send == 1) begin
          next_state = ACTIVE;
          next_signal.load_signal=1'b0;
    	  next_signal.shift_signal=1'b1;
        end else begin
          next_state = IDLE;
          next_signal=current_signal;
        end
      end
      ACTIVE: begin
        if (count_full) begin
          next_state = IDLE;
          next_signal.load_signal=1'b1;
    	  next_signal.shift_signal=1'b0;
        end else begin
          next_state = ACTIVE;
          next_signal=current_signal;
        end
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end : fsm_comb_proc
  assign load=current_signal.load_signal;
  assign shift=current_signal.shift_signal;
  
endmodule: FSM