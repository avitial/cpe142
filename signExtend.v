/* The sign extension Verilog module (signExtend.v) of the pipelined datapath is designed to extend an 8-bit wide value into a 16-bit wide value by
   adding the upper byte with either zeros or ones depending of the value's sign that is being extended. Also important to note the
   sign extend module is dependent on the instruction type received. 
*/
module signExtend(sExtend, instType, sExtended);
	input[11:0] sExtend;	
	input[1:0] instType;

	output[15:0] sExtended;
	reg [15:0] sExtended;
	
	always @(*)
	begin
		case(instType)
			0: sExtended = {{12{1'b0}},sExtend[7:4]};
			1: sExtended = {{12{sExtend[3]}},sExtend[3:0]};
			2: sExtended = {{8{sExtend[7]}},sExtend[7:0]};
			3: sExtended = {{4{sExtend[11]}},sExtend[11:0]};
			`ifdef DEBUG
				default: $display("Debug msg: there was an error triggered in the program.");
			`endif
		endcase
	end
endmodule
