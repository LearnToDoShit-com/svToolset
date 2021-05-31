module DualReadMem #(
	parameter BitWidth = 8,
	parameter Depth = 16,
	parameter InvertedDisabledDOUT = 0
)(
	input clk,    // Clock
	input clk_en, // Clock Enable
	
	input wEn, // Write Enable
	input [DepthBitWidth-1:0] wAddr, // Write Address
	input [BitWidth-1:0] dIN, // Data IN

	input rEnA, // Read Enable A
	input [DepthBitWidth-1:0] rAddrA, // Read Address A
	output [BitWidth-1:0] dOUTA, // Data OUT A

	input rEnB, // Read Enable B
	input [DepthBitWidth-1:0] rAddrB, // Read Address B
	output [BitWidth-1:0] dOUTB // Data OUT B
);
	// What bit width do we need to the Addresses to be?
	localparam DepthBitWidth = $clog2(Depth);

	// Instantiate the memory block as an unpacked array of packed words.	
	reg [BitWidth-1:0] MemBuff [Depth-1:0];

	// Write dIN only when wEn is high.	
	always_ff @(posedge clk) begin : proc_MemBuff
		if(clk_en & wEn) begin
			MemBuff[wAddr] <= dIN;
		end
	end

	// Only output values at rAddrA or rAddrB if rEnA or rEnB are high. 
	// Based on InvertedDisabledDOUT, The output will either
	  // be all 0s or all 1s when not enabled.
	generate
		if (!InvertedDisabledDOUT) begin
			assign dOUTA = rEnA ? MemBuff[rAddrA] : 0;
			assign dOUTB = rEnB ? MemBuff[rAddrB] : 0;
		end
		else if(InvertedDisabledDOUT) begin
			assign dOUTA = rEnA ? MemBuff[rAddrA] : '1;
			assign dOUTB = rEnB ? MemBuff[rAddrB] : '1;
		end	
	endgenerate

endmodule : DualReadMem