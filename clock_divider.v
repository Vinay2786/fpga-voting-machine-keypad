//=====================================================
// Module: Clock Divider
// Purpose: Generate slower clock from 50 MHz FPGA clock
//=====================================================
module clock_divider #(
 parameter DIVISOR = 50 // For simulation, set small (50); for hardware use 25_000_000
)(
 input clk,
 input rst_n,
 output reg slow_clk
);
 reg [31:0] counter;
 always @(posedge clk or negedge rst_n) begin
 if (!rst_n) begin
 counter <= 0;
 slow_clk <= 0;
 end else begin
 if (counter == DIVISOR - 1) begin
 counter <= 0;
 slow_clk <= ~slow_clk; // toggle slow clock
 end else begin
 counter <= counter + 1;
 end
 end
 end
endmodule
