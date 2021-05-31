module SingleReadMem #(
	parameter BitWidth = 8,
	parameter Depth = 16,
	parameter InvertedDisabledDOUT = 0
)(
	input clk,    // Clock
	input clk_en, // Clock Enable
	
	input wEn, // Write Enable
	input [DepthBitWidth-1:0] wAddr, // Write Address
	input [BitWidth-1:0] dIN, // Data IN

	input rEn, // Read Enable
	input [DepthBitWidth-1:0] rAddr, // Read Address
	output [BitWidth-1:0] dOUT // Data OUT
);
	// What bit width do we need to the Addresses to be?
	localparam DepthBitWidth = $clog2(Depth);

	// Instantiate the memory block as an unpacked array of packed words.	
	reg [BitWidth-1:0] MemBuff [Depth-1:0];

	// Write dIN to wAddr only when wEn is high.
	always_ff @(posedge clk) begin : proc_MemBuff
		if(clk_en & wEn) begin
			MemBuff[wAddr] <= dIN;
		end
	end

	// Only output value at rAddr if rEn is high. 
	// Based on InvertedDisabledDOUT, The output will either
	  // be all 0s or all 1s when not enabled.
	generate
		if (!InvertedDisabledDOUT) begin
			assign dOUT = rEn ? MemBuff[rAddr] : 0;
		end
		else if(InvertedDisabledDOUT) begin
			assign dOUT = rEn ? MemBuff[rAddr] : '1;
		end
	endgenerate
endmodule : SingleReadMem