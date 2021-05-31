module HandsGoShakey #(
	parameter BitWidth = 8
)(
	input clk,  // Clock
	input rst,  // Asynchronous reset active high

	input  init,
	input  endIN,
	output endOUT,

	output dInREQ,
	input  dInACK,
	input  [BitWidth-1:0]dIN,

	input  dOutREQ,
	output dOutACK,
	output [BitWidth-1:0]dOUT,	
);





endmodule : HandsGoShakey