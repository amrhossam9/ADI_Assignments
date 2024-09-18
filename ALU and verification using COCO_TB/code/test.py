# Import required cocotb libraries
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import FallingEdge, RisingEdge, ReadOnly

@cocotb.test()
async def tb_top(dut):
    cocotb.log.info("STARTING SIMULATION")
    
    # Start the clock
    clk = Clock(dut.CLK, 10, units="ns")
    cocotb.start_soon(clk.start())
    
    # Start the driving stimulus
    await cocotb.start_soon(driving_stimulus(dut))
    
    cocotb.log.info("After Driving Stimulus")
    
async def test(dut, A, B, ALU_FUN):
	# Wait for the falling edge of the clock
    await FallingEdge(dut.CLK)
    
    # Apply stimulus
    dut.A.value = A
    dut.B.value = B
    dut.ALU_FUN.value = ALU_FUN
    
    # Wait for the rising edge of the clock
    await RisingEdge(dut.CLK)
    
    # Ensure no modifications during ReadOnly phase
    await ReadOnly()
    
    # Expected output
    if(ALU_FUN == 0):
        Expected = A + B
    elif(ALU_FUN == 1):
    	Expected = A - B
    elif(ALU_FUN == 2):
    	Expected = A * B
    else:
        Expected = A / B
    ALU_OUT = int(dut.ALU_OUT.value)
    if ALU_OUT >= 128 and ALU_FUN == 1:  # To Handle subtraction
    	ALU_OUT = ALU_OUT - 256
        
    # Log the output value
    if(Expected == ALU_OUT):
        cocotb.log.info(f"PASSED : A = {A}, B = {B}, ALU_FUN = {ALU_FUN} -> {ALU_OUT}")
    else:
        cocotb.log.info(f"Failed : A = {A}, B = {B}, ALU_FUN = {ALU_FUN} -> {ALU_OUT}")
                        
async def driving_stimulus(dut):
   await test(dut, 1, 2, 0)
   await test(dut, 15, 1, 0)
    
   await test(dut, 4, 3, 1)
   await test(dut, 1, 4, 1)
    
   await test(dut, 2, 3, 2)
   await test(dut, 15, 2, 2)
    
   await test(dut, 4, 2, 3)
   await test(dut, 15, 1, 3)
    
   await test(dut, 15, 15, 0)
   await test(dut, 15, 15, 1)
   await test(dut, 15, 15, 2)
   await test(dut, 15, 15, 3)
