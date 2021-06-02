module WARAvoidanceForwardEnabler_NOperands #(
	parameter ReadOperandCount = 3,
	parameter ForwardDepth = 1, // Number of stages the 
	parameter RegisterCount = 8 // Amount of registers the CPU has
)(
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst,    // Asynchronous reset active high

	input [RegAddrWidth-1:0] ReadOperands [ReadOperandCount-1:0],
	input [RegAddrWidth-1:0] WriteOperand,

	output [ForwardDepth-1:0] FwdEnable [ReadOperandCount-1:0]
);
	// What bit width do we need the Register Address to be?
	localparam RegAddrWidth = $clog2(RegisterCount);

	// Instantiate a register for each stage for which the system requires forwarding. 
	reg [ForwardDepth-1:0][RegAddrWidth-1:0] WriteOperandBuffer;
	generate
		genvar i;
		for(i = 0; i < ForwardDepth; i = i + 1) begin : HazardTableGeneration
			always_ff @(posedge clk or posedge rst) begin : proc_WriteOperandBuffer
				if(rst) begin
					WriteOperandBuffer[i] <= 0;
				end
				else if(clk_en) begin
					WriteOperandBuffer[i] <= (i == 0) ? WriteOperand : WriteOperandBuffer[i-1];
				end
			end
			// Compare the current stage's buffer with both incoming operands,
			// Return 1 if a forward on that stage and operand is required.
			genvar j;
			for(j = 0; j < ReadOperandCount; j = j + 1) begin : HazardCheckArrayGeneration
				assign FwdEnable[j][i] = (ReadOperands[j] == WriteOperandBuffer[i]);
			end
		end
	endgenerate
endmodule : WARAvoidanceForwardEnabler_NOperands