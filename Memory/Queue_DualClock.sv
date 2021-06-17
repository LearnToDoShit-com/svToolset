// Requires Counter (Refrence at bottom) ///!!!!!!!!!!!!!!!!!//

//To aid in stability, the buffer needs some "breathing room" when dual clocked. Needs to be added by preventing the addresses from truly colliding,
//Which can be acomplished by Setting Full when the Full condition is met and clearing it when their is at least 2 open locations in the queue.
//
//Think about how to prenent address metastability issues on Reading...  

// Takes in M values of bitwidth N, outputs in FIFO order.
module Queue_DualClock #(
	parameter BitWidth = 32,
	parameter BufferDepth = 8
)(
	input wclk,  // Write Clock
	input rclk,  // Read Clock
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

	// Handshake stuff
	wire wEn = dInREQ && dInACK;
	wire rEn = dOutREQ && dOutACK;
	assign dOutACK = !EmptyReg;
	assign dInREQ = !FullReg;

	// Address and memory instantiation
	wire [DepthBitWidth:0] rAddr;
	wire [DepthBitWidth:0] wAddr;
	reg  [BitWidth-1:0] dBuff [(BufferDepth-1):0];	

	// Write data on the Write Clock
	always_ff @(posedge wclk) begin : proc_dBuffReset
		if(wEn) begin
			dBuff[wAddr[DepthBitWidth-1:0]] <= dIN;
		end
	end
	// Assign dOUT when rEn
	assign dOUT = EmptyReg ? 0 : dBuff[rAddr[DepthBitWidth-1:0]];

	// Is there an address collision?
	wire AddrMatch = wAddr[DepthBitWidth-1:0] == rAddr[DepthBitWidth-1:0];

	// Full Tracking for the Write
	wire FullTemp = AddrMatch && (wAddr[DepthBitWidth] ^ rAddr[DepthBitWidth]);
	reg  FullReg;
	// This FullReg garentees the cycle after you fill the buffer,
		// you will be told its full and you will not be able to write another
		// value. This is clocked on the Write clock, in order to make sure the
		// handshake is metastable on the Data In side. 
	always_ff @(posedge wclk) begin
		FullReg <= FullTemp;
	end
	assign BufferFull = FullReg;

	// Empty Tracking or the Read
	wire EmptyTemp = AddrMatch && (wAddr[DepthBitWidth] && rAddr[DepthBitWidth]);
	reg  EmptyReg;
	// This EmptyReg garentees the cycle after you empty the buffer,
		// you will be told its empty and you will not be able to read another
		// value. This is clocked on the Read clock, in order to make sure the
		// handshake is metastable on the Data Out side. 
	always_ff @(posedge rclk) begin
		EmptyReg <= EmptyTemp;
	end
	assign BufferEmpty = EmptyReg;

	// Increment Write Address on Writes
	QDC_Counter #(
		.bit_width(DepthBitWidth + 1)
	) HeadTracker (
		.clk   (wclk),
		.clk_en(wEn),
		.rst   (rst),
		.dOUT  (wAddr)
	);

	// Increment Read Address on Reads
	QDC_Counter #(
		.bit_width(DepthBitWidth + 1)
	) TailTracker (
		.clk   (rclk),
		.clk_en(rEn),
		.rst   (rst),
		.dOUT  (rAddr)
	);

endmodule : Queue_DualClock


///////////////////////////////////////////////////////////////////////////////
////// IGNORE BELOW THIS ///// IGNORE BELOW THIS ///// IGNORE BELOW THIS //////
///////////////////////////////////////////////////////////////////////////////


module QDC_Counter #(
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