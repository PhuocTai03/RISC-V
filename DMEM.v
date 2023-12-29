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
	