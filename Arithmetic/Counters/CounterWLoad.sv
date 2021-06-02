// Validated

module CounterWLoad #(
    parameter bit_width = 64
)(
	input clk,                   // Clock
	input clk_en,                // Clock Enable
	input rst,                   // Asynchronous reset active high -
	                               // Sets Counter Register to b'0
    input load_en,              // Loads value dIN into Counter when;
                                  // load_en is high.
    input  [bit_width-1:0] dIN,
    output [bit_width-1:0] dOUT  // Current Counter Value

);

	reg [bit_width-1:0] Count = '0;
	assign dOUT = Count;
	always_ff @(posedge clk or posedge rst) begin : proc_Count
		if(rst) begin
			Count <= '0;
		end 
	    else if(clk_en) begin
			if (!load_en) begin
				Count <= Count + 1'b1;
			end
			else begin
	        	Count <= dIN;
	        end
	    end	
	end
endmodule