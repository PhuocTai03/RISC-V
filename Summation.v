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
//---------------------------------------------
module INSTRUCTION_FETCH(CLK, reset, instructionCode);
	input CLK, reset;
	output [31:0] instructionCode;
	wire [31:0] pcNext, pc;

	PC_REG myPC_REG(CLK, reset, pcNext, pc);
	ADDER myADDER(pc, 32'b100, pcNext);	
	IMEM myIMEM({2'b0, pc[31:2]}, instructionCode);
endmodule
//---------------------------------------------
module PC_REG(CLK, reset, D, Q);
	input CLK, reset;
	input [31:0] D;
	output reg [31:0] Q;

	always @(posedge CLK) begin
		if(!reset)
			Q <= 0;
		else
			Q <= D;
	end
endmodule
//---------------------------------------------
module ADDER(A, B, Y);
	input [31:0] A, B;
	output [31:0] Y;
	
	assign Y = A + B;
endmodule
//---------------------------------------------
module IMEM(Addr, InstructionCode);
    input [31:0] Addr;
    output [31:0] InstructionCode;

    reg [31:0] RAM [1023:0];
    initial $readmemh("imem.txt", RAM);
    assign InstructionCode = RAM[Addr];
endmodule
//---------------------------------------------
module CONTROLLER(instructionCode, ImmSel, RegWEn, BSel, ALUSel, MemRW, WBSel);
	input [31:0] instructionCode;
	output RegWEn, BSel, MemRW, WBSel;
	output [1:0] ImmSel;
	output [3:0] ALUSel;
	reg [9:0] controlSignal;

	always @(instructionCode) begin
		case(instructionCode[6:0])
				7'b0110011: //add
					controlSignal <= 10'bxx10001001;
				7'b0100011: //sw
					controlSignal <= 10'b100100101x;
				7'b0000011: //lw
					controlSignal <= 10'b0111001000; 
				7'b0010011: //addi
					controlSignal <= 10'b0011001001;
				7'b0110111: //lui
					controlSignal <= 10'b1111011001;
				default:
					controlSignal <= 10'bxxxxxxxxxx; 
		endcase
	end
	assign {ImmSel, RegWEn, BSel, ALUSel, MemRW, WBSel} = controlSignal;
endmodule
//---------------------------------------------
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
 
//---------------------------------------------
module REG(CLK, RegWEn, AddrD, DataD, AddrA, DataA, AddrB, DataB);
	input RegWEn;
	input CLK;
	input [4:0] AddrA;
	input [4:0] AddrB;
	input [4:0] AddrD;
	input [31:0] DataD;

	output [31:0] DataA;
	output [31:0] DataB;

	reg [31:0] RegisterFile32b [31:0];
	integer i;
	initial begin
		for(i = 0; i < 32; i = i + 1)
			RegisterFile32b[i] <= 0;
	end
 	always @ (posedge CLK)
		begin
			if (RegWEn == 1)
				RegisterFile32b[AddrD] <= DataD ;
		end
	assign DataA = RegisterFile32b[AddrA];
	assign DataB = RegisterFile32b[AddrB];
endmodule
//---------------------------------------------
module ImmGen(dataIn, dataOut, ImmSel);
	input [24:0] dataIn;
	input [1:0] ImmSel;
	output [31:0] dataOut;

	reg [31:0] immGenOut;
	
	always @(dataIn or ImmSel) begin
        case (ImmSel)
		2'b00: immGenOut <= {{21{dataIn[24]}}, dataIn[23:13]}; //I-type (addi)
		2'b01: immGenOut <= {{21{dataIn[24]}}, dataIn[23:13]}; //I-type (lw)
		2'b10: immGenOut <= {{21{dataIn[24]}}, dataIn[23:18], dataIn[4:0]}; //S-type
		2'b11: immGenOut <= {{13{dataIn[24]}}, dataIn[23:5]}; //U-type (lui)
		default: immGenOut <= 32'bx;
        endcase
	end
	assign dataOut = immGenOut;
endmodule
//---------------------------------------------
module MUX(SEL, A, B, Y);
	input SEL;
	input [31:0] A;
	input [31:0] B;

	output [31:0] Y;

	assign Y = (SEL == 0)?A:B;
endmodule
//---------------------------------------------
module ALU (A, B, ALUControl, ALUResult);
	input [3:0] ALUControl;
	input [31:0] A, B;
	output reg [31:0] ALUResult;

	always @(ALUControl or A or B) begin
		case(ALUControl)
			4'b0000: ALUResult = A & B;
			4'b0001: ALUResult = A | B;
			4'b0010: ALUResult = A + B;
			4'b0011: ALUResult = A - B;
			4'b0100: ALUResult = (A<B)?32'd1:32'd0;
			4'b0101: ALUResult = !(A|B);
			4'b0110: ALUResult = B << 12;
			default: ALUResult = 0;
		endcase
	end
endmodule
//---------------------------------------------
module DMEM(MemRW, CLK, Addr, DataW, DataR);
	input MemRW;
	input CLK;
	input [9:0] Addr;
	input [31:0] DataW;

	output [31:0] DataR;

	reg [31:0] getData;
	reg [32:0] SRAM_Cell [1023:0];

	always@(posedge CLK)
		begin
			if(MemRW)
				SRAM_Cell[Addr] <= DataW;
		end
	assign DataR = SRAM_Cell[Addr];
endmodule
	
