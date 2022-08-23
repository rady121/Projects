// 32X32 Multiplier FSM
module mult32x32_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    output logic busy,            // Multiplier busy indication
    output logic a_sel,           // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [1:0] shift_sel, // Select output from shifter
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

    // Put your code here
	// ------------------
	typedef enum {idle_st, B, C, D, E} sm_type;
	// Declaring signals for the next & current state
	sm_type current_state;
	sm_type next_state;
	
	always_ff @(posedge clk, posedge reset) begin
		if (reset == 1'b1) begin
			current_state <= idle_st;
		end
		else begin
			current_state <= next_state;
		end
	end

	always_comb begin 
		next_state = idle_st;
		busy = 0;
		a_sel = 0;
		b_sel = 0;
		shift_sel = 0;
		upd_prod = 0;
		clr_prod = 0;
		
		case (current_state)
		idle_st : begin
			if (start == 1'b1) begin
				busy = 0;
				a_sel = 0;
				b_sel = 0;
				shift_sel = 0;
				upd_prod = 0;
				clr_prod = 1;
				next_state = B;
				end
				else begin
				busy = 0;
				a_sel = 0;
				b_sel = 0;
				shift_sel = 0;
				upd_prod = 0;
				clr_prod = 0;
				next_state = idle_st;
				end
			end
		
		B : begin
			busy = 1;
			a_sel = 0;
			b_sel = 0;
			shift_sel = 0;
			upd_prod = 1;
			clr_prod = 0;
			next_state = C;
			end
			
		C : begin
			busy = 1;
			a_sel = 1;
			b_sel = 0;
			shift_sel = 1;
			upd_prod = 1;
			clr_prod = 0;
			next_state = D;
			end
		
		D : begin
			busy = 1;
			a_sel = 0;
			b_sel = 1;
			shift_sel = 1;
			upd_prod = 1;
			clr_prod = 0;
			next_state = E;
			end
		
		E : begin
			busy = 1;
			a_sel = 1;
			b_sel = 1;
			shift_sel = 2;
			upd_prod = 1;
			clr_prod = 0;
			next_state = idle_st;
			end
		endcase
	end		
	// End of your code

endmodule
