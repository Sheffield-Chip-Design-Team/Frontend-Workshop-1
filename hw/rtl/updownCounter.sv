// 8-bit up/down binary counter with async reset and parallel load
`timescale 1ns / 1ps

module updownCounter (
    input logic Clock,
    Reset,
    Enable,
    LoadEn,
    Up1Dn0,
    input logic [7:0] LoadData,
    output logic [7:0] Q
);
  always_ff @(posedge Clock or posedge Reset) begin
    if (Reset) begin
      Q <= 8'b0;
    end else if (LoadEn) begin
      Q <= LoadData;
    end else if (Enable) begin
      if (Up1Dn0) begin
        Q <= Q + 8'd1;
      end else begin
        Q <= Q - 8'd1;
      end
    end
  end
endmodule

