import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_matrix_multiplier(dut):
    dut._log.info("Starting matrix multiplier test")
    clock = Clock(dut.clk, 10, units="us")  # Adjust clock period if needed
    cocotb.start_soon(clock.start())

    # Reset the design
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 1)
    dut.rst_n.value = 1

    test_matrices = [
    {"A": 0b00100010, "B": 0b00100010, "expected_out": 0b1000100010001000},
    # Add more test cases as needed
]


    for test_case in test_matrices:
        # Set input values
        dut.ui_in.value = test_case["A"]
        dut.uio_in.value = test_case["B"]
        # Enable the multiplier
        dut.ena.value = 1
       
        for _ in range(5):
            await RisingEdge(dut.clk)
            
        dut.ena.value = 0

        # Check the results
        result_A = int(dut.uo_out.value)
        result_B = int(dut.uio_out.value)

        combined_result = (result_A << 4) | result_B

        assert combined_result == test_case["expected_out"], f"Error: for A={test_case['A']}, B={test_case['B']} - expected {test_case['expected_out']} but got {combined_result}"

        # Reset for the next test case
        dut.rst_n.value = 0
        await ClockCycles(dut.clk, 1)
        dut.rst_n.value = 1

