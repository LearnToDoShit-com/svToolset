module SPI_slave #(
	parameter BitWidth = 8,
	parameter Mode = 1
)(
	input clk,
	input clk_en,
	input rst,
	
	input load_en,
	input  [BitWidth-1:0] dIN,
	output [BitWidth-1:0] dOUT,
	output dOutVALID,	

	input  sclk,
	output miso,
	input  mosi,
	input  ss
);


///// add a stale data prevention [ie, a flag that comes on after the first load_en,
	// allowing the peripheral to garentee data order and prevent data point drops]
	
	assign miso = !ss ? dTemp[BitWidth-1] : 0;
	assign dOUT = ss ? dBuff : 0;
	assign dOutVALID = ss;
	wire [BitWidth-1:0] dTemp = !(ss | ssBuff) ? {dINBuff[BitWidth-2:0],mosi} : {dBuff[BitWidth-2:0],mosi};

	reg [BitWidth-1:0] dINBuff;
	always_ff @(posedge clk or posedge rst) begin : proc_dBuff
		if(rst) begin
			dINBuff <= 0;
		end
		else if(clk_en & load_en & ss) begin
			dINBuff <= dIN;
		end
	end
	reg ssBuff;
	always_ff @(posedge clk or posedge rst) begin : proc_Init
		if(rst) begin
			ssBuff <= 0;
		end
		else if(clk_en) begin
			ssBuff <= ss;
		end
	end	

	generate
		if (Mode == 0) begin
			reg [BitWidth-1:0] dBuff;
			always_ff @(posedge !sclk or posedge rst) begin : proc_SPIdBuff
				if(rst) begin
					dBuff <= 0;
				end 
				else if(clk_en & !ss) begin
					dBuff <= dTemp;
				end
			end
		end
		else if(Mode == 1) begin
			reg [BitWidth-1:0] dBuff;
			always_ff @(posedge sclk or posedge rst) begin : proc_SPIdBuff
				if(rst) begin
					dBuff <= 0;
				end 
				else if(clk_en & !ss) begin
					dBuff <= dTemp;
				end
			end
		end
		else if(Mode == 2) begin
			reg [BitWidth-1:0] dBuff;
			always_ff @(negedge !sclk or negedge rst) begin : proc_SPIdBuff
				if(rst) begin
					dBuff <= 0;
				end 
				else if(clk_en & !ss) begin
					dBuff <= dTemp;
				end
			end
		end
		else if(Mode == 3) begin
			reg [BitWidth-1:0] dBuff;
			always_ff @(negedge sclk or negedge rst) begin : proc_SPIdBuff
				if(rst) begin
					dBuff <= 0;
				end 
				else if(clk_en & !ss) begin
					dBuff <= dTemp;
				end
			end
		end
	endgenerate
endmodule : SPI_slave