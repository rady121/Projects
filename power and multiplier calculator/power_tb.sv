// testbench for the power module
module power_tb;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [3:0] a;        // Input a
    logic [2:0] b;        // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] result;  // Miltiplication product


	// Put your code here
	// ------------------
	power POWERFULOMG (
						.clk(clk),
						.reset(reset),
						.start(start),
						.a(a),
						.b(b),
						.busy(busy),
						.result(result)
						);
	
	always begin 
		#5
		clk = ~clk;
	end
	
	
	initial begin
	clk = 1;
	reset = 1;
	start = 0;
	a = 0;
	b = 0;
	
	#40
	reset = 0;
	
	#10
	a = 5;
	b = 4;
	start = 1;
	
	#10
	start = 0;
	
	#300
	start = 1;
	a = 11;
	b = 5;
	
	#10
	start = 0;
	end
	
	// End of your code
endmodule
