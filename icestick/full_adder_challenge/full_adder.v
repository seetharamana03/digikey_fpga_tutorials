module full_adder (

	// Inputs
	input	[2:0]	pmod,
	
	// Outputs
	output	[4:0]	led

);

	wire a_xor_b;
	wire a_and_b;
	wire a_xor_b_and_cin;
	wire not_pmod_0;
	wire not_pmod_1;
	
	assign not_pmod_0 = ~pmod[0];
	assign not_pmod_1 = ~pmod[1];
	assign not_pmod_2 = ~pmod[2];
	
	assign a_xor_b = not_pmod_0 ^ not_pmod_1;
	assign a_and_b = not_pmod_0 & not_pmod_1;
	assign a_xor_b_and_cin = a_xor_b & not_pmod_2;
	
	assign led[0] = a_xor_b ^ not_pmod_2;
	assign led[1] = a_and_b | a_xor_b_and_cin;
	
endmodule