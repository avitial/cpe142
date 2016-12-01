// Reference from http://courses.cs.washington.edu/courses/cse370/10sp/pdfs/lectures/regfile.txt 
// This is a Verilog description for a 16 x 16-bit register file
`timescale 1ns / 1ns

module regFile (clk, rst, wr, wrAddr, wrData, rdAddrR1, rdDataR1, rdAddrR2, rdDataR2, rdAddrR15, rdDataR15);
	input clk;
	input rst;
	input wr;
	input [2:0] wrAddr;
	input [15:0] wrData;
	input [2:0] rdAddrR1;
	output [15:0] rdDataR1;
	input [2:0] rdAddrR2;
	output [15:0] rdDataR2;
	input [2:0] rdAddrR15;
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
	integer i;
	
	always @(posedge clk)
	begin
		if(!rst)
		begin
			for(i=0; i<regCnt; i=i+1)
			begin
				case(i)
					1:regData[i]<=16'hFFFF;
					2:regData[i]<=16'h0050;
					3:regData[i]<=16'hF033;
					4:regData[i]<=16'hF0FF;
					5:regData[i]<=16'h0040;
					6:regData[i]<=16'h6666;
					7:regData[i]<=16'h00FF;
					8:regData[i]<=16'h8888;
					9:regData[i]<=16'h0000;
					10:regData[i]<=16'h0000;
					11:regData[i]<=16'h0000;
					12:regData[i]<=16'hCCCC;
					13:regData[i]<=16'h0002;
					default:regData[i]<=16'h0000;
				endcase
			end 
		end
	end
  
