module INSTRUCTION_FETCH(CLK, reset, instructionCode);
	input CLK, reset;
	output [31:0] instructionCode;
	wire [31:0] pcNext, pc;

	PC_REG myPC_REG(CLK, reset, pcNext, pc);
	ADDER myADDER(pc, 32'b100, pcNext);	
	IMEM myIMEM({2'b0, pc[31:2]}, instructionCode);
endmodule
