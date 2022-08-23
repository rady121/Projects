// 32X32 Multiplier arithmetic unit template
module mult32x32_fast_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic a_sel,           // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [1:0] shift_sel, // Shift value of 8-bit mult product
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic a_msw_is_0,     // Indicates MSB of operand A is 0
    output logic b_msw_is_0,     // Indicates MSW of operand B is 0
    output logic [63:0] product  // Miltiplication product
);
    // Put your code here
	// ------------------
	logic [15:0] mux1;
	logic [15:0] mux2;
	logic [31:0] multiplier;
	logic [63:0] shifter1;
	logic [63:0] shifter2;
	logic [63:0] shifter3;
	logic [63:0] mux3;
	logic [63:0] adder_res;
		
	always_ff @(posedge clk, posedge reset) begin
		if (clr_prod == 1 || reset == 1) begin
			product <= 0;
		end
		else if (upd_prod == 1) begin
			product <= adder_res;
		end
	end
	
	always_comb begin
		shifter1 = multiplier;
		shifter2 = multiplier << 16;
		shifter3 = multiplier << 32;
	end
	
	always_comb begin
		case (a_sel)
			1'b0 : mux1 = a[15:0];
			1'b1 : mux1 = a[31:16];
		endcase
		
		case (b_sel)
			1'b0 : mux2 = b[15:0];
			1'b1 : mux2 = b[31:16];
		endcase
		
		case (shift_sel)
			2'b00 : mux3 = shifter1;
			2'b01 : mux3 = shifter2;
			2'b10 : mux3 = shifter3;
			2'b11 : mux3 = 0;
		endcase
	end
	
	always_comb begin
		if (a[31:16] == 0) begin
			a_msw_is_0 = 1;
		end
		else begin
			a_msw_is_0 = 0;
		end
		
		if (b[31:16] == 0) begin
			b_msw_is_0 = 1;
		end
		else begin
			b_msw_is_0 = 0;
		end
		multiplier = mux1*mux2;
		adder_res = mux3 + product;
	end

	// End of your code

endmodule
