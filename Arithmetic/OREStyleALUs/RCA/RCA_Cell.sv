module RCA_Cell (
	input  cIn,
	input  ORen,
	input  InvA,
	input  InvB,
	input  dINA,
	input  dINB,
	output cOut,
	output dOUT
);
	// All the Internal RCA Wires

	// Invert A
	wire tempA = InvA ^ dINA;

	// Invert B
	wire tempB = InvB ^ dINB;

	// Generic RCA Adder with an ORen 
		// ORen is made possible for subsituting the first XOR
		// for an OR and AND.
	wire AorB = tempA | tempB;
	wire GenerateAB = tempA & tempB & !ORen;
	wire HalfAdd = AorB & !GenerateAB;
	wire SecondCarry = HalfAdd & cIn;
	assign cOut = GenerateAB | SecondCarry;
	assign dOUT = HalfAdd ^ cIn;

endmodule : RCA_Cell