// Top level stimulus module for regDstDataMux.v block
`include "regDstDataMux.v"
module regDstDataMux_fixture;
    // Declare variables for stimulating input
	reg clk;
	reg [15:0] a;
	reg [15:0] b;
	reg [15:0] c;
	reg [15:0] d;
	reg [1:0] sel;

	// Port Wires
	wire [15:0] out;

	initial
	$vcdpluson;
	initial
	$monitor($time,"| %b | %b |", out[15:0], sel[1:0]);

	// Instantiate the design block regFile
	regDstDataMux mux1(a, b, c, d, out, sel);

	// Drive the input signals
	initial
	begin
		#10
		a = 16'h000A;
		b = 16'h00A0;
		c = 16'h0A00;
		d = 16'hA000;
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
		$display("\t\ttime|        out       |sel |");
		#650 $finish;
	end
endmodule
