// 32X32 Multiplier test template
module mult32x32_fast_tb;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

    // Put your code here
	// ------------------
	mult32x32_fast IAMSPEED (
							.a(a),
							.b(b),
							.start(start),
							.product(product),
							.busy(busy),
							.clk(clk),
							.reset(reset)
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
	start = 1;
	a = 318472131;
	b = 211434196;
	
	#10
	start = 0;
	
	#60
	start = 1;
	a = 32'b00000000000000000111111111000011;
	b = 32'b00000000000000000011101011010100;
	
	#10
	start = 0;
	end
	// End of your code

endmodule
