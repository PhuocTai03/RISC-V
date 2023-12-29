module immGen_tb();
	reg CLK;
	reg [1:0] ImmSel;
	reg [31:0] instruction;
	wire [31:0] immOUT;
	initial CLK <= 0;
	always #10 CLK = ~CLK;
	ImmGen myIG(instruction[31:7], immOUT,ImmSel);

	initial begin
	#20 instruction = 32'h00300093; //addi
	ImmSel = 2'b00;
	#20 instruction = 32'h002081B3; //add
	ImmSel = 2'bxx;
	#20 instruction = 32'h00812703; //lw
	ImmSel = 2'b01;
	#20 instruction = 32'h00E12423; //sw
	ImmSel = 2'b10;
	#20 instruction = 32'h00006537;	//lui
	ImmSel = 2'b11;
	
	end

endmodule