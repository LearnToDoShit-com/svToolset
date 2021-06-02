// SPI pins, connect to master / slave:
//
// sclk, mosi, miso, negss:
//   SPI, expose these pins to pinout probably unless doing weird
//   inter-component SPI stuff
//
//   For slaves, connect negss to the master.
//   For masters, you will probably set negss of the controller
//   to active low (= 0) so the controller is always active,
//   and then expose negss pins for the slaves to connect to.
//
//   That's basically the only difference between master / slave,
//   so this is just one module that can be configured to do either.
//
// Internal pins, connect to your shit:
//
// dOut:
//   The contents of the shift register
//
// dIn, write_en:
//   If write_en = 1, then instead of shifting the current contents of the
//   shift reg, dIn is used instead, so the contents of the shift reg is
//   replaced by the lower ShiftRegWidth-1 bits of dIn,
//   and miso is set to the msb of dIn.
//
//   You probably want to write to write_en on the opposite of the spi edge,
//   e.g. if CPOL = CPHA = 0, then the spi edge is the falling edge of sclk,
//   so you should set write_en on the rising edge of sclk to prevent a race.
module spi_controller #(
  parameter integer ShiftRegWidth = 8,
  parameter integer CPOL = 0,
  parameter integer CPHA = 0
)(
  input sclk,
  input mosi,
  output miso,
  input negss,

  output [ShiftRegWidth-1:0] dOut,
  input [ShiftRegWidth-1:0] dIn,
  input write_en
);

reg [ShiftRegWidth-1:0] data; // triggered on the spi edge
reg miso_reg;
assign miso = miso_reg;
assign dOut = data;

generate

if (CPOL == 0 & CPHA == 0)
begin
  // sclk is tied low, so if we AND it with ss, we won't get an edge
  always_ff @ (negedge (sclk & ~negss))
    {miso_reg, data[ShiftRegWidth-1:0]} <= {write_en ? dIn : data[ShiftRegWidth-1:0], mosi};
end

else if (CPOL == 0 & CPHA == 1)
begin
  // sclk is tied low, so if we AND it with ss, we won't get an edge
  always_ff @ (posedge (sclk & ~negss))
    {miso_reg, data[ShiftRegWidth-1:0]} <= {write_en ? dIn : data[ShiftRegWidth-1:0], mosi};
end

else if (CPOL == 1 & CPHA == 0)
begin
  // sclk is tied high, so if we OR it with negss, we won't get an edge
  always_ff @ (negedge (sclk | ~negss))
    {miso_reg, data[ShiftRegWidth-1:0]} <= {write_en ? dIn : data[ShiftRegWidth-1:0], mosi};
end

else if (CPOL == 1 & CPHA == 1)
begin
  // sclk is tied high, so if we OR it with negss, we won't get an edge
  always_ff @ (posedge (sclk | ~negss))
    {miso_reg, data[ShiftRegWidth-1:0]} <= {write_en ? dIn : data[ShiftRegWidth-1:0], mosi};
end

endgenerate

endmodule

module spi_adder_test
(
  input sclk,
  input mosi,
  output miso,
  input negss
);

// We hook negss to rst of a counter so when negss turns off, that starts the counter.
// Then we wait for 8 cycles of sclk, and when that completes, the counter
// overflows and we increment the shift reg by 25, so that will be sent back
// to master on the next 8 sclk cycles.

reg [2:0] counter;
reg counter_carry;

logic [7:0] data;
logic [7:0] new_data;
reg write_en;

spi_controller ctl(
  .sclk(sclk),
  .mosi(mosi),
  .miso(miso),
  .negss(negss),
  .dOut(data),
  .dIn(new_data),
  .write_en(write_en));

assign new_data = data + 25;

// Opposite of spi edge
// data is stable, we should set write_en here
always_ff @ (posedge sclk)
begin
  if (~negss)
    write_en <= counter_carry;
end

// spi edge
// data is coming in but not stable yet
// use this time to drive the counter logic so counter_carry is available for
// us on opposite edge
always_ff @ (negedge sclk)
begin
  if (negss)
  begin
    counter <= 0;
    counter_carry <= 0;
  end
  else
    {counter_carry, counter} <= counter + 1;
end

endmodule
