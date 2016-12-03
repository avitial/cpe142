/* 3 to 1 multiplexer module (mux4to1.v) outputs the corresponding signal based on the selection signal received. 
*/
module mux3to1(a, b, c, out, sel);
	input a, b, c;
	input [1:0] sel;
	output out;
	reg out;
	always @ (a or b or c or sel)
	begin
		case(sel)
			0: sel = a;
			1: sel = b;
			2: sel = c;
			`ifdef DEBUG
				default: $display("Debug msg: there was an error triggered in the program.");
			`endif
		endcase
	end
endmodule
