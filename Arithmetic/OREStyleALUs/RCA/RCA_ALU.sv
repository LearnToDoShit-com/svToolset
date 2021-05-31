// This is an ALU that will act just like an RCA ALU used
	// in most Builder trials on ORE... This style isn't 
	// nessarily the best for FPGAs, but it is great to use
	// when getting started and learning how to go from 
	// Redstone to SystemVerilog.

module RCA_ALU #(
	parameter BitWidth = 8
)(
	input InvA,
	input InvB,
	input cIn,
	input ORen,
	input FloodCarry,
	output cOut,
	output ifZero,
	output overflow,

	input [BitWidth-1:0] dINA,
	input [BitWidth-1:0] dINB,

	output [BitWidth-1:0] dOUT
);

	// The following instantiates the Carry Vector, then
		// conditionally modifies it based on cIn and FloodCarry.
	wire [BitWidth:0] Carry;
	assign Carry[0] = cIn;
	wire [BitWidth-1:0] CarryTemp;
	assign CarryTemp = FloodCarry ? '1 : Carry[BitWidth-1:0];

	// Generate One RCA_Cell per bit
	generate
		genvar i;
		for(i = 0; i < BitWidth; i = i + 1) begin : StackOfRCACells
			RCA_Cell RCACell (
				.cIn  (CarryTemp[i]),
				.ORen (ORen),
				.InvA (InvA),
				.InvB (InvB),
				.dINA (dINA[i]),
				.dINB (dINB[i]),
				.cOut (Carry[i+1]),
				.dOUT (dOUT[i])
			);
		end
	endgenerate

	// Output Flags
	assign ifZero = (dOUT == 0);
	assign cOut = Carry[BitWidth];

	// The following is ued to generate the overflow output flag.
	// It is based on overflowgates.png 
	// The source for that picture is the following:
		// http://static.righto.com/images/6502_overflow/overflow_gates-s400.png
	wire MSBnor = !(dINA[BitWidth-1] | dINB[BitWidth-1]);
	wire MSBnand = !(dINA[BitWidth-1] & dINB[BitWidth-1]);
	wire carryCheck = MSBnor & Carry[BitWidth-2];
	wire carryClear = !(MSBnand | Carry[BitWidth-2]);
	assign overflow = !(carryCheck | carryClear);

endmodule : RCA_ALU


