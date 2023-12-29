module IMEM_tb();
	reg [31:0] Addr;
	wire [31:0] InstructionCode;
	initial begin
		#0 Addr <= 0;
		#5 Addr <= 1;
		#5 Addr <= 2;
		#5 Addr <= 3;
		#5 Addr <= 4;
		#5 Addr <= 5;
		#5 Addr <= 6;
		#5 Addr <= 7;
	end	

	IMEM myIMEM(Addr, InstructionCode);
endmodule