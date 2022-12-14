// 32X32 Iterative Multiplier template
module mult32x32_fast (
    input logic clk,            // Clock
    input logic reset,          // Reset
    input logic start,          // Start signal
    input logic [31:0] a,       // Input a
    input logic [31:0] b,       // Input b
    output logic busy,          // Multiplier busy indication
    output logic [63:0] product // Miltiplication product
);

    // Put your code here
	// ------------------
	logic a_sel;
	logic b_sel;
	logic [1:0]shift;
	logic upd_prod;
	logic clr_prod;
	logic a_msw_is_0;
	logic b_msw_is_0;
	
	mult32x32_fast_arith FAST_AR(
								.clk(clk),
								.reset(reset),
								.a(a),
								.b(b),
								.a_sel(a_sel),
								.b_sel(b_sel),
								.shift_sel(shift),
								.upd_prod(upd_prod),
								.clr_prod(clr_prod),
								.a_msw_is_0(a_msw_is_0),
								.b_msw_is_0(b_msw_is_0),
								.product(product)
								);
	
	mult32x32_fast_fsm FAST_FSM(
								.clk(clk),
								.reset(reset),
								.start(start),
								.a_msw_is_0(a_msw_is_0),
								.b_msw_is_0(b_msw_is_0),
								.busy(busy),
								.a_sel(a_sel),
								.b_sel(b_sel),
								.shift_sel(shift),
								.upd_prod(upd_prod),
								.clr_prod(clr_prod)
								);
	// End of your code

endmodule
