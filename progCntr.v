/* The program counter module (progCntr.v) specifies the location a system is in the program sequence being run. Post instruction
   fetching, the program counter is incremented and carries the most recent memory address for the following instruction that will
   be executed next.
*/
module progCntr(clk,rst,wrPC,dataIn,cnt);
		// Input ports
        input clk, rst, wrPC;
        input [15:0] dataIn;
        // Output ports
		output [15:0] cnt;
	
        reg [15:0] cnt;

        always@(posedge clk or negedge rst)
        begin
			if(~rst)
			begin
				cnt<=16'h0000;
			end
			else
			begin
				if(wrPC)
				begin
					cnt<=dataIn;
				end
				else
				begin
					cnt<=cnt;
				end
			end
        end
endmodule
