/* Reference from http://courses.cs.washington.edu/courses/cse370/10sp/pdfs/lectures/regfile.txt 
   This is a Verilog description for a 16 x 16-bit register file */
`timescale 1ns / 1ns

module regFile(clk,rst,regR1,regR2,regDst,regDstData,regR15Data,wr,wrR15,rdR1,rdR2,rdR15);
	parameter dataSize=16;
	parameter regSize=4;
	parameter regCnt=(1<<regSize);
	integer n;

	input clk,rst;
	input [regSize-1:0] regR1;
	input [regSize-1:0] regR2;
	input [regSize-1:0] regDst;
	
	input wr,wrR15;
	input [dataSize-1:0] regDstData;
	input [dataSize-1:0] regR15Data;
	
	output reg[dataSize-1:0]rdR1;
	output reg[dataSize-1:0]rdR2;
	output reg[dataSize-1:0]rdR15;

	reg[dataSize-1:0]regData[regCnt-1:0];
	
	always@(negedge rst or posedge clk)
	begin
		if(!rst)
		begin
			for(n=0;n<regCnt;n=n+1)
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
				/* Do Nothing */
			end
			2'b01:
			begin
				regData[{regSize{1'b0}}]<=wrR15;
			end
			2'b10:
			begin
			regData[regDst]<=regDstData;
			end
			2'b11:
			begin
				if(regDst=={regSize{1'b0}})
				begin
					regData[regDst]<=regDstData;
				end
				else
				begin
					regData[regDst]<=regDstData;		
					regData[{dataSize{1'b0}}]<=wrR15;
				end
			end
		endcase
		end
	end
	always@(*)
	begin
		rdR1=regData[regR1];
		rdR2=regData[regR2];
		rdR15=regData[{regSize{1'b0}}];
	end
endmodule