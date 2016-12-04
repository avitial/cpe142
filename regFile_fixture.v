// Top level stimulus module for regFile.v block
`include "regFile.v"
module regFile_fixture;
        // Declare variables for stimulating input
        reg clk, rst, wr, wrR15;
        reg [3:0] regR1;
        reg [3:0] regR2;
        reg [3:0] regDst;
        reg [15:0] regDstData;
        reg [15:0] regR15Data;

		// Port Wires
        wire [15:0] rdR1;
        wire [15:0] rdR2;
        wire [15:0] rdR15;

        initial
			$vcdpluson;
        initial
        $monitor($time,"| %b|  %b  | %b | %b | %b | %b | %b | %b | %b | %b | %b |",
                wr,wrR15,rst,regR1[3:0],regR2[3:0],regDst[3:0],regDstData[15:0],regR15Data[15:0],rdR1[15:0],rdR2[15:0],rdR15[15:0]);

		// Instantiate the design block regFile
        regFile regF1(clk,rst,regR1,regR2,regDst,regDstData,regR15Data,wr,wrR15,rdR1,rdR2,rdR15);

        // Drive the input signals
        initial
        begin
			#10
			rst = 1'b1;
			regDst = 4'b0001;
			regDstData = 16'hCCCC;
			regR15Data = 16'hAAAA;
			wr = 1'b1;
			wrR15 = 1'b1;
			regR1 = 4'b0001;
			regR2 = 4'b0010;
			#50;
			rst = 1'b1;
			#10
			regDst = 4'b0010;
			regDstData = 16'hF0F0;
			regR15Data = 16'h0F0F;
			wr = 1'b1;
			wrR15 = 1'b0;
			regR1 = 4'b0010;
			regR2 = 4'b0100;
			#50;
			rst = 1'b1;
			#10
			regDst = 4'b0010;
			regDstData = 16'hAAAA;
			regR15Data = 16'hBBBB;
			wr = 1'b0;
			wrR15 = 1'b1;
			regR1 = 4'b0010;
			regR2 = 4'b0100;
			#50;
			rst = 1'b0;
			#10
			regDst = 4'b0011;
			regDstData = 16'hAAAA;
			regR15Data = 16'hBBBB;
			wr = 1'b0;
			wrR15 = 1'b1;
			regR1 = 4'b0011;
			regR2 = 4'b0100;
			#50;
        end
		
        // Setup the clock to toggle every 10 time units
        initial
        begin
			clk = 1'b0;
			forever #10 clk = ~clk;
        end
		
        // Finish the simulation at time 200
        initial
        begin
			$display("\t\ttime|wr|wrR15|rst| regR1|regR2 |regDst|     regDstData   |    regR15Data    |       rdR1       |        rdR2      |       rdR15      |");
			#650 $finish;
        end
endmodule
