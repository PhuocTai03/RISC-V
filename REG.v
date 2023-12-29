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
