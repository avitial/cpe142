/* The Arithmetic Logic Unit (ALU) performs all the processes related to arithmetic and bitwise operations on integer binary numbers,
   on instruction words in this case. The ALU is what essentially makes the datapath work, it calculates the result for Type-A 
   instructions and also some of the Type-C instructions, where the use of the sign-extended (extended) value is done from the
   sign-extend module (signExtend.v).
*/
module alu(op1,op2,extended,aluDecr,ALUSrc,aluCtrl,aluRslt, aluRsltR15, ovExcep);
	parameter dataSize=16; // Data size is 16-bit wide
	parameter func=4; // Function code is 4-bit wide 

	input ALUSrc,aluCtrl;
	input [dataSize-1:0] op1;
	input [dataSize-1:0] op2;
	input [dataSize-1:0] extended;
	input [func-1:0] aluDecr;

	output reg [(2*dataSize)-1:0] aluRslt;
	output reg [(1*dataSize)-1:0] aluRsltR15;
	output wire  ovExcep;

	reg ovFlowSE;
	wire ovFlow;
	wire [dataSize-1:0] aluOp1;
	wire [dataSize-1:0] aluOp2;

	assign aluOp1 = ALUSrc ? extended:op1;
	assign aluOp2 =! ALUSrc && aluDecr[3] ? extended:op2;
	assign ovExcep = ovFlow && ovFlowSE;
	assign ovFlow = ((aluOp1[dataSize-1]^~aluOp2[dataSize-1])&&(aluOp1[dataSize-1] ^aluRslt[dataSize-1]));

	always@(*)
	begin
		casex({aluCtrl,aluDecr})
			5'b00000:	// Signed Addition, op1 = op1 + op2
			begin
				aluRslt[(2*dataSize)-1:dataSize]={dataSize{1'b0}};
				aluRslt[dataSize-1:0]=aluOp1+aluOp2;
				ovFlowSE=1'b1;
			end
			5'b00001:	// Signed Subtraction, op1 = op1 - op2
			begin
				aluRslt[(2*dataSize)-1:dataSize]={dataSize{1'b0}};
				aluRslt[dataSize-1:0]=aluOp1-aluOp2;
				ovFlowSE=1'b1;
			end
			5'b00100:	// Signed Multiplication, op1 = op1 * op2, op1 != R15
			begin
				aluRslt[(2*dataSize)-1:0]=aluOp1*aluOp2;
				aluRsltR15[(1*dataSize)-1:0]=aluRslt[31:16];
				ovFlowSE=1'b0;
			end
			5'b00101:	// Signed Division, op1 = op1 / op2, op1 != R15
			begin
				aluRslt[(2*dataSize)-1:dataSize]=aluOp1%aluOp2;
				aluRsltR15[dataSize-1:0]=aluOp1/aluOp2;
				ovFlowSE=1'b0;
			end
			5'b00010: // AND Immediate, op1 = op1 & {8’b0, constant}
			begin
				aluRslt[(2*dataSize)-1:dataSize]={dataSize{1'b0}};
				aluRslt[dataSize-1:0]=aluOp1&aluOp2;
				ovFlowSE=1'b0;
			end
			5'b00011: // OR Immediate, op1 = op1 | {8’b0, constant}
			begin
				aluRslt[(2*dataSize)-1:0]={dataSize{1'b0}};
				aluRslt[dataSize-1:0]=aluOp1&aluOp2;
				ovFlowSE=1'b0;
			end
			5'b01000: // SWAP, op1 <= op2, op2 <= op1
			begin
				aluRslt[(2*dataSize)-1:0]={dataSize{1'b0}};
				aluRslt[dataSize-1:0]=aluOp1&aluOp2;
				ovFlowSE=1'b0;
				//a <= b;
				//b <= a;
			end
			5'b1xxxx:	
			begin
				aluRslt[(2*dataSize)-1:dataSize]={dataSize{1'b0}};
				aluRslt[dataSize-1:0]=aluOp1 + aluOp2;
				ovFlowSE=1'b0;
			end
			default:
			begin
				aluRslt[(2*dataSize)-1:0]={2*dataSize{1'b0}};
				ovFlowSE=1'b0;
			end
		endcase
	end
endmodule
