// Code your design here
module DeFrame(
    input logic  [10:0]  data_parll,     //  Data frame passed from the sipo unit.
    input logic          recieved_flag,

    output logic          parity_bit,     //  The parity bit separated from the data frame.
    output logic          start_bit,      //  The Start bit separated from the data frame.
    output logic          stop_bit,       //  The Stop bit separated from the data frame.
    output logic          done_flag,      //  Indicates that the data is recieved and ready for another data packet.
    output logic  [7:0]   raw_data        //  The 8-bits data separated from the data frame.
);

//  Deframing 
always_comb	 
begin: deframing_proc
  start_bit       = data_parll[0];
  raw_data[7:0]   = data_parll[8:1];
  parity_bit      = data_parll[9];
  stop_bit        = data_parll[10];
  done_flag       = recieved_flag;
end: deframing_proc

endmodule