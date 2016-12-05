/* 3 to 1 multiplexer module (opMux.v) outputs the corresponding operator for the ALU inputs (operators) based on 
   the ALU source signal received by the forwarding unit. 
*/
module opMux(a, b, c, op, ALUSrc);
	// Input Ports
	input [1:0] ALUSrc;
	input [15:0] a;
	input [15:0] b;
	input [15:0] c;
	// Output Ports
	output [15:0] op;
	reg [15:0] op;

	always @ (ALUSrc or a or b or c)
	begin
		case(ALUSrc)
			0: op = a;
			1: op = b;
			2: op = c;
			`ifdef DEBUG
				default: $display("Debug msg: there was an error triggered in the program.");
			`endif
		endcase
	end
endmodule
