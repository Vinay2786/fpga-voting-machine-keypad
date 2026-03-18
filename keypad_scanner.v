module keypad_scanner (
 input clk,
 input rst_n,
 input [3:0] row, // row inputs from keypad
 output reg [3:0] col, // column outputs to keypad
 output reg [3:0] key_value,
 output reg key_valid
);
 reg [19:0] debounce_counter;
 reg [3:0] last_key;
 reg [3:0] key_pressed;
 reg [1:0] col_index;
 wire [3:0] row_in = row | 4'b1111;
 always @(posedge clk or negedge rst_n) begin
 if (!rst_n) begin
 col <= 4'b1110;
 col_index <= 0;
 key_valid <= 0;
 key_value <= 0;
 debounce_counter <= 0;
 last_key <= 0;
 end else begin
 debounce_counter <= debounce_counter + 1;
 if (debounce_counter == 50000) begin
 debounce_counter <= 0;
 col_index <= col_index + 1;
 case (col_index)
 2'd0: col <= 4'b1110;
 2'd1: col <= 4'b1101;
 2'd2: col <= 4'b1011;
 2'd3: col <= 4'b0111;
 endcase
 end
 key_valid <= 0;
 case (col)
 4'b1110: key_pressed = row_in[0] ? 0 : 4'd1;
 4'b1101: key_pressed = row_in[0] ? 0 : 4'd2;
 4'b1011: key_pressed = row_in[0] ? 0 : 4'd3;
 4'b0111: key_pressed = row_in[0] ? 0 : 4'd10; // A
 default: key_pressed = 0;
 endcase
 if (key_pressed != 0 && key_pressed != last_key) begin
 key_value <= key_pressed;
 key_valid <= 1;
 last_key <= key_pressed;
 end else if (key_pressed == 0) begin
 last_key <= 0;
 end
 end
 end
endmodule
