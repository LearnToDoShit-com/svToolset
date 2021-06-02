// Takes in M values of bitwidth N, outputs in FIFO order.
module Queue #(
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
	output BufferEmpty,
	output OnLastEntry
);
	localparam DepthBitWidth = ($clog2(BufferDepth));
		wire rEn;
		wire wEn;
		wire [DepthBitWidth:0] Depth;
		wire [DepthBitWidth-1:0] rAddr;
		wire [DepthBitWidth-1:0] wAddr;
		wire DepthDec;
		wire Depth_en;
		reg  [BitWidth-1:0] dBuff [(BufferDepth-1):0];	

		always_ff @(posedge clk) begin : proc_dBuffReset
			if(wEn) begin
					dBuff[wAddr] <= dIN;
			end
		end

		assign dOUT = dBuff[rAddr];
		assign wEn = dInREQ && dInACK;
		assign rEn = dOutREQ && dOutACK;
		assign DepthDec = !wEn && rEn;
		assign Depth_en = wEn ^ rEn;
		assign dOutACK = !BufferEmpty;
		assign dInREQ = !BufferFull;


		assign OnLastEntry = (wAddr == (rAddr+1)); //dis no work
		assign BufferEmpty = (wAddr == rAddr) && !(Depth[DepthBitWidth]);
		assign BufferFull = (wAddr == rAddr) && |Depth[DepthBitWidth];

		Counter #(
			.bit_width(DepthBitWidth)
		) HeadTracker (
			.clk   (clk),
			.clk_en(wEn),
			.rst   (rst),
			.dOUT  (wAddr)
		);

		Counter #(
			.bit_width(DepthBitWidth)
		) TailTracker (
			.clk   (clk),
			.clk_en(rEn),
			.rst   (rst),
			.dOUT  (rAddr)
		);

		CounterWLoadAndDec #(
			.bit_width(DepthBitWidth + 1)
		) DepthTracker (
			.clk   (clk),
			.clk_en(Depth_en),
			.rst   (rst),
			.load_en(0),
			.decrement(DepthDec),
			.dIN     (0),
			.dOUT  (Depth)
		);

endmodule : Queue

