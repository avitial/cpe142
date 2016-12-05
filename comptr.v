module comptr(in1,in2,brGtr,brLte,brEq);
	// Input Ports
	input [15:0] in1;
	input [15:0] in2;
	
	// Output Ports
	output brGtr,brLte,brEq;
	
	// Variables
	reg brGtr,brLte,brEq;
	reg [15:0] tmpGtr;
	reg [15:0] tmpLte;
	reg [15:0] tmpEq;
	reg tmpEq2 [16:0];
	integer n;
	
	always@(*)
	begin
		for(n=0; n<16; n=n+1)
		begin
			tmpEq[n]=in1[n]~^in2[n];
			tmpGtr[n]=tmpEq2[n+1]&in1[n]&~in2[n];
			tmpLte[n]=tmpEq2[n+1]&~in1[n]&in2[n];
			tmpEq2[n]=tmpEq2[n+1]&tmpEq[n];
		end

		tmpEq2[16]=1'b1;
		brEq= &tmpEq;
		brGtr= |tmpGtr;
		brLte= |tmpLte;
	end
endmodule 