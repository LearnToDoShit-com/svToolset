module Multiplexer #(
	parameter PortCount = 4,
	parameter BitWidth = 8
)(
	input [PortCount-1:0] sel,    
	input [PortCount-1:0][BitWidth-1:0] dIN,
	output [BitWidth-1:0] dOUT
);
	assign dOUT = dIN[sel];
endmodule : Multiplexer


module AND_TwoInput #(
	parameter PortCount = 4,
	parameter BitWidth = 8
)(
	input [PortCount-1:0] sel,    
	input [PortCount-1:0][BitWidth-1:0] dIN,
	output [BitWidth-1:0] dOUT
);
	assign dOUT = dA && dB;
endmodule


module AND_MultiInput #(
	parameter PortCount = 4,
	parameter BitWidth = 8
)(
	input [PortCount-1:0] sel,    
	input [PortCount-1:0][BitWidth-1:0] dIN,
	output [BitWidth-1:0] dOUT
);
	assign dOUT = dA && dB;
endmodule


module and_multiinput #(
BitWidth = 8
)(
    input [BitWidth-1:0] in,
    output out
);
    assign out = &in;
endmodule



	Dev	| Validation
1 | 7m	| 	5m 		// New to FPGAs
2 | 4m	| 	3m 		// Still learning
4 | 6m	| 	3m 		// Still using Logisim Evolution...
5 | 2m	| 	44hr 	// Used system verilog after 
					  // making a very simple lib
6 |	4d	|	1d		///// Fulll projects, using lib
						/// and FPGA validated
