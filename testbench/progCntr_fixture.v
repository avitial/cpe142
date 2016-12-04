// Top level stimulus module for regFile.v block
`include "progCntr.v"
module progCntr_fixture;
    // Declare variables for stimulating input
	reg clk, rst, wr;
	reg [15:0] dataIn;

	// Port Wires
	wire [15:0] cnt;

	initial
	$vcdpluson;
	initial
	$monitor($time,"| %b| %b | %b | %b |",wr,rst,dataIn[15:0],cnt[15:0]);

	// Instantiate the design block regFile
	progCntr pc1(clk,rst,wr,dataIn,cnt);

	// Drive the input signals
	initial
	begin
		#10
		rst = 1'b0;
		wr = 1'b0;
		dataIn = 16'hFFF0;
		#50;
		rst = 1'b0;
		wr = 1'b1;
		dataIn = 16'hFFF0;
		#50;
		rst = 1'b1;
		wr = 1'b0;
		dataIn = 16'hFFF0;
		#50;
		rst = 1'b1;
		wr = 1'b1;
		dataIn = 16'hFFF0;
		#50;
	end

	// Setup the clock to toggle every 10 time units
	initial
	begin
		clk = 1'b0;
		forever #10 clk = ~clk;
	end

	// Finish the simulation at time 650
	initial
	begin
		$display("\t\ttime|wr|rst|       dataIn     |        cnt       |");
		#650 $finish;
	end
endmodule
