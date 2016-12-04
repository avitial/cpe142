// Top level stimulus module for alu.v block
`include "alu.v"
module alu_fixture;
    // Declare variables for stimulating input
        reg clk;
        reg ALUSrc,aluCtrl;
        reg [15:0] op1;
        reg [15:0] op2;
        reg [15:0] extended;
        reg [3:0] aluDecr;
        // Port Wires
        wire [31:0] aluRslt;
        wire [15:0] aluRsltR15;
        wire  ovExcep;

        initial
        $vcdpluson;
        initial
        $monitor($time,"| %b |   %b   | %b | %b | %b |%b| %b | %b | %b |",ALUSrc,aluCtrl,op1[15:0],op2[15:0], extended[15:0], aluDecr[3:0],
                 aluRslt, aluRsltR15, ovExcep);

        // Instantiate the design block regFile
        alu alu1(op1,op2,extended,aluDecr,ALUSrc,aluCtrl,aluRslt, aluRsltR15, ovExcep);

        // Drive the input signals
        initial
        begin
                #10;
                ALUSrc = 1'b0;
                aluCtrl = 1'b0;
                op1 = 16'h0F0F;
                op2 = 16'h00F0;
                extended = 16'hAAFF;
                aluDecr = 4'b0000;
                #50;
                ALUSrc = 1'b0;
                aluCtrl = 1'b0;
                op1 = 16'hF0F0;
                op2 = 16'hF0F0;
                extended = 16'hAAFF;
                aluDecr = 4'b0001;
                #50;
                ALUSrc = 1'b0;
                aluCtrl = 1'b0;
                op1 = 16'h00FF;
                op2 = 16'h0000;
                extended = 16'hAAFF;
                aluDecr = 4'b0100;
                #50;
                ALUSrc = 1'b0;
                aluCtrl = 1'b0;
                op1 = 16'h00FF;
                op2 = 16'h000F;
                extended = 16'hAAFF;
                aluDecr = 4'b0101;
                #50;
                ALUSrc = 1'b0;
                aluCtrl = 1'b0;
                op1 = 16'h00F0;
                op2 = 16'h00FF;
                extended = 16'hAAFF;
                aluDecr = 4'b0010;
                #50;
                ALUSrc = 1'b0;
                aluCtrl = 1'b0;
                op1 = 16'h000F;
                op2 = 16'h00F0;
                extended = 16'hAAFF;
                aluDecr = 4'b0011;
                #50;
        end

        // Setup the clock to toggle every 10 time units
        initial
        begin
                clk = 1'b0;
                forever #10 clk = ~clk;
        end

        // Finish the simulation at time 650
        initial
        begin
                $display("\t\ttime|SRC|aluCtrl|        op1       |        op2       |     extended     |Decr|             aluRslt             |   aluRsltR15   |ovExcep|");
                #650 $finish;
        end
endmodule
