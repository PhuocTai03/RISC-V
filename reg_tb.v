`timescale 1ns/100ps
module RegisterFiles_tb();
	reg CLK, ReadWriteEn;
	reg [4:0] WriteAddress;
	reg [31:0] WriteData;
	reg [4:0] ReadAddress1, ReadAddress2;
	wire [31:0] ReadData1,ReadData2;
	//REG D(.CLK(CLK),.ReadWriteEn(ReadWriteEn),.WriteData(WriteData),.WriteAddress(WriteAddress),.ReadAddress1(ReadAddress1),.ReadAddress2(ReadAddress2),.ReadData1(ReadData1),.ReadData2(ReadData2));
	REG myREG (.CLK(CLK), .RegWEn(ReadWriteEn), .DataD(WriteData), .AddrD(WriteAddress), .AddrA(ReadAddress1), .AddrB(ReadAddress2), .DataA(ReadData1), .DataB(ReadData2));
	initial begin
		CLK = 0;
		ReadWriteEn = 1;
		WriteData = 22;
		ReadAddress1 = 0;
		ReadAddress2 = 0;
		WriteAddress = 0;
		#500 ReadWriteEn = 0;
		#800 ReadWriteEn = 1;
		#1500 ReadWriteEn = 0;
		#2000 $stop;
	end 

	always #20  CLK =~CLK;
	always #40  WriteData = $random;
	always #40 WriteAddress = (WriteAddress+1);
	always #40 ReadAddress1 = (ReadAddress1+1);
	always #40 ReadAddress2 = (ReadAddress2+ $random);
endmodule
