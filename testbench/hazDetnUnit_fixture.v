'include "hazDetnUnit.v"

module hazDetnUnit_fixture;
	
	reg [3:0]regR1, regR2, EXregR2, rdR1rdR15comp;
	reg IDEXMemRead;
	wire PCWrite, IFIDWrite, halt;
	
	$monitor 

	hazDetnUnit hazDetnUnit1(regR1,regR2,EXregR2,rdR1rdR15comp,IDEXMemRead,PCWrite, 		IFIDWrite, halt);
	
	initial
	begin
		regR1
		regR2
		rdR1rdR15comp
		
		#20 IDEXMemRead =1'b0;
		#20 IDEXMemRead =1'b1;
		#20 regR2 =4'b1100;
		#20 regR2=4'b0000;
		#20 regR1=4'b1100;
		#20 IDEXMemRead =1'b0;

	end

	initial
		begin
			#800
			$finish;
		end
endmodule
