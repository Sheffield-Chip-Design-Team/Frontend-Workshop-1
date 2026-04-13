// Auto-generated Verilog Testbench Wrapper - Coraltb 
 
`timescale 1ns/1ns 

module up_down_counter_wtb;
  // up_down_counter instantation signals
  reg        clk;
  reg        rst_n;
  reg        en;
  reg        load_en;
  reg        count_dir;
  reg  [7:0] load_data;
  wire [7:0] count_val;

  up_down_counter dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .en         (en),
    .load_en    (load_en),
    .count_dir  (count_dir),
    .load_data  (load_data),
    .count_val  (count_val)
  );

endmodule 
 