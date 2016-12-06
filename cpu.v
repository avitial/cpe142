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


	wire[1:0] w4,w59, w60;
	wire[3:0] w10, w11, w34, w67, w79, w80;
	wire[7:0] w32, w33;
	wire[15:0] w1,w2,w3,w5,w6, w12, w13, w18, w19, w20, w21, w22, 
		   w23, w24, w25, w26, w27, w28, w29, w30, w31, w35, w36, 
		   w37, w38, w39, w40, w42, w43, w44, w45, w46, w47, w48, 
		   w51, w53, w54, w61, w62, w63, w64, w65, w66, w68, w69,
		   w76, w77, w78, w81, w82, w83, w84, w85, w87, w88;
 	wire w7, w8, w9, w14, w15, w16, w17, w41, w49, w50, w52, w55, w56,
	     w58, w70, w71, w72, w73, w74, w75, w86;

	alu alu1 (op1,op2,extended,aluDecr,ALUSrc,aluCtrl,aluRslt, aluRsltR15, ovExcep);

	comptr comptr1 (in1,in2,brGtr,brLte,brEq);
	
	ctrlUnit controlUnit1 (instType, memToReg, wr, wrR15, memRead, memWrite, 
				branch, ALUSrc, ALUOp, setExc, opCode, funcCode);
	
	dataMem dataMemory1 (clk, rst, addr, rdData, wrData, memRead, memWrite);

	fwdUnit fwdUnit1 (ALUSrc1, ALUSrc2, memRegWrite, wbRegWrite, MEMRegRd, WBRegRd, 
			EXregR1, EXregR2);
	
	hazDetnUnit hazDetnUnit1 (regR1, regR2, EXregR2, rdR1rdR15comp, IDEXMemRead, 
				wrPC, IFIDWrite, halt);

	instMem instMem1 (rdAddr,inst);

	mux2to1 mux2 (a, b, out, sel);

	opMux mux3 (a, b, c, op, ALUSrc);

	progCntr progCntr1 (clk,rst,wrPC,dataIn,cnt);

	regDstDataMux(a, b, c, d, out, sel);

	regDstMux(a, b, c, out, sel);

	regFile(clk,rst,regR1,regR2,regDst,regDstData,regR15Data,wr,wrR15,rdR1,rdR2,rdR15);

	signExtend(sExtend, instType, sExtended);	

	
endmodule

