`timescale 1ns / 1ps

module up_down_counter_tb;
  logic       clk;
  logic       rst_n;
  logic       en;
  logic       load_en;
  logic       count_dir;
  logic [7:0] load_data;
  logic [7:0] count_val;

  up_down_counter dut (
      .clk        (clk),
      .rst_n      (rst_n),
      .en         (en),
      .load_en    (load_en),
      .count_dir  (count_dir),
      .load_data  (load_data),
      .count_val  (count_val)
  );

  // 100 MHz clock: period = 10 ns
  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    $display("Starting Tests...");
    $dumpfile("up_down_counter_sv.vcd");
    $dumpvars(0, up_down_counter_tb);

    // Initial values
    rst_n  = 1'b1;
    en = 1'b0;
    load_en   = 1'b0;
    count_dir = 1'b1;
    load_data   = 8'h00;

    // Test 1: asynchronous reset
    $display("Test 1: Testing asynchronous reset - counter should reset to 0x00");
    #2;
    rst_n = 1'b0;
    #1;
    if (count_val !== 8'h00) $error("Reset failed: expected 0x00, got %0h", count_val);
    else $display("  PASS: Counter reset to 0x00");
    #7;
    rst_n = 1'b1;

    // Test 2: load priority over enable
    $display("Test 2: Testing load functionality - counter should load value 0x3C");
    @(posedge clk);
    load_data   = 8'h3C;
    load_en   = 1'b1;
    en = 1'b1;
    count_dir = 1'b1;

    @(posedge clk);
    if (count_val !== 8'h3C) $error("Load failed: expected 0x3C, got %0h", count_val);
    else $display("  PASS: Counter loaded with 0x3C");
    load_en = 1'b0;

    // Test 3: count up
    $display("Test 3: Testing count up - counter should increment from 0x3C to 0x3D");
    @(posedge clk);
    if (count_val !== 8'h3D) $error("Count up failed: expected 0x3D, got %0h", count_val);
    else $display("  PASS: Counter incremented to 0x3D");

    // Test 4: hold when enable is low
    $display("Test 4: Testing hold functionality - counter should hold at 0x3D when enable is low");
    en = 1'b0;
    @(posedge clk);
    if (count_val !== 8'h3D) $error("Hold failed: expected 0x3D, got %0h", count_val);
    else $display("  PASS: Counter held at 0x3D");

    // Test 5: count down
    $display("Test 5: Testing count down - counter should decrement from 0x3D to 0x3C");
    en = 1'b1;
    count_dir = 1'b0;
    @(posedge clk);
    if (count_val !== 8'h3C) $error("Count down failed: expected 0x3C, got %0h", count_val);
    else $display("  PASS: Counter decremented to 0x3C");

    // Test 6: up wrap-around (FF -> 00)
    $display("Test 6: Testing count up wrap-around - counter at 0xFF should wrap to 0x00");
    load_en = 1'b1;
    load_data = 8'hFF;
    @(posedge clk);
    load_en   = 1'b0;
    count_dir = 1'b1;
    @(posedge clk);
    if (count_val !== 8'h00) $error("Up wrap failed: expected 0x00, got %0h", count_val);
    else $display("  PASS: Counter wrapped from 0xFF to 0x00");

    // Test 7: down wrap-around (00 -> FF)
    $display("Test 7: Testing count down wrap-around - counter at 0x00 should wrap to 0xFF");
    count_dir = 1'b0;
    @(posedge clk);
    if (count_val !== 8'hFF) $error("Down wrap failed: expected 0xFF, got %0h", count_val);
    else $display("  PASS: Counter wrapped from 0x00 to 0xFF");

    $display("\nTestbench completed.");
    #10;
    $finish;
  end
endmodule
