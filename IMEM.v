module IMEM(Addr, InstructionCode);
    input [31:0] Addr;
    output [31:0] InstructionCode;

    reg [31:0] RAM [1023:0];
    initial $readmemh("imem.txt", RAM);
    assign InstructionCode = RAM[Addr];
endmodule