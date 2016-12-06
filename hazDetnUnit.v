module	hazDetnUnit(regR1, regR2, EXregR2, rdR1rdR15comp, IDEXMemRead, wrPC, IFIDWrite, halt);

	input [3:0]regR1, regR2, EXregR2, rdR1rdR15comp;
	input IDEXMemRead;
	output wrPC, IFIDWrite, halt;

	reg wrPC, IFIDWrite, halt;
	always@(*)
		if((regR1 == rdR1rdR15comp || regR2 == rdR1rdR15comp) && IDEXMemRead;
			begin // halt
				wrPC = 1'b0;
				IFIDWrite = 1'b0;
				halt = 1'b1;
			end
		else
			begin // no halt
				wrPC = 1'b1;
				IFIDWrite = 1'b1;
				halt = 1'b0;
			end

endmodule
