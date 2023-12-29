module ALU_tb();
	reg [3:0] ALUControl;
	reg [31:0] A, B;
	wire [31:0] ALUResult;

	ALU myALU(A, B, ALUControl, ALUResult);

	initial begin
		A = 3;
		B = 4;
		ALUControl <= 0;
	end
	always #10 ALUControl = ALUControl + 1;
	always #160 A = $random;
	always #160 B = $random;
endmodule
