module DATAPATH(ImmSel, RegWEn, BSel, ALUSel, MemRW, WBSel, CLK, instructionCode);
	input RegWEn, BSel, MemRW, WBSel;
	input [1:0] ImmSel;
	input [3:0] ALUSel;
	input CLK;
	input [31:0] instructionCode;

	wire [31:0] wire_reg_RS1, wire_reg_RS2, wire_immGen_out,
				wire_ALU_inB, wire_alu_result, wire_dmem_dataRead, wire_writeback;

	REG myRegister(.CLK(CLK), .RegWEn(RegWEn),
			.AddrD(instructionCode[11:7]), .DataD(wire_writeback),
			.AddrA(instructionCode[19:15]), .DataA(wire_reg_RS1),
			.AddrB(instructionCode[24:20]), .DataB(wire_reg_RS2));
 
	ImmGen myImmGen(.dataIn(instructionCode[31:7]), .dataOut(wire_immGen_out), .ImmSel(ImmSel));

	MUX myBMux(.SEL(BSel), .A(wire_reg_RS2), .B(wire_immGen_out), .Y(wire_ALU_inB));

	ALU myALU(.A(wire_reg_RS1), .B(wire_ALU_inB), .ALUControl(ALUSel), .ALUResult(wire_alu_result));

	DMEM myDMEM(.MemRW(MemRW), .CLK(CLK), .Addr(wire_alu_result[9:0]), .DataW(wire_reg_RS2), .DataR(wire_dmem_dataRead));

	MUX myWBMux(.SEL(!WBSel), .A(wire_alu_result), .B(wire_dmem_dataRead), .Y(wire_writeback));
endmodule
 