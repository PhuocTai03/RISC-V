module controller_tb();
    reg [31:0] dataIn;
    wire RegWEn, BSel, MemRW, WBSel;
    wire [1:0] ImmSel;
    wire [3:0] ALUSel;
    initial begin
        dataIn <= 0;
        #10 dataIn <= 32'b00000000001100000000000010010011; // addi x1, x0, 3
        #10 dataIn <= 32'b00000000001000001000000110110011; //add x3, x1, x2
        #10 dataIn <= 32'b00000000111000010010010000100011; //sw x14, 8(x2)
        #10 dataIn <= 32'b00000000100000010010011110000011; //lw x15, 8(x2)
        #300 $stop;
    end
    //CONTROLLER myCTL(dataIn, ImmSel, RegWEn, BSel, ALUSel, MemRW, WBSel);
    CONTROLLER myCTL(.instructionCode(dataIn), .ImmSel(ImmSel), .RegWEn(RegWEn), .BSel(BSel), .ALUSel(ALUSel), .MemRW(MemRW), .WBSel(WBSel));
endmodule
