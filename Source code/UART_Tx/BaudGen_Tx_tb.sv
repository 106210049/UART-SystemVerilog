
`timescale 1ns/1ps
module BaudTest;

//  Regs to drive the inputs
reg       rst_n;
reg       clk;
reg [1:0] baud_rate;

//  wires to show the outputs
wire      baud_clk;

//  Instance of the design module
BaudGenTx ForTest(
    .rst_n(rst_n),
    .clk(clk),
    .baud_rate(baud_rate),
    
    .baud_clk(baud_clk)
);

//  dump
initial
begin
    $dumpfile("BaudTest.vcd");
    $dumpvars;
end

//  System's Clock 50MHz
initial begin
                clk = 1'b0;
    forever #10 clk = ~clk;
end

//  Resetting the system
initial begin
        rst_n = 1'b0;
    #100  rst_n = 1'b1;
end

//  Test
integer i = 0;
initial 
begin
    //  Testing for all the rates available
    for (i = 0; i < 4; i = i +1) 
    begin
        baud_rate = i;
        //  enough time for about 4 cycles for each baud rate
        #(1680000/(i+1));
    end
end

//  Stop
initial begin
    #3500000 $stop;
    // Simulation for 4 ms
end

endmodule
