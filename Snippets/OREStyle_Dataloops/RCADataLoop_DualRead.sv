module RCADataLoop_DualRead #(
	parameter BitWidth = 8,
	parameter RegisterCount = 16,
	parameter ZRenabled = 0,  // Do you want register 0 to be a constant zero?
	parameter ShifterEnabled = 0, // Do you want a Shifter in your data loop?
	parameter Pipelined = 0, // If 1, dINA and dINB will be buffered in DFFs 
								// before going into the ALU.
	parameter Forwarded = 0 // Adds a data forwarder, It is useless at the speeds this will run,
								// but it will get the idea across.
							// If this is selected, an additional DFF buffer is added to the ALU/Shifter Output.
							// NOTE: Pipelined must equal 1 in order to add forwarder.
)(
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst,    // Asynchronous reset active high
	
	// Input Flags
	input EnA,        // Enable the A input of the ALU
	input ImmEnA,     // Mux the A input with the Imm
	input InvA,       // Invert the A input
	input EnB,        // Enable the B input of the ALU
	input ImmEnB,     // Mux the B input with the Imm
	input InvB,       // Invert the B input
	input cIn,        // Carry In
	input ORen,       // OR control line enable
	input FloodCarry, // Flood Carry control line enable
	input OutputOverrideEnable, // If 1, override the ALU/Shifter output with OutputOverrideIN. 
									// This is seperate from ImmIN, as this is syncronized with the pipeline. 
									// Useful for pipelined Load operations. 

	// Shifter control lines, leave disconnected if you disabled the shifter.
	input ShiftEn,         	        // Enable the shifter
	input ShiftByA,        	        // If 1, shift B by register A; if 0, shift B by ImmIN
	input ShiftLeft,       	        // If 1, shift left; if 0, shift right
	input ShiftRotateEnable,	    // If 1, rotate while shifting; If 0, do not rotate while shifting
	
	// Output Flags
	output cOut,      // Carry Out
	output ifZero,    // If ALU Output equals Zero
	output overflow,  // Arithmetic overflow

	// Immediate Value In
	input  [BitWidth-1:0] ImmIN,

	// Register A Read Address
	input  [RegAddrWidth-1:0] regAAddr,
	output [BitWidth-1:0] dOUTA,

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

endmodule : RCADataLoop_DualRead

