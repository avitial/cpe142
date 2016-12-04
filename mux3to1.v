/* 3 to 1 multiplexer module (mux3to1.v) outputs the corresponding signal based on the selection signal received. 
*/
module mux3to1(a, b, c, out, sel);
	input a, b, c;
	input [1:0] sel;
	output out;
	reg out;
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
