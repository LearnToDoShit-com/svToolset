# Part Name: SPI Controller
* Creator Name: gracefu
* Date Created: 26 May 2021
* Date Last Updated: 26 May 2021
* Version: 0.1
* Validation Status: I wrote a small testbench ig? Not very thorough.
* Description: Implements a basic SPI controller which lets you send / receive a parameterizable number of bits at a time easily.
* Notes: The SPI controller doesn't provide an inbuilt counter that indicates when the required number of bits have been received, but you may consult the included spi_adder_test module to see how one might go about hooking up functionality to the SPI controller.


* Testbench Name: SPI controller testbench
* Creator Name: gracefu
* Date Created: 26 May 2021
* Date Last Updated: 26 May 2021
* Version: 0.1
* Description: Tests the spi_adder_module to see that data can be sent to the slave unit.
* Notes:
