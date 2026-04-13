# updownCounter Test Guide (Beginner Friendly)

## 1. Why we test
For beginners, the goal of testing is simple:
- confirm the RTL matches the specification,
- observe behavior in waveforms,
- build confidence before changing the design.

## 2. Files used
- RTL: `hw/rtl/updownCounter.sv`
- Testbench: `hw/tb/updownCounter_tb.sv`

## 3. What is being verified
The provided testbench checks:
1. Asynchronous reset drives `Q` to `8'h00` immediately.
2. Load operation works and has higher priority than count enable.
3. Count up increments by 1.
4. Hold behavior keeps `Q` unchanged when `Enable=0`.
5. Count down decrements by 1.
6. Up overflow wraps `8'hFF -> 8'h00`.
7. Down underflow wraps `8'h00 -> 8'hFF`.

## 4. Running the testbench
Run the workshop simulation script.

Expected result:
- no `$error` messages,
- testbench prints start and completion messages,
- waveform data is available for inspection.

## 5. Viewing waveforms
Open the waveform output produced by the workshop flow.

Recommended signals to display:
- `Clock`
- `Reset`
- `Enable`
- `Load`
- `Up1Dn0`
- `Data[7:0]`
- `Q[7:0]`

## 6. Waveform checkpoints
Use these checkpoints while stepping through time:
1. During reset pulse, `Q` should be zero without waiting for a clock edge.
2. With `Load=1`, `Q` should become `Data` at the next rising edge.
3. With `Enable=1`, `Up1Dn0=1`, value should increase by exactly 1 per edge.
4. With `Enable=0`, `Q` should stay constant.
5. With `Enable=1`, `Up1Dn0=0`, value should decrease by exactly 1 per edge.
6. At `Q=FF`, next up-count edge should produce `00`.
7. At `Q=00`, next down-count edge should produce `FF`.

## 7. Common beginner mistakes
- Forgetting that `Load` has priority over counting.
- Expecting reset to wait for clock (it is asynchronous here).
- Changing control signals too close to a clock edge and getting confusing results.
- Confusing hexadecimal and decimal values in waveforms.

## 8. Suggested exercises
1. Change counter width from 8 bits to 4 bits and update expected wrap points.
2. Add one more directed test: two consecutive load operations.
3. Convert this to a synchronous reset version and compare waveforms.
