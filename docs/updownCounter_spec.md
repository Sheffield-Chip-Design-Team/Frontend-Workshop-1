# updownCounter Specification (Beginner Friendly)

## 1. What this block does
`updownCounter` is an 8-bit binary counter.

Think of it like a number register that can:
- reset to zero,
- load a value directly,
- count up,
- count down,
- or hold its current value.

The output value is `Q[7:0]`.

## 2. Module interface
```systemverilog
module updownCounter (
    input  logic       Clock,
    input  logic       Reset,
    input  logic       Enable,
    input  logic       Load,
    input  logic       Up1Dn0,
    input  logic [7:0] Data,
    output logic [7:0] Q
);
```

## 3. Meaning of each signal
- `Clock`: The design updates on the rising edge of the clock.
- `Reset`: Active-high asynchronous reset. When `Reset=1`, output goes to `0` immediately.
- `Enable`: If `1`, counting is allowed. If `0`, counter holds value (unless `Load=1`).
- `Load`: If `1` at clock edge, counter loads `Data`.
- `Up1Dn0`: Direction select when counting.
  - `1` means count up (`+1`)
  - `0` means count down (`-1`)
- `Data`: The 8-bit value used during load.
- `Q`: Current counter value.

## 4. Control priority (important)
If multiple controls are active, this is the priority order:
1. `Reset` (highest priority, asynchronous)
2. `Load`
3. `Enable` with `Up1Dn0` direction
4. Hold value

So for example: if `Load=1` and `Enable=1` together, load wins.

## 5. Behavior on each clock edge
When `Reset=0`, at each rising edge of `Clock`:
- If `Load=1`, `Q <= Data`
- Else if `Enable=1` and `Up1Dn0=1`, `Q <= Q + 1`
- Else if `Enable=1` and `Up1Dn0=0`, `Q <= Q - 1`
- Else `Q` stays the same

## 6. Wrap-around behavior
`Q` is 8 bits, so values wrap naturally:
- `8'hFF + 1 = 8'h00`
- `8'h00 - 1 = 8'hFF`

This is normal binary counter behavior with modulo-$2^8$ arithmetic.

## 7. Beginner example sequence
Start with reset active, then release reset:

1. `Reset=1` -> `Q=0`
2. `Reset=0, Load=1, Data=8'h3C` -> next clock: `Q=3C`
3. `Load=0, Enable=1, Up1Dn0=1` -> next clock: `Q=3D`
4. `Enable=1, Up1Dn0=0` -> next clock: `Q=3C`
5. `Enable=0` -> next clock: `Q` stays `3C`

## 8. Design assumptions for workshop
- All control signals are driven from the same clock domain.
- Reset deassertion should follow your lab/reset guidelines.
- No saturation logic is used; only wrap-around behavior.
