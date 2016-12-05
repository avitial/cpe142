module ctrlUnit(instType,memToReg,wr,wrR15,memRead,memWrite,branch,ALUSrc,ALUOp,setExc,opCode,funcCode);
	// Input Ports
	input[3:0] opCode;
	input[3:0] funcCode;
	// Output Ports
	output wr, wrR15, memToReg, memRead, memWrite, ALUSrc, ALUOp, setExc;
	output [1:0] instType; 
	output [2:0] branch;
	// Variables
	reg wr, wrR15, memToReg, memRead, memWrite;
	reg ALUSrc, ALUOp, setExc, typeBExc, typeAExc;
	reg[1:0] instType;
	reg[2:0] branch;
	
	always@(*)
	begin
		case(opCode)
			4'b0000: // Jump, Halt
			begin
				wr=0;
				memToReg=0;
				memRead=0;
				memWrite=0;
				instType=2'b0; // Type-D
				branch=3'b0;
				ALUSrc=0;
				ALUOp=0;
				typeBExc=0;
			end
			4'b0100: // BGE
			begin
				wr=0;
				memToReg=0;
				memRead=0;
				memWrite=0;
				instType=2'b10; // Type-C
				branch=3'b100;
				ALUSrc=0;
				ALUOp=0;
				typeBExc=0;
			end
			
			4'b0101:	// BLE
			begin
				wr=0;
				memToReg=0;
				memRead=0;
				memWrite=0;
				instType=2'b10; // Type-C
				branch=3'b101;
				ALUSrc=0;
				ALUOp=0;
				typeBExc=0;
			end

			4'b0110: 	// BEQ
			begin
				wr=0;
				memToReg=0;
				memRead=0;
				memWrite=0;
				instType=2'b10; // Type-C
				branch=3'b110;
				ALUSrc=0;
				ALUOp=0;
				typeBExc=0;				
			end

			4'b1000:	//  ANDi
			begin
				wr=0;
				memToReg=0;
				memRead=0;
				memWrite=0;
				instType=2'b10; // Type-C
				branch=3'b000;
				ALUSrc=0;
				ALUOp=0;
				typeBExc=0;	
			end

			4'b1011:
			begin
				instType=01;memToReg=0;wr=0;
				memRead=0;memWrite=1;branch=000;
				ALUSrc=1;ALUOp=1;typeBExc=0;
			end

			4'b1100:
			begin
				instType=11;memToReg=0;wr=0;
				memRead=0;memWrite=0;branch=111;
				ALUSrc=0;ALUOp=0;typeBExc=0;
			end

			4'b1111:
			begin
				instType=11;memToReg=0;wr=0;
				memRead=0;memWrite=0;branch=000;
				ALUSrc=0;ALUOp=0;typeBExc=1;
			end
			default:
			begin
				instType=11;memToReg=0;wr=0;
				memRead=0;memWrite=0;branch=000;
				ALUSrc=0;ALUOp=0;typeBExc=1;
			end
		endcase
	end

	always@(*)
		begin
		case(funcCode)
		4'b0000:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b0001:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b0010:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b0011:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b0100:
		begin
			wrR15=1;
			typeAExc=0;
		end
		4'b0101:
		begin
			wrR15=1;
			typeAExc=0;
		end
		4'b1000:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b1001:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b1010:
		begin
			wrR15=0;
			typeAExc=0;
		end
		4'b1011:
		begin
			wrR15=0;
			typeAExc=0;
		end
		default:
		begin
			wrR15=0;
			typeAExc=1;
		end	 
	endcase

	assign setExc=typeBExc|typeAExc;
	end
endmodule