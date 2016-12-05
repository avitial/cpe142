/* 3 to 1 multiplexer module (mux3to1.v) outputs the corresponding signal based on the selection signal received. 
*/
module mux3to1(a, b, c, out, sel);
	input [3:0] a;
	input [3:0] b;
	input [3:0] c;
	input [1:0] sel;
	output [3:0] out;
	reg [3:0] out;
	always @ (sel or a or b or c)
	begin
		case(sel)
			0: out = a;
			1: out = b;
			2: out = c;
			`ifdef DEBUG
				default: $display("Debug msg: there was an error triggered in the program.");
			`endif
		endcase
	end
endmodule
