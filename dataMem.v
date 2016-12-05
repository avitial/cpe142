/* The data memory module (dataMem.v) is used for load word and store word operations (Type-B)The data mamory is used for load and store word opprations. It acts as the main memory in this design.
   It has the capacility of writing data to memory to the address provided, 
   and also reading data from memoryagain from the address provided.
*/
module dataMem(clk, rst, addr, rdData, wrData, memRead, memWrite);
	// Variables
	parameter storSize = (1 << 15);
	integer n;
	// Input ports
	input clk, rst;
	input [15:0] wrData;
	input [15:0] addr;
	input memRead, memWrite;
	// Output ports
	output [15:0] rdData;
	reg [15:0] locn [storSize-1:0];
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			for(n=0; n<storSize; n=n+1)
			begin
				locn[n]<=n==0?16'h2BC:{16{1'b0}};
			end
		end
		else
		begin
			if(memWrite)
			begin
				locn[addr] <=wrData;
			end
		end
	end
	assign rdData = (memRead)? locn[addr]:{16{1'bz}};
endmodule