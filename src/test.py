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
        "A": [[0, 1], [0, 0]],
        "B": [[0, 1], [0, 0]],
        "expected_out": [[0, 0], [0, 0]]
    },
    # Add other test cases as needed...
]

@cocotb.test()
async def test_matrix_multiplier(dut):
    """Test for matrix multiplication logic."""

    # Set initial values
    dut.ena <= 0
    dut.ui_in <= 0
    dut.uio_in <= 0
    dut.rst_n <= 0

    # Apply reset
    await RisingEdge(dut.clk)
    dut.rst_n <= 1
    await RisingEdge(dut.clk)
    dut.ena <= 1

    # Main test logic
    for test_case in test_matrices:
        a_binary = matrix_to_binary(test_case["A"])
        b_binary = matrix_to_binary(test_case["B"])
        expected_out_binary = output_matrix_to_binary(test_case["expected_out"])

        # Assign the input values
        dut.ui_in <= a_binary
        dut.uio_in <= b_binary

        # Wait for a clock cycle to get the output
        await RisingEdge(dut.clk)

        # Check results
        combined_result = (int(dut.uo_out.value) << 8) | int(dut.uio_out.value)
        assert combined_result == expected_out_binary, f"Error: for A={test_case['A']}, B={test_case['B']} - expected {test_case['expected_out']} but got {combined_result}"

    # Add any cleanup or other operations here if necessary
    # ...

    cocotb.result.passed("All matrix multiplier tests passed!")





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
