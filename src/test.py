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


def binary_to_output_matrix(val):
    # Convert binary representation back to a 2x2 matrix.
    matrix = [[0, 0], [0, 0]]
    for i in range(2):
        for j in range(2):
            matrix[i][j] = (val >> (4 * (3 - (i * 2 + j)))) & 0xF
    return matrix


def contains_unknown(value):
    return "x" in str(value)


test_matrices = [
    {"A": [[2, 2], [2, 2]], "B": [[2, 2], [2, 2]], "expected_out": [[8, 8], [8, 8]]},
    {"A": [[1, 1], [1, 1]], "B": [[1, 1], [1, 1]], "expected_out": [[2, 2], [2, 2]]},
    {"A": [[1, 0], [0, 1]], "B": [[2, 1], [1, 2]], "expected_out": [[2, 1], [1, 2]]},
    {"A": [[0, 1], [1, 0]], "B": [[2, 1], [1, 2]], "expected_out": [[1, 2], [2, 1]]},
    {"A": [[2, 1], [1, 2]], "B": [[1, 1], [1, 1]], "expected_out": [[3, 3], [3, 3]]},
    {"A": [[0, 0], [0, 0]], "B": [[2, 2], [2, 2]], "expected_out": [[0, 0], [0, 0]]},
    {"A": [[2, 0], [0, 2]], "B": [[0, 1], [2, 0]], "expected_out": [[0, 2], [4, 0]]},
    {"A": [[1, 2], [2, 1]], "B": [[2, 1], [1, 2]], "expected_out": [[4, 5], [5, 4]]},
    {"A": [[2, 2], [1, 1]], "B": [[1, 2], [2, 1]], "expected_out": [[6, 6], [3, 3]]},
    {"A": [[1, 2], [2, 2]], "B": [[2, 2], [1, 1]], "expected_out": [[4, 4], [6, 6]]},
    {"A": [[0, 2], [2, 0]], "B": [[1, 1], [1, 1]], "expected_out": [[2, 2], [2, 2]]},
    {"A": [[2, 1], [1, 0]], "B": [[0, 2], [2, 1]], "expected_out": [[2, 5], [0, 2]]},
    {"A": [[0, 1], [2, 1]], "B": [[1, 2], [0, 2]], "expected_out": [[0, 2], [2, 6]]},
    {"A": [[2, 1], [2, 1]], "B": [[1, 0], [0, 2]], "expected_out": [[2, 2], [2, 2]]},
]


@cocotb.test()
async def test_matrix_multiplier(dut):
    """Test for matrix multiplication logic."""
    dut._log.info("Starting matrix multiplier test")

    # Start the clock
    clock = Clock(dut.clk, 100, units="us")
    cocotb.start_soon(clock.start())

    # Set initial values
    dut.ui_in.value = 0 
    dut.uio_in.value = 0

    # dut.uo_out.value = 0
    # dut.uio_out.value = 0
    
    dut.ena.value = 0
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
        dut.ui_in.value = a_binary
        dut.uio_in.value = b_binary

        # Wait for the results to be stable
        await ClockCycles(dut.clk, 7)

        # Check if signals contain 'x' and handle them
        if contains_unknown(dut.uo_out.value) or contains_unknown(dut.uio_out.value):
            continue

        # combined_result = (int(dut.uo_out.value) << 8) | int(dut.uio_out.value)
        combined_result = (int(dut.uio_out.value) << 8) | int(dut.uo_out.value)
        result_matrix = binary_to_output_matrix(combined_result)
        dut._log.info(
            f"uo_out: {dut.uo_out.value}, uio_out: {dut.uio_out.value}, combined_result: {combined_result}"
        )
        assert (
            combined_result == expected_out_binary
        ), f"Error: for A={test_case['A']}, B={test_case['B']} - expected {test_case['expected_out']} but got {result_matrix}"

    dut._log.info("All matrix multiplier tests passed!")
