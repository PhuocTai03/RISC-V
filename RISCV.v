module RISCV(CLK, reset);
	input CLK, reset;
	
	wire RegWEn, BSel, MemRW, WBSel;
	wire [1:0] ImmSel;
	wire [3:0] ALUSel;
	wire [31:0] instructionCode;

	INSTRUCTION_FETCH myINSTRUCTION_FETCH(CLK, reset, instructionCode);
	CONTROLLER myCONTROLLER(instructionCode, ImmSel, RegWEn, BSel, ALUSel, MemRW, WBSel);
	DATAPATH myDATAPATH(ImmSel, RegWEn, BSel, ALUSel, MemRW, WBSel, CLK, instructionCode);

endmodule
