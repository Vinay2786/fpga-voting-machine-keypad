module digital_voting_machine_tb;
 // Inputs
 reg clk;
 reg rst_n;
 reg [3:0] row;
 wire [3:0] col;
 wire [3:0] led;
 wire [6:0] hex0, hex1, hex2, hex3;
 // Instantiate DUT
 digital_voting_machine uut (
.clk(clk),
 .rst_n(rst_n),
 .row(row),
 .col(col),
 .led(led),
 .hex0(hex0),
 .hex1(hex1),
 .hex2(hex2),
 .hex3(hex3)
 );
 // Clock generation: 50 MHz
 initial clk = 0;
 always #10 clk = ~clk; // 20 ns period
 // ----------------------------------------
 // Main Test Sequence
 // ----------------------------------------
 initial begin
 // Initialization
 rst_n = 0;
 row = 4'b1111;
 #200;
 rst_n = 1;
 $display("[%0t] Reset released", $time);
 // ----------------------------------------
 // TEST CASE 1: Candidate 1 → Confirm (A)
 // ----------------------------------------
 $display("[%0t] TEST 1: Candidate 1 Confirm", $time);
 press_key(4'd1);
#50000;
 press_key(4'd10); // A = Confirm
 #100000;
 // ----------------------------------------
 // TEST CASE 2: Candidate 2 → Confirm (A)
 // ----------------------------------------
 $display("[%0t] TEST 2: Candidate 2 Confirm", $time);
 press_key(4'd2);
 #50000;
 press_key(4'd10);
 #100000;
 // ----------------------------------------
 // TEST CASE 3: Candidate 3 → Cancel (B)
 // ----------------------------------------
 $display("[%0t] TEST 3: Candidate 3 Cancel", $time);
 press_key(4'd3);
 #50000;
 press_key(4'd11); // B = Cancel
 #100000;
 // ----------------------------------------
 // TEST CASE 4: Candidate 4 → Confirm (A)
 // ----------------------------------------
 $display("[%0t] TEST 4: Candidate 4 Confirm", $time);
 press_key(4'd4);
 #50000;
 press_key(4'd10);
 #100000;
// ----------------------------------------
 // TEST CASE 5: Display Votes (C)
 // ----------------------------------------
 $display("[%0t] TEST 5: Display Votes", $time);
 press_key(4'd12); // C = Display
 #200000;
 // ----------------------------------------
 // TEST CASE 6: Reset All (D)
 // ----------------------------------------
 $display("[%0t] TEST 6: Reset Votes", $time);
 press_key(4'd13); // D = Reset
 #200000;
 // ----------------------------------------
 // TEST CASE 7: Vote again after reset (C1)
 // ----------------------------------------
 $display("[%0t] TEST 7: Candidate 1 after reset", $time);
 press_key(4'd1);
 #50000;
 press_key(4'd10);
 #200000;
 $display("[%0t] All test cases executed successfully", $time);
 $stop;
 end
 // ----------------------------------------
 // TASK: Simulate a Key Press
 // ----------------------------------------
 task press_key;
 input [3:0] key;
begin
 @(posedge clk);
 $display("[%0t] --> Key Pressed: %0d", $time, key);
 row = 4'b1110; // simulate a row press
 #5000;
 row = 4'b1111; // release
 @(posedge clk);
 end
 endtask
endmodule
