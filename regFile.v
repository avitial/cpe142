// Reference from http://courses.cs.washington.edu/courses/cse370/10sp/pdfs/lectures/regfile.txt 
// This is a Verilog description for a 16 x 16-bit register file
`timescale 1ns / 1ns

module regFile (clk, rst, wr, wrAddr, wrData, rdAddrR1, rdDataR1, rdAddrR2, rdDataR2, rdAddrR15, rdDataR15);
	input clk;
	input rst;
	input wr;
	input wrR15;
	input [2:0]   wrAddr;
	input [15:0]  wrData;
	input [15:0]  wrDataR15;
	input [2:0]   rdAddrR1;
	output [15:0] rdDataR1;
	input [2:0]   rdAddrR2;
	output [15:0] rdDataR2;
	input [2:0]   rdAddrR15;
	output [15:0] rdDataR15;

	parameter regSize=4;
	parameter regCnt=(1<<regSize);
	parameter dataSize=16;

	integer i; 
	reg [15:0] regfile [0:15];

	assign rdDataR1 = regfile[rdAddrR1];
	assign rdDataR2 = regfile[rdAddrR2];
	assign rdDataR15 = regfile[rdAddrR15];
	
	reg[dataSize-1:0]regData[regCnt-1:0];
	integer n;
	
	always @(posedge clk)
	begin
		if(!rst)
		begin
			for(i=0; i<regCnt; i=i+1)
			begin
				case(i)
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
				end
				2'b01:
				begin
					regData[{regSize{1'b0}}]<=wrDataR15;
				end
				2'b10:
				begin
					regData[wrAddr]<=wrData;
				end
				2'b11:
				begin
					if(wrAddr=={regSize{1'b0}})
					begin
						regData[wrAddr]<=wrData;
					end
					else
					begin
						regData[wrAddr]<=wrData;		
						regData[{dataSize{1'b0}}]<=wrDataR15;
					end
				end
			endcase
		end
	end
endmodule