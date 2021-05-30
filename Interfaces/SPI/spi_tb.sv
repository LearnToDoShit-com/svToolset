module spi_adder_test_tb;

reg sclk;
reg mosi;
logic miso;
reg negss;

spi_adder_test a(
  .sclk(sclk),
  .mosi(mosi),
  .miso(miso),
  .negss(negss));

initial
begin
  {sclk, mosi, negss} <= 3'b001;
  // First we enable the chip
  #1; {sclk, mosi, negss} <= 3'b000;

  // Now we push the data in via 8 clock cycles
  // We'll push in 00000000 for this test
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;

  // Data has been pushed in. We now clock it another 8 more times.
  // After each clock, we print out miso.
  // We should expect 25 to be printed, with MSB first.
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);

  // This time, let's push in 10, aka 00001010
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b110;
  #1; {sclk, mosi, negss} <= 3'b010;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; {sclk, mosi, negss} <= 3'b110;
  #1; {sclk, mosi, negss} <= 3'b010;
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;

  // Data has been pushed in. We now clock it another 8 more times.
  // After each clock, we print out miso.
  // We should expect 35 to be printed, with MSB first.
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
  #1; {sclk, mosi, negss} <= 3'b100;
  #1; {sclk, mosi, negss} <= 3'b000;
  #1; $display("%b", miso);
end

endmodule
