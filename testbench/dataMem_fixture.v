`include “dataMem.v”

module dataMem_fixture.v

	parameter storsize=(1<<15);
	reg clk, rst;
	reg [15:0] wrData;
	reg [15:0] addr;
	reg memRead, memWrite;
	
	wire [15:0] rdData;
	
	dataMem #(storSize) dataMem1(
	.clk(clk), .rst(rat), .wrData(wrData), .addr(addr), 
	.memRead(memRead), .memWrite(memWrite), .rdData(rdData);

	initial
		begin
			clk= 0;
			rst= 0;
			wrData= {[15:0]{1’b0}};
			addr= {[15:0]{1’b0}};
			memRead= 1’b0;
			memWrite= 1’b0;
		end
	always
		#5 clk = !clk;
	initial
		begin
			$display("\t\t\t\t\taddr\twrData\t\t\trdData");
			$display("\t\ttime\tclk\trst\taddr\tData\tmemWrite\tmemRead\tData");
			$monitor("%d\t%b\t%b\t%h\t%h\t%b\t%b\t%h",$time, clk, rst, addr, 				wrData, memWrite, memRead, rdData);
		
			#10 rst=1'b1;
			#10 addr=16'h0; memRead=1'b1;
			#10 addr=16'h0; wrData=16'hbaba; memRead=1'b0; memWrite=1'b1;
			#10 memWrite=1'b0; memRead=1'b1;
			#10 memRead=1'b0;
			
			addr=16'h1; wrData=16'h1eaf; memWrite=1'b1;
			#10 memWrite=1'b0; memRead=1'b1;
			#10 addr=16'h0; wrData=16'h0;
			#10 $finish;

endmodule
