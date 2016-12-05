module fwdUnit(ALUSrc1, ALUSrc2, memRegWrite, wbRegWrite, MEMRegRd, WBRegRd, EXregR1, EXregR2);

	// Input Ports
	input[3:0] MEMRegRd, WBRegRd, EXregR1, EXregR2;
	input memRegWrite, wbRegWrite;
	// Output Ports
	output[1:0] ALUSrc1, ALUSrc2;

	reg[1:0] ALUSrc1, ALUSrc2;
	
	// ALU Source 1
	always@(*)
	begin
		if((memRegWrite)&&(MEMRegRd != 0)&&(MEMRegRd==EXregR1))
			ALUSrc1 = 2’b10;
		else if((wbRegWrite)&&(WBRegRd != 0)&&(WBRegRd==EXregR1)&&(MEMRegRd!=EXregR1)) 
			ALUSrc1 = 2'b01;		else			ALUSrc1 = 2'b00;	end
	
	// ALU Source 2 
	always(*)
	begin
		if((wbRegWrite)&&(WBRegRd!=0)&&(WBRegRd==EXregR2)&&(MEMRegRd!=EXRegRt))
			ALUSrc2 = 2’b01;
		else if((memRegWrite)&&(MEMRegRg!=0)&&(MEMRegRd==ExRegR2))
			ALUSrc2 = 2’b10;
		else
			ALUSrc2 = 2’b00;
		end

endmodule
