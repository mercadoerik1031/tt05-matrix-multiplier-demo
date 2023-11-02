import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles
from cocotb.binary import BinaryValue

@cocotb.test()
async def test_matrix_multiplier(dut):
    """Test for matrix multiplication logic."""
    dut._log.info("Starting matrix multiplier test")
    
    clock = Clock(dut.clk, 10, units="ns")  # 10ns period for a 100MHz clock
    cocotb.start_soon(clock.start())        # Start the clock
    
    # Reset
    dut.rst_n.value = 0
    dut.ena.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1
    
    test_matrices = [
        {'A': 0x1234, 'B': 0x5678, 'Expected': 0xE208},
        {'A': 0xFFFF, 'B': 0x0001, 'Expected': 0xFFFF},
    ]
    
    for test_case in test_matrices:
        dut.a.value = test_case['A']
        dut.b.value = test_case['B']
        dut.ena.value = 1
        
        await ClockCycles(dut.clk, 1)
        
        # Check for error flag
        error_flag_out = dut.error_flag_out.value
        assert error_flag_out == (test_case['Expected'] > 0xFFFF), f"Error flag incorrect for inputs A={test_case['A']}, B={test_case['B']}"
        dut._log.info(f"Error Flag: {error_flag_out}")
        
        # Check the output of the multiplier
        if not error_flag_out:
            expected_bin = BinaryValue(test_case['Expected'], n_bits=32, bigEndian=False).binstr
            assert dut.uo_out.value.binstr == expected_bin[-16:-8], f"Upper output failed with A={test_case['A']}, B={test_case['B']}"
            assert dut.uio_out.value.binstr == expected_bin[-8:], f"Lower output failed with A={test_case['A']}, B={test_case['B']}"
            dut._log.info("Passed test with A=%s, B=%s, Expected=%s", test_case['A'], test_case['B'], test_case['Expected'])
        
        dut.ena.value = 0
        await ClockCycles(dut.clk, 1)
