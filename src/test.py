import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def test_matrix_multiplier(dut):
    dut._log.info("Starting matrix multiplier test")
    
    # Define a 10Hz clock (ensure this is correct for your design)
    clock = Clock(dut.clk, 100, units="us")
    cocotb.start_soon(clock.start())

    test_matrices = [
        # Add test cases here
        {"A": 0b00000010, "B": 0b00000010, "expected_out": 0b0000001000000010},
        # ...
    ]

    for test_case in test_matrices:
        # Reset the DUT
        dut.rst_n.value = 0
        await ClockCycles(dut.clk, 5)  # Providing a 5 cycle reset
        dut.rst_n.value = 1

        # Set input values
        dut.ui_in.value = test_case["A"]
        dut.uio_in.value = test_case["B"]
        
        # Enable the multiplier for 20 cycles
        dut.ena.value = 1
        await ClockCycles(dut.clk, 20)
        dut.ena.value = 0

        # Check the results
        result_A = int(dut.uo_out.value)
        result_B = int(dut.uio_out.value)
        combined_result = (result_A << 4) | result_B

        assert combined_result == test_case["expected_out"], f"Error: for A={test_case['A']}, B={test_case['B']} - expected {test_case['expected_out']} but got {combined_result}"
