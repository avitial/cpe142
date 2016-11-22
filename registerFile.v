// Reference from http://courses.cs.washington.edu/courses/cse370/10sp/pdfs/lectures/regfile.txt 
// This is a Verilog description for a 16 x 16-bit register file

`timescale 1ns / 1ns

module registerFile
	(input clk,
	input rst,
	input wr,
	input [2:0] wrAddr,
	input [15:0] wrData,
	input [2:0] rdAddrR1,
	output [15:0] rdDataR1,
	input [2:0] rdAddrR2,
	output [15:0] rdDataR2);

	integer i; 
	reg [15:0] regfile [0:15];

	assign rdDataR1 = regfile[rdAddrR1];
	assign rdDataR2 = regfile[rdAddrR2];

	always @(posedge clk) begin
	if (rst) begin
		for(i=0; i<16; i=i+1) regfile[i] <= 0;
	end else begin
	if (wr) regfile[wrAddr] <= wrData;
	end // else: !if(rst)
	end
endmodule
