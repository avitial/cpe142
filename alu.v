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
