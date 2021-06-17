// Requires Counter and CounterWLoad ///!!!!!!!!!!!!!!!!!//

// Takes in M values of bitwidth N, outputs in FIFO order.
module Queue_TwoCounter #(
	parameter BitWidth = 32,
	parameter BufferDepth = 4
)(
	input clk,  // Clock
	input rst,  // Asynchronous reset active high
	
	output dInREQ,
	input  dInACK,
	input  [BitWidth-1:0] dIN,

	output dOutACK,
	input  dOutREQ,
	output [BitWidth-1:0] dOUT,

		// Output Flags
	output BufferFull,
	output BufferEmpty
);
	localparam DepthBitWidth = ($clog2(BufferDepth));
		wire rEn;
		wire wEn;
		wire [DepthBitWidth:0] rAddr;
		wire [DepthBitWidth:0] wAddr;
		wire DepthDec;
		wire Depth_en;
		reg  [BitWidth-1:0] dBuff [(BufferDepth-1):0];	

		always_ff @(posedge clk) begin : proc_dBuffReset
			if(wEn) begin
					dBuff[wAddr[DepthBitWidth-1:0]] <= dIN;
			end
		end

		assign dOUT = dBuff[rAddr[DepthBitWidth-1:0]];
		assign wEn = dInREQ && dInACK;
		assign rEn = dOutREQ && dOutACK;
		assign DepthDec = !wEn && rEn;
		assign Depth_en = wEn ^ rEn;
		assign dOutACK = !BufferEmpty;
		assign dInREQ = !BufferFull;

		wire AddrMatch = wAddr[DepthBitWidth-1:0] == rAddr[DepthBitWidth-1:0];

		assign BufferEmpty = AddrMatch && !(wAddr[DepthBitWidth] ^ rAddr[DepthBitWidth]);
		assign BufferFull = AddrMatch && (wAddr[DepthBitWidth] ^ rAddr[DepthBitWidth]);

		QTC_Counter #(
			.bit_width(DepthBitWidth + 1)
		) HeadTracker (
			.clk   (clk),
			.clk_en(wEn),
			.rst   (rst),
			.dOUT  (wAddr)
		);

		QTC_Counter #(
			.bit_width(DepthBitWidth + 1)
		) TailTracker (
			.clk   (clk),
			.clk_en(rEn),
			.rst   (rst),
			.dOUT  (rAddr)
		);

endmodule : Queue_TwoCounter

///////////////////////////////////////////////////////////////////////////////
////// IGNORE BELOW THIS ///// IGNORE BELOW THIS ///// IGNORE BELOW THIS //////
///////////////////////////////////////////////////////////////////////////////

module QTC_Counter #(
    parameter bit_width = 64
)(
	input clk,                   // Clock
	input clk_en,                // Clock Enable
	input rst,                   // Asynchronous reset active high -
	                               // Sets Counter Register to b'0
	output [bit_width-1:0] dOUT  // Current Counter Value
);

	reg [bit_width-1:0] Count = '0;
	assign dOUT = Count;
	always_ff @(posedge clk or posedge rst) begin : proc_Count
		if(rst) begin
			Count <= '0;
		end 
	    else if(clk_en) begin
			Count <= Count + 1'b1;
		end
	end

endmodule
