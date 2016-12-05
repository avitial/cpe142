// Top level stimulus module for mux3to1.v block
`include "regDstMux.v"
module regDstMux_fixture;
    // Declare variables for stimulating input
	reg clk;
	reg [3:0] a;
	reg [3:0] b;
	reg [3:0] c;
	reg [1:0] sel;

	// Port Wires
	wire [3:0] out;

	initial
	$vcdpluson;
	initial
	$monitor($time,"| %b | %b |", out[3:0], sel[1:0]);

	// Instantiate the design block regFile
	regDstMux mux1(a, b, c, out, sel);

	// Drive the input signals
	initial
	begin
		#10
		a = 4'b0000;
		b = 4'b0001;
		c = 4'b0010;
		sel = 2'b00;
		#50;
		sel = 2'b01;
		#50;		
		sel = 2'b10;
		#50;		
		sel = 2'b11;
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
		$display("\t\ttime| out  |sel |");
		#650 $finish;
	end
endmodule
