/* This module initializes the instruction memory block from the pipelined datapath. This instruction memory moduleis the part of the datapath that 
   stores all the instructions (program) that wil be executed. In this case, the instructions that have been stored are instructions provided 
   in the requirements provided by Dr. Arad
*/
module instMem(rdAddr,inst);
	// Input/Output Ports
	input[15:0]rdAddr;
	output[15:0]inst;
	// Variables
	reg [15:0]inst;

	always@(*)
	begin
		case(rdAddr)
											//	Address	Instruction
			16'h0000:	inst=16'hF120;		//		0	ADD R1, R2
			16'h0002:	inst=16'hF121;		//		2	SUB R1, R2
			16'h0004:	inst=16'h93FF;		//		4	ORi R3, FF
			16'h0006:	inst=16'h834F;		//		6	ANDi R3, 4F
			16'h0008:	inst=16'hF564;		//		8	MUL R5, R6
			16'h000A:	inst=16'hF515;		//		0A	DIV R5, R1
			16'h000C:	inst=16'hFFF1;		//		0C	SUB R15, R15
			16'h000E:	inst=16'hF487;		//		0E	MOV R4, R8
			16'h0010:	inst=16'hF468;		//		10	SWP R4, R6
			16'h0012:	inst=16'h84F0;		//		12	ANDi R4, F0
			16'h0014:	inst=16'hA694;		//		14	LBU R6, 4(R9)
			16'h0016:	inst=16'hB696;		//		16	SB  R6, 6(R9)
			16'h0018:	inst=16'hC696;		//		18	LW R6, 6(R9)
			16'h001A:	inst=16'h6704;		//		1A	BEQ R7, 4
			16'h001C:	inst=16'hFB10;		//		1C	ADD R11, R1
			16'h001E:	inst=16'h5705;		//		1E	BLT R7, 5
			16'h0020:	inst=16'hFB20;		//		20	ADD R11, R2
			16'h0022:	inst=16'h4702;		//		22	BGT R7, 2
			16'h0024:	inst=16'hF110;		//		24	ADD R1, R1
			16'h0026:	inst=16'hF110;		//		26	ADD R1, R1
			16'h0028:	inst=16'hC890;		//		28	LW R8, 0(R9)
			16'h002A:	inst=16'hF880;		//		2A	ADD R8, R8
			16'h002C:	inst=16'hD892;		//		2C	SW R8, 2 (R9)
			16'h002E:	inst=16'hCA92;		//		2E	LW R10, 2 (R9)
			16'h0030:	inst=16'hFCC0;		//		30	ADD R12, R12
			16'h0032:	inst=16'hFDD1;		//		32	SUB R13, R13
			16'h0034:	inst=16'hFCD0;		//		34	ADD R12, R13
			16'h0036:	inst=16'hEFFF;		//		36	????
			default: inst=16'h0000;
		endcase
	end
endmodule
