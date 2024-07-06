module SIPO(
    input  logic         rst_n,         // Active low reset.
    input  logic         data_tx,       // Serial Data received from the transmitter.
    input  logic         baud_clk,      // The clocking input comes from the sampling unit.

    output logic         active_flag,   // Outputs logic 1 when data is in progress.
    output logic         recieved_flag, // Outputs a signal enables the deframe unit. 
    output logic [10:0]  data_parll     // Outputs the 11-bit parallel frame.
);

    logic [10:0] data_parll_temp, temp;
    logic [3:0] frame_count, stop_count;
  
  typedef enum logic [1:0] {
        IDLE,
        CENTER,
        FRAME,
        GET
    } SIPO_State;
  
    SIPO_State current_state, next_state;
  
    // FSM state transition
    always_ff @(posedge baud_clk or negedge rst_n) begin: fsm_ff_proc
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end: fsm_ff_proc
  
  always_ff@(posedge baud_clk or negedge rst_n)	begin: counter
    if(!rst_n)	begin
      stop_count<=0;
      frame_count<=0;
    end
    else	begin
      if(current_state==IDLE)	begin
        temp          <= {11{1'b1}};
        stop_count    <= 4'd0;
        frame_count <= 4'd0;
      end
      else begin
        stop_count    <= stop_count;
        frame_count <= frame_count;
      end
      if(current_state==FRAME||current_state==GET)	begin
        temp <= data_parll_temp;
      end
      else	begin
        temp <=temp;
      end

      if(current_state==CENTER)	begin
        if(stop_count==4'd6)	begin
          stop_count<=0;
        end
        else	begin
          stop_count<=stop_count+1'b1;
        end
      end
      else if(current_state==FRAME)	begin
        if(frame_count==4'd10)	begin
        	frame_count<=0;
      	end
        else	begin
          if(stop_count==4'd14)	begin
            frame_count<=frame_count+1'b1;
          	stop_count<=0;
          end
          else	begin
            stop_count<=stop_count+1'b1;
          	frame_count<=frame_count;
          end
        end
      end
      else	begin
        stop_count    <= stop_count;
        frame_count <= frame_count;
      end
      
    end
    
  end: counter
   
  always_comb	begin: fsm_comb_proc
    next_state=IDLE;
    
    case(current_state)
      IDLE:	begin
        if(~data_tx)	begin
          next_state=CENTER;
        end
        else	begin
          next_state=IDLE;
        end
      end
      CENTER:	begin
        if(stop_count == 4'd6)	begin
          next_state=GET;
        end
        else	begin
          next_state=CENTER;
        end
      end
      FRAME:	begin
        if(frame_count==4'd10)	begin
          next_state=IDLE;
        end
        else	begin
          if(stop_count==4'd14)	begin
            next_state=GET;
          end
          else	begin
            next_state=FRAME;
          end
        end
      end
      GET:	begin
       	next_state=FRAME;
      end
    endcase
  end: fsm_comb_proc
  
  
  always_comb begin
    case (current_state)
    IDLE, CENTER, FRAME: data_parll_temp  = temp;

    GET : begin
      data_parll_temp    = temp >> 1;
      data_parll_temp[10] = data_tx;
    end
  endcase
end
    // Assigning parallel data output
    assign data_parll = recieved_flag ? data_parll_temp : {11{1'b1}};
  
    // Flags for active and received states
    assign recieved_flag = (frame_count == 4'd10);
    assign active_flag = !recieved_flag;

    
  
endmodule: SIPO
