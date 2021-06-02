module SPI_master #(
	parameter BitWidth = 8,
	parameter Mode = 1
)(
	input clk,    // Clock
	input clk_en, // Clock Enable
	input rst,  // Asynchronous reset active high
	
	input  tx_init,
	input  [BitWidth-1:0] dIN,
	output [BitWidth-1:0] dOUT,
	output dOutVALID,

	output sclk,
	input  miso,
	output mosi,
	output ss
);
	localparam DepthBitWidth = $clog2(BitWidth) + 1;

	wire Active = (TxDepth > 0);

	reg [BitWidth-1:0] dBuff = 0;
	reg [BitWidth-1:0] TxDepth = 0;

	assign mosi = Active ? dBuff[BitWidth-1] : 0;
	assign ss = !Active;
	assign dOUT = !Active ? dBuff : 0;
	assign dOutVALID = Active;

	generate
		/////////////////////////////////////////////////////////////// MODE 0
		if (Mode == 0) begin
			assign sclk = Active & clk; 
			always_ff @(posedge !clk or posedge rst) begin : proc_Count
				if(rst) begin
					TxDepth <= 0;
				end 
			    else if(clk_en & (Active | tx_init)) begin
					if (!tx_init) begin
						TxDepth <= TxDepth - 1;
					end
					else begin
			        	TxDepth <= BitWidth;
			        end
			    end	
			end		
			always_ff @(posedge !clk or posedge rst) begin : proc_SPIdBuff
				if(rst) begin
					dBuff <= 0;
				end 
				else if(clk_en & (Active | tx_init)) begin
					dBuff <= tx_init ? dIN : {dBuff[BitWidth-2:0],miso};
				end
			end
		end
		/////////////////////////////////////////////////////////////// MODE 1
		else if (Mode == 1) begin
		assign sclk = Active & clk; 
			always_ff @(posedge clk or posedge rst) begin : proc_Count
				if(rst) begin
					TxDepth <= 0;
				end 
			    else if(clk_en & (Active | tx_init)) begin
					if (!tx_init) begin
						TxDepth <= TxDepth - 1;
					end
					else begin
			        	TxDepth <= BitWidth;
			        end
			    end	
			end		
			always_ff @(posedge clk or posedge rst) begin : proc_SPIdBuff
				if(rst) begin
					dBuff <= 0;
				end 
				else if(clk_en & (Active | tx_init)) begin
					dBuff <= tx_init ? dIN : {dBuff[BitWidth-2:0],miso};
				end
			end
		end
		/////////////////////////////////////////////////////////////// MODE 2
		else if (Mode == 2) begin
		assign sclk = !(Active & clk); 
			always_ff @(negedge !clk or negedge rst) begin : proc_Count
				if(!rst) begin
					TxDepth <= 0;
				end 
			    else if(clk_en & (Active | tx_init)) begin
					if (!tx_init) begin
						TxDepth <= TxDepth - 1;
					end
					else begin
			        	TxDepth <= BitWidth;
			        end
			    end	
			end
			always_ff @(negedge !clk or negedge rst) begin : proc_SPIdBuff
				if(!rst) begin
					dBuff <= 0;
				end 
				else if(clk_en & (Active | tx_init)) begin
					dBuff <= tx_init ? dIN : {dBuff[BitWidth-2:0],miso};
				end
			end
		end
		/////////////////////////////////////////////////////////////// MODE 3
		else if(Mode == 3) begin
			assign sclk = !(Active & clk); 
			always_ff @(negedge clk or negedge rst) begin : proc_Count
				if(!rst) begin
					TxDepth <= 0;
				end 
			    else if(clk_en & (Active | tx_init)) begin
					if (!tx_init) begin
						TxDepth <= TxDepth - 1;
					end
					else begin
			        	TxDepth <= BitWidth;
			        end
			    end	
			end
			always_ff @(negedge clk or negedge rst) begin : proc_SPIdBuff
				if(!rst) begin
					dBuff <= 0;
				end 
				else if(clk_en & (Active | tx_init)) begin
					dBuff <= tx_init ? dIN : {dBuff[BitWidth-2:0],miso};
				end
			end
		end
	endgenerate
endmodule : SPI_master