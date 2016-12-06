/* Top Level */

'include “alu.v”
‘include “comptr.v”
‘include “ctrlUnit.v”  // still needs revision
‘include “dataMem.v”
‘include “fwdUnit.v”
‘include “hazDetnUnit.v”
‘include “instMem.v”
‘include “mux2to1.v”
‘include “opMux.v”
‘include “progCntr.v”
‘include “regDstDataMux.v”
‘include “regDstMux.v”
‘include “regFile.v”
‘include “signExtend.v”

module cpu(clk, rst);
	input clk, rst;

 




endmodule


/* The Arithmetic Logic Unit (ALU) performs all the processes related to arithmetic and bitwise operations on integer binary numbers,
   on instruction words in this case. The ALU is what essentially makes the datapath work, it calculates the result for Type-A 
   instructions and also some of the Type-C instructions, where the use of the sign-extended (extended) value is done from the
   sign-extend module (signExtend.v).
*/
module alu(op1,op2,extended,aluDecr,ALUSrc,aluCtrl,aluRslt, aluRsltR15, ovExcep);
	// Input Ports
	input ALUSrc,aluCtrl;
	input [15:0] op1;
	input [15:0] op2;
	input [15:0] extended;
	input [3:0] aluDecr;
	// Output ports
	output reg [31:0] aluRslt;
	output reg [15:0] aluRsltR15;
	output wire  ovExcep;
	// Variables
	reg ovFlowSE;
	wire ovFlow;
	wire [15:0] aluOp1;
	wire [15:0] aluOp2;

	assign aluOp1 = ALUSrc ? extended:op1;
	assign aluOp2 =! ALUSrc && aluDecr[3] ? extended:op2;
	assign ovExcep = ovFlow && ovFlowSE;
	assign ovFlow = ((aluOp1[15]^~aluOp2[15])&&(aluOp1[15]^aluRslt[15]));

	always@(*)
	begin
		case({aluCtrl,aluDecr})
			5'b00000:	// Signed Addition, op1 = op1 + op2
			begin
				aluRslt[31:16]={16{1'b0}};
				aluRslt[15:0]=aluOp1+aluOp2;
				ovFlowSE=1'b1;
			end
			5'b00001:	// Signed Subtraction, op1 = op1 - op2
			begin
				aluRslt[31:16]={16{1'b0}};
				aluRslt[15:0]=aluOp1-aluOp2;
				ovFlowSE=1'b1;
			end
			5'b00100:	// Signed Multiplication, op1 = op1 * op2, op1 != R15
			begin
				aluRslt[31:0]=aluOp1*aluOp2;
				aluRsltR15[15:0]=aluRslt[31:16];
				ovFlowSE=1'b0;
			end
			5'b00101:	// Signed Division, op1 = op1 / op2, op1 != R15
			begin
				aluRslt[31:16]=aluOp1%aluOp2;
				aluRsltR15[15:0]=aluOp1/aluOp2;
				ovFlowSE=1'b0;
			end
			5'b00010: // AND Immediate, op1 = op1 & {8’b0, constant}
			begin
				aluRslt[31:16]={16{1'b0}};
				aluRslt[15:0]=aluOp1&aluOp2;
				ovFlowSE=1'b0;
			end
			5'b00011: // OR Immediate, op1 = op1 | {8’b0, constant}
			begin
				aluRslt[31:16]={16{1'b0}};
				aluRslt[15:0]=aluOp1|aluOp2;
				ovFlowSE=1'b0;
			end
			5'b1xxxx:	
			begin
				aluRslt[(2*15)-1:15]={15{1'b0}};
				aluRslt[15-1:0]=aluOp1 + aluOp2;
				ovFlowSE=1'b0;
			end
			default:
			begin
				aluRslt[(2*15)-1:0]={2*15{1'b0}};
				ovFlowSE=1'b0;
			end
		endcase
	end
endmodule


// Comparator 
module comptr(in1,in2,brGtr,brLte,brEq);
	// Input Ports
	input [15:0] in1;
	input [15:0] in2;
	
	// Output Ports
	output brGtr,brLte,brEq;
	
	// Variables
	reg brGtr,brLte,brEq;
	reg [15:0] tmpGtr;
	reg [15:0] tmpLte;
	reg [15:0] tmpEq;
	reg tmpEq2 [16:0];
	integer n;
	
	always@(*)
	begin
		for(n=0; n<16; n=n+1)
		begin
			tmpEq[n]=in1[n]~^in2[n];
			tmpGtr[n]=tmpEq2[n+1]&in1[n]&~in2[n];
			tmpLte[n]=tmpEq2[n+1]&~in1[n]&in2[n];
			tmpEq2[n]=tmpEq2[n+1]&tmpEq[n];
		end

		tmpEq2[16]=1'b1;
		brEq= &tmpEq;
		brGtr= |tmpGtr;
		brLte= |tmpLte;
	end
endmodule 

// Control Unit
module ctrlUnit(instType,memToReg,wr,wrR15,memRead,memWrite,branch,ALUSrc,ALUOp,setExc,opCode,funcCode);
	// Input Ports
	input[3:0] opCode;
	input[3:0] funcCode;
	// Output Ports
	output wr, wrR15, memToReg, memRead, memWrite, ALUSrc, ALUOp, setExc;
	output [1:0] instType; 
	output [2:0] branch;
	// Variables
	reg wr, wrR15, memToReg, memRead, memWrite;
	reg ALUSrc, ALUOp, setExc, typeBExc, typeAExc;
	reg[1:0] instType;
	reg[2:0] branch;
	
	always@(*)
	begin
		case(opCode)
			4'b0000: // Jump, Halt
			begin
				wr=0;
				memToReg=0;
				memRead=0;
				memWrite=0;
				instType=2'b0; // Type-D
				branch=3'b0;
				ALUSrc=0;
				ALUOp=0;
				typeBExc=0;
			end
			4'b0100: // BGE
			begin
				wr=0;
				memToReg=0;
				memRead=0;
				memWrite=0;
				instType=2'b10; // Type-C
				branch=3'b100;
				ALUSrc=0;
				ALUOp=0;
				typeBExc=0;
			end
			
			4'b0101:	// BLE
			begin
				wr=0;
				memToReg=0;
				memRead=0;
				memWrite=0;
				instType=2'b10; // Type-C
				branch=3'b101;
				ALUSrc=0;
				ALUOp=0;
				typeBExc=0;
			end

			4'b0110: 	// BEQ
			begin
				wr=0;
				memToReg=0;
				memRead=0;
				memWrite=0;
				instType=2'b10; // Type-C
				branch=3'b110;
				ALUSrc=0;
				ALUOp=0;
				typeBExc=0;				
			end

			4'b1000:	//  ANDi
			begin
				wr=0;
				memToReg=0;
				memRead=0;
				memWrite=0;
				instType=2'b10; // Type-C
				branch=3'b000;
				ALUSrc=0;
				ALUOp=0;
				typeBExc=0;	
			end

			4'b1011:
			begin
				instType=01;memToReg=0;wr=0;
				memRead=0;memWrite=1;branch=000;
				ALUSrc=1;ALUOp=1;typeBExc=0;
			end

			4'b1100:
			begin
				instType=11;memToReg=0;wr=0;
				memRead=0;memWrite=0;branch=111;
				ALUSrc=0;ALUOp=0;typeBExc=0;
			end

			4'b1111:
			begin
				instType=11;memToReg=0;wr=0;
				memRead=0;memWrite=0;branch=000;
				ALUSrc=0;ALUOp=0;typeBExc=1;
			end
			default:
			begin
				instType=11;memToReg=0;wr=0;
				memRead=0;memWrite=0;branch=000;
				ALUSrc=0;ALUOp=0;typeBExc=1;
			end
		endcase
	end

	always@(*)
		begin
		case(funcCode)
		4'b0000:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b0001:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b0010:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b0011:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b0100:
		begin
			wrR15=1;
			typeAExc=0;
		end
		4'b0101:
		begin
			wrR15=1;
			typeAExc=0;
		end
		4'b1000:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b1001:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b1010:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b1011:
		begin
			wrR15=0;
			typeAExc=0;
		end
		default:
		begin
			wrR15=0;
			typeAExc=1;
		end	 
	endcase

	assign setExc=typeBExc|typeAExc;
	end
endmodule



/* The data memory module (dataMem.v) is used for load word and store word operations (Type-B). This module behaves as main memory in the 
   cpu design, capable of writing data to the memory block in the given location (address) and also capable of reading data from memory
   in the given location (address).
*/
module dataMem(clk, rst, addr, rdData, wrData, memRead, memWrite);
	// Variables
	parameter storSize = (1 << 15);
	integer n;

	// Input ports
	input clk, rst;
	input [15:0] wrData;
	input [15:0] addr;
	input memRead, memWrite;
	
	// Output ports
	output [15:0] rdData;
	reg [15:0] locn [storSize-1:0];
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			for(n=0; n<storSize; n=n+1)
			begin
				locn[n]<=n==0?16'h2BC:{16{1'b0}};
			end
		end
		else
		begin
			if(memWrite)
			begin
				locn[addr] <=wrData;
			end
		end
	end
	assign rdData = (memRead)? locn[addr]:{16{1'bz}};
endmodule

// Forwarding Unit
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

// Hazard Detection Unit
module	hazDetnUnit(regR1, regR2, EXregR2, rdR1rdR15comp, IDEXMemRead, PCWrite, IFIDWrite, halt);

	input [3:0]regR1, regR2, EXregR2, rdR1rdR15comp;
	input IDEXMemRead;
	output PCWrite, IFIDWrite, halt;

	reg PCWrite, IFIDWrite, halt;
	always@(*)
		if((regR1 == rdR1rdR15comp || regR2 == rdR1rdR15comp) && IDEXMemRead;
			begin // halt
				PCWrite = 1'b0;
				IFIDWrite = 1'b0;
				halt = 1'b1;
			end
		else
			begin // no halt
				PCWrite = 1'b1;
				IFIDWrite = 1'b1;
				halt = 1'b0;
			end

endmodule


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


/* The program counter module (progCntr.v) specifies the location a system is in the program sequence being run. Post instruction
   fetching, the program counter is incremented and carries the most recent memory address for the following instruction that will
   be executed next.
*/
module progCntr(clk,rst,wr,dataIn,cnt);
		// Input ports
        input clk, rst, wr;
        input [15:0] dataIn;
        // Output ports
		output [15:0] cnt;
	
        reg [15:0] cnt;

        always@(posedge clk or negedge rst)
        begin
			if(~rst)
			begin
				cnt<=16'h0000;
			end
			else
			begin
				if(wr)
				begin
					cnt<=dataIn;
				end
				else
				begin
					cnt<=cnt;
				end
			end
        end
endmodule


/* 4 to 1 multiplexer module (regDstDataMux.v) outputs the corresponding signal based on the selection signal received. 
*/
module regDstDataMux(a, b, c, d, out, sel);
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


/* 3 to 1 multiplexer module (regDstMux.v) outputs the corresponding signal based on the selection signal received. 
*/
module regDstMux(a, b, c, out, sel);
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


/* This Verilog module (regFile.v)  represents the register file of the pipelined datapath. The function this module performs in the
   datapath includes the handling of read and write operations for the registers mentioned in the project design file. The module makes
   use of some control signals to enable read and write operations and the set of processor registers found in the CPU. This module
   also contains multiple ports for read and write operations and a set of registers used to phase data in between the memory and other
   sections of the datapath.
*/
module regFile(clk,rst,regR1,regR2,regDst,regDstData,regR15Data,wr,wrR15,rdR1,rdR2,rdR15);
	// Variables
	parameter regCnt=16;
	integer n;
	integer regR15=15;
	// Input ports
	input clk,rst, wr, wrR15;
	input [3:0] regR1;
	input [3:0] regR2;
	input [3:0] regDst;
	input [15:0] regDstData;
	input [15:0] regR15Data;
	//Output ports
	output reg[15:0] rdR1;
	output reg[15:0] rdR2;
	output reg[15:0] rdR15;

	reg[15:0]regData[regCnt:0];

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			for(n=0; n<regCnt; n=n+1)
			begin
				case(n)
					1:regData[n]<=16'hFFFF;
					2:regData[n]<=16'h0050;
					3:regData[n]<=16'hF033;
					4:regData[n]<=16'hF0FF;
					5:regData[n]<=16'h0040;
					6:regData[n]<=16'h6666;
					7:regData[n]<=16'h00FF;
					8:regData[n]<=16'h8888;
					9:regData[n]<=16'h0000;
					10:regData[n]<=16'h0000;
					11:regData[n]<=16'h0000;
					12:regData[n]<=16'hCCCC;
					13:regData[n]<=16'h0002;
					default:regData[n]<=16'h0000;
				endcase
			end
		end
		else
		begin
			case({wr,wrR15})
				2'b00:
				begin
					// Do nothing
				end
				2'b10:
				begin
					regData[regDst]<=regDstData;
				end
				2'b01:
				begin
					regData[regR15]<=regR15Data;
				end
				2'b11:
				begin
					if(regDst=={{4'b1}})
					begin
						regData[regDst]<=regDstData;
					end
					else
					begin
						regData[regDst]<=regDstData;
						regData[regR15]<=regR15Data;
					end
				end
			endcase
		end
        end

        always@(*)
        begin
                rdR1=regData[regR1];
                rdR2=regData[regR2];
                rdR15=regData[regR15];
        end
endmodule


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
