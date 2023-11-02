import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

# Helper functions for matrix to binary conversions
def matrix_to_binary(mat):
    # Convert a 2x2 matrix to its binary representation.
    binary_val = 0
    for i in range(2):
        for j in range(2):
            binary_val <<= 2
            binary_val |= mat[i][j]
    return binary_val

def output_matrix_to_binary(mat):
    # Convert a 2x2 output matrix to its binary representation.
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
    dut.ui_in.value = 0   # Directly accessing the signal, bypassing submodule reference
    dut.uio_in.value = 0
    dut.rst_n.value = 0

    # Apply reset
    await RisingEdge(dut.clk)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)  # Wait a few clock cycles after de-asserting reset
    dut.ena.value = 1

    # Main test logic
    for test_case in test_matrices:
        a_binary = matrix_to_binary(test_case["A"])
        b_binary = matrix_to_binary(test_case["B"])
        expected_out_binary = output_matrix_to_binary(test_case["expected_out"])

        # Assign the input values
        dut.ui_in.value = a_binary   # Directly accessing the signal, bypassing submodule reference
        dut.uio_in.value = b_binary

        # Wait for the results to be stable
        await ClockCycles(dut.clk, 2)

        # Check results
        combined_result = (int(dut.uo_out.value) << 8) | int(dut.uio_out.value)
        dut._log.info(f"uo_out: {dut.uo_out.value}, uio_out: {dut.uio_out.value}, combined_result: {combined_result}")
        assert combined_result == expected_out_binary, f"Error: for A={test_case['A']}, B={test_case['B']} - expected {test_case['expected_out']} but got {combined_result}"

    dut._log.info("All matrix multiplier tests passed!")









# @cocotb.test()
# async def test_matrix_multiplier(dut):
#     dut._log.info("Starting matrix multiplier test")
    
#     # Define a 10Hz clock (ensure this is correct for your design)
#     clock = Clock(dut.clk, 100, units="us")
#     cocotb.start_soon(clock.start())

#     test_matrices = [
#         # Add test cases here
#         {"A": 0b00000010, "B": 0b00000010, "expected_out": 0b0000000000000100},
#         # ...
#     ]

#     for test_case in test_matrices:
#         # Reset the DUT
#         dut.rst_n.value = 0
#         await ClockCycles(dut.clk, 5)  # Providing a 5 cycle reset
#         dut.rst_n.value = 1

#         # Set input values
#         dut.ui_in.value = test_case["A"]
#         dut.uio_in.value = test_case["B"]
        
#         # Enable the multiplier for 20 cycles
#         dut.ena.value = 1
#         await ClockCycles(dut.clk, 20)
#         dut.ena.value = 0

#         # Check the results
#         result_A = int(dut.uo_out.value)
#         result_B = int(dut.uio_out.value)
#         combined_result = (result_A << 4) | result_B

#         assert combined_result == test_case["expected_out"], f"Error: for A={test_case['A']}, B={test_case['B']} - expected {test_case['expected_out']} but got {combined_result}"
