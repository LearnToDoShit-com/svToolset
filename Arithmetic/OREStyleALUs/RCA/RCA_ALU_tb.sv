`timescale 1ns / 1ps
module RCA_ALU_tb ();
	// Put dem localparams here bois
	//          |
	//        \ | /
	//         \|/
	localparam PrimaryBitWidth = 4;
	localparam CycleLimit = 2;
	
	// Clock and reset initalization shiz
	reg clk = 0;
	reg rst = 0;
	initial begin
		#10 rst = 1;
		#10 rst = 0;
	end
	always #100 clk = !clk;


	// Dis be your cycle limit counter, this will force stop the test
	// after your cycle count hits your CycleLimit
	//          |
	//        \ | /
	//         \|/	
	always_comb begin
		if (CycleCount == CycleLimit) begin
			$finish;
		end
	end
	wire [31:0] CycleCount;
	tbCounter #(
		.bit_width(32)
	) CycleCounter (
		.clk   (clk),
		.clk_en(1),
		.rst   (rst),
		.dOUT  (CycleCount)
	);


	reg init = 1;
	reg Advance = 0;
	reg Tic = 0;
	reg Toc = 0;
	always_ff @(posedge clk) begin : proc_TicTokerson
		if (Advance) begin
			// This is a half clock, Tic spends 1 cycle on, 1 cycle off
			//          |
			//        \ | /
			//         \|/	
			Tic = !Tic;
			// Dis be dat display stuff dem kids talk 'bout
			//          |
			//        \ | /
			//         \|/				
			$display("> END");						
			$display(">>>>>>>> CYCLE %0d <<<<<<<<", CycleCount);
			$display("> START");
			$display("dINA %0b", dINA);
			$display("dINB %0b", dINB);
			$display("dOUT %0b", dOUT);
	    end
	    else if (init) begin
			init <= 0;
			Advance <= 1;
			// Put dat init stuffs her'
			//          |
			//        \ | /
			//         \|/
		end 
			// This halves Tic, so Toc will be on for 2 cycles, off for 2 cycles.
			//          |
			//        \ | /
			//         \|/
		if (Tic) begin
			Toc = !Toc;
		end
	end

	
	// Put dat shit chu wanna test here
	//          |
	//        \ | /
	//         \|/




	//                    {InvA,InvB,cIn,ORen,FloodCarry}
	wire [4:0] ControlVect = {1'b0,1'b0,1'b0,1'b0,1'b0};
	wire [PrimaryBitWidth:0] dOUT;
	wire [PrimaryBitWidth:0] dINA;
	wire [PrimaryBitWidth:0] dINB;
	assign dINA[PrimaryBitWidth-1:0] = 4'b0011;
	assign dINB[PrimaryBitWidth-1:0] = 4'b0101;


	// This just adds an MSB of 1 to your values to force
		// all bits to show in the $display above
	assign dOUT[PrimaryBitWidth] = 1'b1;
	assign dINA[PrimaryBitWidth] = 1'b1;
	assign dINB[PrimaryBitWidth] = 1'b1;

	RCA_ALU #(
		.BitWidth(PrimaryBitWidth)
	) ALUtest (
			.InvA      (ControlVect[4]),
			.InvB      (ControlVect[3]),
			.cIn       (ControlVect[2]),
			.ORen      (ControlVect[1]),
			.FloodCarry(ControlVect[0]),
			.cOut      (cOut),
			.ifZero    (ifZero),
			.overflow  (overflow),
			.dINA      (dINA[PrimaryBitWidth-1:0]),
			.dINB      (dINB[PrimaryBitWidth-1:0]),
			.dOUT      (dOUT[PrimaryBitWidth-1:0])
	);


endmodule : RCA_ALU_tb

///////////////////////////////////////////////////////////////////////////////
////// IGNORE BELOW THIS ///// IGNORE BELOW THIS ///// IGNORE BELOW THIS //////
///////////////////////////////////////////////////////////////////////////////

// Modules used above are created below

module tbCounter #(
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

module tbCounterWLoad #(
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