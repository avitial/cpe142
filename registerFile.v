// Reference from http://courses.cs.washington.edu/courses/cse370/10sp/pdfs/lectures/regfile.txt 
// This is a Verilog description for an 8 x 16 register file

`timescale 1ns / 1ns

module registerFile
  (input clk,
   input reset,
   input write,
   input [2:0] wrAddr,
   input [15:0] wrData,
   input [2:0] rdAddrA,
   output [15:0] rdDataA,
   input [2:0] rdAddrB,
   output [15:0] rdDataB);

   reg [15:0] 	 regfile [0:7];

   assign rdDataA = regfile[rdAddrA];
   assign rdDataB = regfile[rdAddrB];

   always @(posedge clk) begin
      if (reset) begin
	 regfile[0] <= 0;
	 regfile[1] <= 0;
	 regfile[2] <= 0;
	 regfile[3] <= 0;
	 regfile[4] <= 0;
	 regfile[5] <= 0;
	 regfile[6] <= 0;
	 regfile[7] <= 0;
      end else begin
	 if (write) regfile[wrAddr] <= wrData;
      end // else: !if(reset)
   end
endmodule
