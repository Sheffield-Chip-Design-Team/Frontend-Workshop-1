// 8-bit up/down binary counter with async reset and parallel load

module up_down_counter (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        en,
    input  logic        load_en,
    input  logic        count_dir, // 1 for up, 0 for down
    input  logic [7:0]  load_data,
    output logic [7:0]  count_val
);

  // Sequential logic for counter
  always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      count_val <= 8'b0;
    end else if (load_en) begin
      count_val <= load_data;
    end else if (load_en) begin
      if (count_dir) begin
        count_val <= count_val + 8'd1;
      end else begin
        count_val <= count_val - 8'd1;
      end
    end
  end

endmodule

