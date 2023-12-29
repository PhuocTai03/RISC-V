module MUX(SEL, A, B, Y);
	input SEL;
	input [31:0] A;
	input [31:0] B;

	output [31:0] Y;

	assign Y = (SEL == 0)?A:B;
endmodule
