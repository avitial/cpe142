'include "opMux.v"

module opMux_fixture;
	
	reg clk;
	reg [1:0] ALUSrc;
	reg [15:0] a;
	reg [15:0] b;
	reg [15:0] c;
	wire [15:0] op;
	
	initial
	$vcdpluson;
	
	initial
		$monitor($time,"| %b | %b |", op[3:0], ALUSrc[1:0]);

	opMux mux1(a, b, c, op, ALUSrc);
	initial
	begin
		#10
		a = 16’b0000
		b = 16’b0001
		c = 16’b0010

		ALUSrc=2’b00
		#50
		ALUSrc=2’b01
		#50
		ALUSrc=2’b10
		#50
		ALUSrc=2’b11
		#50
	end

	initial
	begin
		clk = 1’b0;
		forever #10 clk=~clk;
	end
	
	initial
	begin
		$display(“\t\ttime| op |ALUSrc |”);
		#500 $finish;
	end
endmodule
