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
