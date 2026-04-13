`timescale 1ns / 1ps

module updownCounter_tb;
  logic Clock;
  logic Reset;
  logic Enable;
  logic Load;
  logic Up1Dn0;
  logic [7:0] Data;
  logic [7:0] Q;

  updownCounter dut (
      .Clock(Clock),
      .Reset(Reset),
      .Enable(Enable),
      .LoadEn(Load),
      .Up1Dn0(Up1Dn0),
      .LoadData(Data),
      .Q(Q)
  );

  // 100 MHz clock: period = 10 ns
  initial Clock = 1'b0;
  always #5 Clock = ~Clock;

  initial begin
    $display("Starting updownCounter_tb...");
    $dumpfile("updownCounter_tb.vcd");
    $dumpvars(0, updownCounter_tb);

    // Initial values
    Reset  = 1'b0;
    Enable = 1'b0;
    Load   = 1'b0;
    Up1Dn0 = 1'b1;
    Data   = 8'h00;

    // Test 1: asynchronous reset
    #2;
    Reset = 1'b1;
    #1;
    if (Q !== 8'h00) $error("Reset failed: expected 0x00, got %0h", Q);
    #7;
    Reset = 1'b0;

    // Test 2: load priority over enable
    @(posedge Clock);
    Data   = 8'h3C;
    Load   = 1'b1;
    Enable = 1'b1;
    Up1Dn0 = 1'b1;

    @(posedge Clock);
    if (Q !== 8'h3C) $error("Load failed: expected 0x3C, got %0h", Q);
    Load = 1'b0;

    // Test 3: count up
    @(posedge Clock);
    if (Q !== 8'h3D) $error("Count up failed: expected 0x3D, got %0h", Q);

    // Test 4: hold when enable is low
    Enable = 1'b0;
    @(posedge Clock);
    if (Q !== 8'h3D) $error("Hold failed: expected 0x3D, got %0h", Q);

    // Test 5: count down
    Enable = 1'b1;
    Up1Dn0 = 1'b0;
    @(posedge Clock);
    if (Q !== 8'h3C) $error("Count down failed: expected 0x3C, got %0h", Q);

    // Test 6: up wrap-around (FF -> 00)
    Load = 1'b1;
    Data = 8'hFF;
    @(posedge Clock);
    Load   = 1'b0;
    Up1Dn0 = 1'b1;
    @(posedge Clock);
    if (Q !== 8'h00) $error("Up wrap failed: expected 0x00, got %0h", Q);

    // Test 7: down wrap-around (00 -> FF)
    Up1Dn0 = 1'b0;
    @(posedge Clock);
    if (Q !== 8'hFF) $error("Down wrap failed: expected 0xFF, got %0h", Q);

    $display("Testbench completed.");
    #10;
    $finish;
  end
endmodule
