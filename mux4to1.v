/* 4 to 1 multiplexer module (mux4to1.v) outputs the corresponding signal based on the selection signal received. 
*/
module mux4to1(a, b, c, d, out, sel);
	input [15:0] a;
	input [15:0] b;
	input [15:0] c;
	input [15:0] d;
	input [1:0] sel;

	output [15:0] out;
	reg [15:0] out;
	always @ (sel or a or b or c or d)
	begin
		case(sel)
			0: out = a;
			1: out = b;
			2: out = c;
			3: out = d;
			`ifdef DEBUG
				default: $display("Debug msg: there was an error triggered in the program.");
			`endif
		endcase
	end
endmodule
