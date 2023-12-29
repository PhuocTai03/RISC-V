module riscv_tb();
	reg CLK;
	initial CLK <= 0;
	always #10 CLK = ~CLK;
	reg resetPC;
	initial begin
		resetPC = 0;
		#28 resetPC = 1;
	end
	RISCV myRISCV(CLK, resetPC);

	//instruction_fetch debug
	wire [31:0] instruction;
	assign instruction = myRISCV.instructionCode;
	
	//datapath debug
	wire [31:0] ALU_inA, ALU_inB, ALU_outD, REG_DataD, DMEM_DataW, DMEM_DataR;	
	wire [4:0] REG_AddrD;
	assign ALU_inA = myRISCV.myDATAPATH.wire_reg_RS1;
	assign ALU_inB = myRISCV.myDATAPATH.wire_ALU_inB;
	assign ALU_outD = myRISCV.myDATAPATH.wire_alu_result;
	assign DMEM_DataW = myRISCV.myDATAPATH.wire_reg_RS2;
	assign DMEM_DataR = myRISCV.myDATAPATH.wire_dmem_dataRead;
	assign REG_AddrD = myRISCV.myDATAPATH.instructionCode[11:7];
	assign REG_DataD = myRISCV.myDATAPATH.wire_writeback;
	
	//controller debug
	wire RegWEn, BSel, MEMRead, MEMWrite, WBSel;
	wire [3:0] ALUSel;
	assign RegWEn = myRISCV.myCONTROLLER.RegWEn;
	assign BSel = myRISCV.myCONTROLLER.BSel;
	assign ALUSel = myRISCV.myCONTROLLER.ALUSel;
	assign MEMRead = myRISCV.myCONTROLLER.MEMRead;
	assign MEMWrite = myRISCV.myCONTROLLER.MEMWrite;
	assign WBSel = myRISCV.myCONTROLLER.WBSel;

endmodule