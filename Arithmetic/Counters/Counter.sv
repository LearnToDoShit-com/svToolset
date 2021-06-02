// Validated

module Counter #(
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