module RCADataLoop_Acc #(
	parameter BitWidth = 8,
	parameter RegisterCount = 16,
	parameter ZRenabled = 0, // Do you want register 0 to be a constant zero?
	parameter ShifterEnabled = 0, // Do you want a shifter on the ALU output?
	parameter Pipelined = 0 // If 1, dINA and dINB will be buffered in DFFs 
								// before going into the ALU.
)(
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst,  // Asynchronous reset active high
	
	// Input Flags
	input EnAcc,      // Enable the Acc input of the ALU
	input ImmEnAcc,   // Mux the Acc input with the Imm
	input InvAcc,     // Invert the Acc input
	input EnB,        // Enable the B input of the ALU
	input ImmEnB,     // Mux the B input with the Imm
	input InvB,       // Invert the B input
	input cIn,        // Carry In
	input ORen,       // OR control line enable
	input FloodCarry, // Flood Carry control line enable
 	// If this RegWriteEn set to 1, write to register B address, not Acc.
	input RegWriteEn, // "Destination Flag"
	input OutputOverrideEnable, // If 1, override the ALU/Shifter output with OutputOverrideIN. 
									// This is seperate from ImmIN, as this is syncronized with the pipeline.
									// Useful for pipelined Load operations. 

	// Shifter control lines, leave disconnected if you disabled the shifter.
	input ShiftEn,         	        // Enable the shifter
	input ShiftByA,        	        // If 1, shift B by Acc; if 0, shift B by ImmIN
	input ShiftLeft,       	        // If 1, shift left; if 0, shift right
	input ShiftRotateEnable	        // If 1, rotate while shifting; If 0, do not rotate while shifting
	
	// Output Flags
	output cOut,      // Carry Out
	output ifZero,    // If ALU Output equals Zero
	output overflow,  // Arithmetic overflow

	// Immediate Value In
	input  [BitWidth-1:0] ImmIN,

	// Register B Read Address
	input  [RegAddrWidth-1:0] regAAddr,
	output [BitWidth-1:0] dOUTB,

	// Register Write Address
	input  [RegAddrWidth-1:0] regCAddr,

	// Writeback input from external source that feeds directly into the same output as the ALU/shifter output.
		// This value will go into the forwarder, if it is enabled. 
	input  [BitWidth-1:0] OutputOverrideIN,

	// Data Out
	output [BitWidth-1:0] ALUout
);

endmodule : RCADataLoop_Acc