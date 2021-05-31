// Validated

// Takes in a single value of bidwidth N when an input handshake is made
  // and outputs that same value the next time an output handshake is made.
module SingularBuffer #(
	parameter bit_width = 32
)(
	input clk,    // Clock
	input rst,    // Asynchronous reset active high

	output dInREQ,	
	input  dInACK,
	input  [bit_width-1:0] dIN,

	output dOutACK,
	input  dOutREQ,
	output [bit_width-1:0] dOUT
);

	reg  [bit_width-1:0] dBuffer;
	reg  ValidBuffer;
	wire Advance = (dInACK && dInREQ) || (dOutACK && dOutREQ);

	assign dOutACK = ValidBuffer;
	assign dInREQ = !ValidBuffer || (dOutACK && dOutREQ);
	assign dOUT = dBuffer;

	always_ff @(posedge clk or posedge rst) begin : proc_dBuffer
		if(rst) begin
			dBuffer <= 0;
			ValidBuffer <= 0;
		end 
		else if (Advance) begin
			dBuffer <= dIN;
			ValidBuffer <= dInACK && dInREQ;
		end
	end
endmodule