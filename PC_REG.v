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
