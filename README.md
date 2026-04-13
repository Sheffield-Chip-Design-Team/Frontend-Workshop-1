# Hardware Design Workshop

This repository contains materials for a simple digital design workshop.

The first design exercise is an 8-bit up/down binary counter written in SystemVerilog.

## Who this is for
- Complete beginners in hardware design
- Students learning RTL, simulation, and waveform-based debugging

## Workshop learning goals
- Understand synchronous design around a clock edge
- Learn reset, enable, load, and direction control behavior
- Understand how a simple simulation testbench validates RTL behavior
- Connect RTL behavior with waveform observations

## Quick file map
- RTL design: `hw/rtl/updownCounter.sv`
- Testbench: `hw/tb/updownCounter_tb.sv`
- Counter spec (beginner version): `docs/updownCounter_spec.md`
- Test documentation: `docs/updownCounter_test_plan.md`

## Recommended workshop flow
1. Read the counter specification in `docs/updownCounter_spec.md`.
2. Open and review `hw/rtl/updownCounter.sv`.
3. Read `docs/updownCounter_test_plan.md`.
4. Run the test flow and inspect waveforms.
5. Modify behavior (for example width or reset style) and re-test.


