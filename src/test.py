import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

# Helper functions for matrix to binary conversions
def matrix_to_binary(mat):
    binary_val = 0
    for i in range(2):
        for j in range(2):
            binary_val <<= 2
            binary_val |= mat[i][j]
    return binary_val

def output_matrix_to_binary(mat):
    binary_val = 0
    for i in range(2):
        for j in range(2):
            binary_val <<= 4
            binary_val |= mat[i][j]
    return binary_val

# Define your test matrices
test_matrices = [
    {
        "A": [[2, 2], [2, 2]],
        "B": [[2, 2], [2, 2]],
        "expected_out": [[8, 8], [8, 8]]
    },
    # Add more test cases as needed
]

@cocotb.test()
async def test_matrix_multiplier(dut):
    """Test for matrix multiplication logic."""
    dut._log.info("Starting matrix multiplier test")

    # Start the clock
    clock = Clock(dut.clk, 100, units="us")
    cocotb.start_soon(clock.start())

    # Set initial values
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    # Apply reset
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)
    dut.ena.value = 1

    # Main test logic
    for test_case in test_matrices:
        a_binary = matrix_to_binary(test_case["A"])
        b_binary = matrix_to_binary(test_case["B"])
        expected_out_binary = output_matrix_to_binary(test_case["expected_out"])

        # Assign the input values
        dut.ui_in.value = a_binary
        dut.uio_in.value = b_binary

        # Wait for the result
        await ClockCycles(dut.clk, 2)

        # Combine the output vectors
        actual_out = (int(dut.uo_out.value) << 8) | int(dut.uio_out.value)

        # Check the result
        assert actual_out == expected_out_binary, f"Matrix multiplication result was incorrect: {actual_out:#010b} != {expected_out_binary:#010b}"

    dut._log.info("All tests passed")
