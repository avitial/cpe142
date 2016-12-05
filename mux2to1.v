/* 2 to 1 multiplexer module (mux2to1.v) outputs the corresponding signal based on the selection signal received. 
*/
module mux2to1(a, b, out, sel);
	input a, b, sel;
	output out;
	reg out;
  always @ (sel or a or b)
	begin
		case(sel)
			0: out = a;
			1: out = b;
			`ifdef DEBUG
				default: $display("Debug msg: there was an error triggered in the program.");
			`endif
		endcase
	end
endmodule
