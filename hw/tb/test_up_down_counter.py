import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

def count_int(dut):
    return int(dut.count_val.value)

async def tick_and_settle(dut, cycles=1):
    for _ in range(cycles):
        await RisingEdge(dut.clk)
    await Timer(1, unit="step")

async def setup_dut(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    dut.rst_n.value = 1
    dut.en.value = 0
    dut.load_en.value = 0
    dut.count_dir.value = 1
    dut.load_data.value = 0
    await Timer(1, unit="ns")

@cocotb.test()
async def test_async_reset(dut):
    await setup_dut(dut)
    dut._log.info("Test 1: asynchronous reset -> 0x00")

    dut.load_en.value = 1
    dut.en.value = 1
    dut.load_data.value = 0xA5
    await RisingEdge(dut.clk)

    await Timer(2, unit="ns")
    dut.rst_n.value = 0
    await Timer(1, unit="ns")
    assert count_int(dut) == 0x00, f"Reset failed: expected 0x00, got 0x{count_int(dut):02X}"
    await Timer(7, unit="ns")
    dut.rst_n.value = 1

@cocotb.test()
async def test_load_priority_over_enable(dut):
    await setup_dut(dut)
    dut._log.info("Test 2: load priority over enable -> 0x3C")

    dut.load_data.value = 0x3C
    dut.load_en.value = 1
    dut.en.value = 1
    dut.count_dir.value = 1
    await tick_and_settle(dut)
    assert count_int(dut) == 0x3C, f"Load failed: expected 0x3C, got 0x{count_int(dut):02X}"

@cocotb.test()
async def test_count_up(dut):
    await setup_dut(dut)
    dut._log.info("Test 3: count up 0x3C -> 0x3D")

    dut.load_data.value = 0x3C
    dut.load_en.value = 1
    dut.en.value = 1
    await tick_and_settle(dut)
    dut.load_en.value = 0
    await tick_and_settle(dut)
    assert count_int(dut) == 0x3D, f"Count up failed: expected 0x3D, got 0x{count_int(dut):02X}"

@cocotb.test()
async def test_hold_when_enable_low(dut):
    await setup_dut(dut)
    dut._log.info("Test 4: hold when enable is low")

    dut.load_data.value = 0x3D
    dut.load_en.value = 1
    dut.en.value = 1
    await tick_and_settle(dut)
    dut.load_en.value = 0
    dut.en.value = 0
    await tick_and_settle(dut)
    assert count_int(dut) == 0x3D, f"Hold failed: expected 0x3D, got 0x{count_int(dut):02X}"

@cocotb.test()
async def test_count_down(dut):
    await setup_dut(dut)
    dut._log.info("Test 5: count down 0x3D -> 0x3C")

    dut.load_data.value = 0x3D
    dut.load_en.value = 1
    dut.en.value = 1
    await tick_and_settle(dut)
    dut.load_en.value = 0
    dut.count_dir.value = 0
    await tick_and_settle(dut)
    assert count_int(dut) == 0x3C, f"Count down failed: expected 0x3C, got 0x{count_int(dut):02X}"

@cocotb.test()
async def test_up_wraparound(dut):
    await setup_dut(dut)
    dut._log.info("Test 6: up wrap-around 0xFF -> 0x00")

    dut.load_en.value = 1
    dut.en.value = 1
    dut.load_data.value = 0xFF
    await tick_and_settle(dut)
    dut.load_en.value = 0
    dut.count_dir.value = 1
    await tick_and_settle(dut)
    assert count_int(dut) == 0x00, f"Up wrap failed: expected 0x00, got 0x{count_int(dut):02X}"

@cocotb.test()
async def test_down_wraparound(dut):
    await setup_dut(dut)
    dut._log.info("Test 7: down wrap-around 0x00 -> 0xFF")

    dut.load_en.value = 1
    dut.en.value = 1
    dut.load_data.value = 0x00
    await tick_and_settle(dut)
    dut.load_en.value = 0
    dut.count_dir.value = 0
    await tick_and_settle(dut)
    assert count_int(dut) == 0xFF, f"Down wrap failed: expected 0xFF, got 0x{count_int(dut):02X}"



