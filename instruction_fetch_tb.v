module instruction_fetch_tb();
	reg CLK; initial CLK <= 0; always #10 CLK = ~CLK;
	reg reset;
	initial begin 
		reset = 0;
		#28 reset = 1;
	end

	wire [31:0] instructionCode, pcNext, pc;
	assign pcNext = myIF.pcNext;
	assign pc = myIF.pc;
    
	INSTRUCTION_FETCH myIF(CLK, reset, instructionCode);


endmodule
