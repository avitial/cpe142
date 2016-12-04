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
