module Shifter #(
	parameter BitWidth = 8
)(
	input En,         	// Enable the shifter
	input Left,       	// If 1, shift left; if 0, shift right
	input RotateEnable, // If 1, rotate while shifting; 
							// If 0, do not rotate while shifting

	input [BitWidth-1:0] dIN,        // Data In
	input [ShiftWidth-1:0] ShAmount, 
	output [BitWidth-1:0] dOUT 
);

	localparam ShiftWidth = $clog2(BitWidth);

	// Determine the inverse shift amount.
	wire [ShiftWidth-1:0] InvertShAmount = BitWidth - ShAmount;

	// Define which shift direction is amount is Left and which is Right.
	wire [ShiftWidth-1:0] RightShiftAmount = Left ? InvertShAmount : ShAmount;
	wire [ShiftWidth-1:0] LeftShiftAmount = Left ? ShAmount : InvertShAmount;

	// Shift dIN left and right based on the target shift amounts.
	wire [BitWidth-1:0] RightShifted = dIN >> RightShiftAmount; 
	wire [BitWidth-1:0] LeftShifted = dIN << LeftShiftAmount;

	// Case statement to decide if you take the Left shift, Right Shift, or OR them both.
	// This case statement and the RightShiftAmount/LeftShiftAmount checks are in order
		// to reduce the amount of barrel shifters needed on the FPGA, as those are very
		// large. The additional multiplexers are smaller than the additional shifters.
	wire [BitWidth-1:0] ShiftResult;
	wire [1:0] ShiftCase = {Left,RotateEnable};
	always_comb begin
		case (ShiftCase)
			2'b01 : ShiftResult = RightShifted | LeftShifted;
			2'b10 : ShiftResult = LeftShifted;
			2'b11 : ShiftResult = RightShifted | LeftShifted;
			default : ShiftResult = RightShifted;
		endcase
	end

	// Mux the Shift Result and dIN based on if the shifter is enabled.
	assign dOUT = En ? ShiftResult : dIN;
endmodule : Shifter