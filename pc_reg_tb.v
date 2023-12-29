module pc_reg_tb();
	reg CLK; initial CLK <= 0; always #10 CLK = ~CLK;
	reg reset;
	initial begin 
		reset = 0;
		#28 reset = 1;
	end
	wire [31:0] pcNext, pc, instructionCode;

	PC_REG myPC_REG(CLK, reset, pcNext, pc);
	ADDER myADDER(pc, 32'd4, pcNext);	
	IMEM myIMEM({2'b0, pc[31:2]}, instructionCode);

endmodule
