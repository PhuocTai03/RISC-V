module datapath_tb();
	//control
	reg RegWEn, BSel, MEMRead, MEMWrite, WBSel;
	reg [3:0] ALUSel;
	reg datapathReset;
	initial begin
		datapathReset = 1;
		#11 datapathReset = 0;
	end

	//input data
	reg CLK;
	initial CLK <= 0;
	always #10 CLK = ~CLK;
	reg [31:0] dataIn;

	//output data
	wire [31:0] ALU_inA, ALU_inB, ALU_outD, REG_DataD, DMEM_DataW, DMEM_DataR;	
	wire [4:0] REG_AddrD;
	
	//debug
	assign ALU_inA = myDATAPATH.wire_reg_RS1;
	assign ALU_inB = myDATAPATH.wire_ALU_inB;
	assign ALU_outD = myDATAPATH.wire_alu_result;
	assign DMEM_DataW = myDATAPATH.wire_reg_RS2;
	assign DMEM_DataR = myDATAPATH.wire_dmem_dataRead;
	assign REG_AddrD = dataIn[11:7];
	assign REG_DataD = myDATAPATH.wire_writeback;

	DATAPATH myDATAPATH(.RegWEn(RegWEn), .BSel(BSel), .ALUSel(ALUSel), .MEMRead(MEMRead), .MEMWrite(MEMWrite), .WBSel(WBSel),
		.CLK(CLK), .instructionCode(dataIn)
	);
	
	//configuration
	initial begin
		{RegWEn, BSel, ALUSel, MEMRead, MEMWrite, WBSel} <= 9'b000000000;
		dataIn <= 32'b00000000000000000000000000000000;
		wait(datapathReset == 0);
			@(negedge CLK); #2 //addi x1, x0, 3	=> x1 = 3
				{RegWEn, BSel, ALUSel, MEMRead, MEMWrite, WBSel} <= 9'b110010001; 
				dataIn <= 32'b00000000001100000000000010010011;

			@(negedge CLK); #2 //addi x2, x1, 1	=> x2= x1 + 1 = 4
				{RegWEn, BSel, ALUSel, MEMRead, MEMWrite, WBSel} <= 9'b110010001;
				dataIn <= 32'b00000000000100001000000100010011;

			@(negedge CLK); #2 //add x3, x1, x2	=> x3 = 3 + 4 = 7
				{RegWEn, BSel, ALUSel, MEMRead, MEMWrite, WBSel} <= 9'b100010001;
				dataIn <= 32'b00000000001000001000000110110011;
			
			@(negedge CLK); #2 //add x14, x1, x3	=> x14 = 3 + 7 = 10
				{RegWEn, BSel, ALUSel, MEMRead, MEMWrite, WBSel} <= 9'b100010001;
				dataIn <= 32'b00000000001100001000011100110011;

			@(negedge CLK); #2 //sw x14, 8(x2)	=> M[x2 +8] = M[12] = 10
				{RegWEn, BSel, ALUSel, MEMRead, MEMWrite, WBSel} <= 9'b01001001x;
				dataIn <= 32'b00000000111000010010010000100011;
	
			@(negedge CLK); #2 //lw x15, 8(x2)      => x15 = M[x2 + 8] = M[12]
				{RegWEn, BSel, ALUSel, MEMRead, MEMWrite, WBSel} <= 9'b110010100;
				dataIn <= 32'b00000000100000010010011110000011;

			@(negedge CLK); #2 //addi x16, x15, 0	=> x16= x15 + 0 = x15
				{RegWEn, BSel, ALUSel, MEMRead, MEMWrite, WBSel} <= 9'b110010001;
				dataIn <= 32'b00000000000001111000100000010011;

			//@(negedge CLK); #2 //lw x14, 8(x2)      => x14 = M[x2 + 8] = M[12]
				//{RegWEn, BSel, ALUSel, MEMRead, MEMWrite, WBSel} <= 9'b110010100;
				//dataIn <= 32'b00000000100000010010011100000011;

	end
endmodule