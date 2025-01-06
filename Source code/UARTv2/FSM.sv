module SIPO_FSM(
  input wire baud_clk,
  input wire rst_n,
  input wire data_tx,
  input wire [3:0] stop_count,
  input wire [3:0] frame_count,
  
  output reg [1:0] next_state,
  output reg [1:0] current_state,
  output wire shift
);

  reg current_signal, next_signal;
typedef enum logic [1:0] {
        IDLE,
        CENTER,
        FRAME,
        GET
    } SIPO_State;

    SIPO_State state, next;

    always_ff @(posedge baud_clk or negedge rst_n) begin
      if (!rst_n)	begin
            state <= IDLE;
      		current_signal<=1'b0;
      end
        else	begin
            state <= next;
      		current_signal<= next_signal;
        end
    end

    always_comb begin
        next = IDLE;
      	next_signal=1'b0;
        case (state)
          IDLE:   begin   next = (~data_tx) ? CENTER : IDLE;	next_signal=1'b0; end
          CENTER: begin   next = (stop_count == 4'd6) ? GET : CENTER; 
            			  next_signal=(stop_count == 4'd6) ? 1'b1 : 1'b0; end
          FRAME:  begin   next = (frame_count == 4'd10) ? IDLE : (stop_count == 4'd14) ? GET : FRAME; 
            			  next_signal= (frame_count == 4'd10) ? IDLE : (stop_count == 4'd14) ? 1'b1 : 1'b0; end
          GET:    begin   next = FRAME;	next_signal= 1'b0;	 end
         default: begin   next = IDLE; next_signal=1'b0;	end
        endcase
    end

    assign current_state = state;
    assign next_state    = next;
  	assign shift = current_signal;

endmodule: SIPO_FSM