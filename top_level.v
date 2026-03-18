//=====================================================
// Module: Digital Voting Machine with LED Blink Control
//=====================================================
module digital_voting_machine(
 input clk,
 input rst_n,
 input [3:0] row, // keypad row inputs
 output [3:0] col, // keypad column outputs
 output reg [3:0] led, // LEDs for candidates
 output [6:0] hex0, // votes for candidate 1
 output [6:0] hex1, // votes for candidate 2
 output [6:0] hex2, // votes for candidate 3
 output [6:0] hex3 // votes for candidate 4
 );
 // --- Internal signals ---
 reg [3:0] selected_candidate;
 reg [7:0] votes [3:0];
 reg led_state;
 reg blink_en;
 wire slow_clk;
 wire [3:0] key_value;
 wire key_valid;
 // --- Instantiate modules ---
 clock_divider #(50) cd (.clk(clk), .rst_n(rst_n), .slow_clk(slow_clk)); // For simulation,
DIVISOR=50
 keypad_scanner ks (.clk(clk), .rst_n(rst_n), .row(row), .col(col), .key_value(key_value),
.key_valid(key_valid));
 // --- Voting logic ---
 always @(posedge clk or negedge rst_n) begin
 if(!rst_n) begin
 selected_candidate <= 0;
 votes[0] <= 0; votes[1] <= 0; votes[2] <= 0; votes[3] <= 0;
 blink_en <= 0;
 end else if(key_valid) begin
 case(key_value)
 4'd1: selected_candidate <= 1;
 4'd2: selected_candidate <= 2;
 4'd3: selected_candidate <= 3;
 4'd4: selected_candidate <= 4;
 4'd10: begin // A - Confirm
 if(selected_candidate != 0) begin
 votes[selected_candidate-1] <= votes[selected_candidate-1] + 1;
   blink_en <= 1;
 end
 end
 4'd11: blink_en <= 0; // B - Cancel
 4'd12: blink_en <= 0; // C - Display
 4'd13: begin // D - Reset
 votes[0] <= 0; votes[1] <= 0; votes[2] <= 0; votes[3] <= 0;
 selected_candidate <= 0;
 blink_en <= 0;
 end
 endcase
 end
 end
 // --- LED Blink Logic using slow clock ---
 always @(posedge slow_clk or negedge rst_n) begin
 if(!rst_n) begin
 led_state <= 0;
 led <= 4'b0000;
 end else if(blink_en) begin
 led_state <= ~led_state;
 led <= 4'b0000;
 case(selected_candidate)
 1: led[0] = led_state;
 2: led[1] = led_state;
   3: led[2] = led_state;
 4: led[3] = led_state;
 endcase
 end else begin
 led <= 4'b0000;
 end
 end
 // --- Seven Segment Display (Vote Count) ---
 seven_seg_decoder ssd0(.bin(votes[0] % 10), .seg(hex0));
 seven_seg_decoder ssd1(.bin(votes[1] % 10), .seg(hex1));
 seven_seg_decoder ssd2(.bin(votes[2] % 10), .seg(hex2));
 seven_seg_decoder ssd3(.bin(votes[3] % 10), .seg(hex3));
endmodule

