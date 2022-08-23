// Power Module
module power (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic[3:0] a,			  // Input 
    input logic[2:0] b,			  // Input 
    output logic busy,            // Power busy indication
    output logic[63:0] result     // Result
 );

	// This module is calculating Result = a^b.	
	
	// Local Variables. 
	// Counter for Number of mult operations left. 
	logic[4:0] counter;    
	// Signals for mult.
	logic mul_start, mul_busy; 
	// States for the FSM.
	logic [1:0] cur_state, next_state;
	// Inputs for the mult.
	logic[31:0] tmp_input, b_input;
	// Registers for the mult output.
	logic[63:0] tmp_res, reg_res; 
	
	// We want to assign the leg b of the mult 
	// the input a as constant via b_input.
	// Put your code here.
	// ------------------
							
	logic done;
	logic [31:0]mux1;
	logic mux1_sel;
	logic [31:0]mux2;
	logic mux2_sel;
	logic upd_res;
	logic upd_cnt;
	logic init;
	logic [31:0]a_new;
	
	assign a_new = {{28{0}} , a};
	
	always_ff @(posedge clk, posedge reset) begin
		if (reset == 1'b1) begin
			cur_state <= 2'b00;
		end
		else begin
			cur_state <= next_state;
		end
	end
	
	always_ff @(posedge clk, posedge reset) begin
		if (reset == 1'b1 || start == 1'b1) begin
			counter <= 4'd0;
		end
		else if (counter < b+1) begin
			if ( upd_cnt == 1'b1) begin
				counter <= counter+1;
			end
		end
	end
	
	always_comb begin
		if (counter == b+1) begin
			done = 1'b1;
		end
		else begin
			done = 1'b0;
		end
	end
	
	always_comb begin
		case (mux1_sel)
			1'b0 : mux1 = {{28{0}}, a};
			1'b1 : mux1 = reg_res[31:0];
		endcase
		
		case (mux2_sel)
			1'b0 : mux2 = {{28{0}} , a};
			1'b1 : mux2 = reg_res[31:0];
		endcase
	end
	
	assign result = {{32{0}} , mux2};
	// End of your code.

	//Next, Declare the mult module we are going to use. 
	mult32x32_fast IAMSPEED (
							.clk(clk),
							.reset(reset),
							.start(mul_start),
							.a(a_new),
							.b(mux1),
							.busy(mul_busy),
							.product(tmp_res)
							);

    // Initiating FFs Complete: 
    always_ff @(posedge clk, posedge reset) begin
        if ( reset == 1'b1 ) begin
			reg_res <= 0;
        end
        else if(upd_res == 1) begin
			reg_res <= tmp_res;
        end
    end

    // Manage FSM Logic.
	// We are going to use an FSM in order to manage 
	// the multiplications. 
    always_comb begin
		mux1_sel = 1'b0;
		mux2_sel = 1'b0;
		//next_state = 2'b00;
		busy = 1'b0;
		mul_start = 1'b0;
		upd_res = 1'b0;
		upd_cnt = 1'b0;
		//init = 1'b0;
        // Default Values - Complete.
        case (cur_state) 
            2'b00 : begin
                // Idle state - Waiting on 'start' signal.
				if (start == 1'b1) begin
					mux1_sel = 1'b0;
					mux2_sel = 1'b0;
					next_state = 2'b01;
					busy = 1'b1;
					mul_start = 1'b1;
					upd_res = 1'b0;
					upd_cnt = 1'b0;
					init = 1'b0;
				end
				else begin
					mux1_sel = 1'b0;
					if (b == 0) begin 
						mux2_sel = 1'b0;
					end
					else begin 
						mux2_sel = 1'b1;
					end
					next_state = 2'b00;
					busy = 1'b0;
					mul_start = 1'b0;
					upd_res = 1'b0;
					upd_cnt = 1'b0;
				end
            end
		
            2'b01 : begin
				if (b == 1'b0) begin
					next_state = 2'b00;
					mux2_sel = 1'b0;
				end
				else if ( (mul_busy == 1'b1) && (done == 1'b0) && (init == 1'b0) ) begin
					mux1_sel = 1'b0;
					mux2_sel = 1'b0;
					next_state = 2'b01;
					busy = 1'b1;
					mul_start = 1'b0;
					upd_res = 1'b0;
					upd_cnt = 1'b0;
				end
				else if ( (mul_busy == 1'b0) && (done == 1'b0) && (init == 1'b0) ) begin
					mux1_sel = 1'b0;
					mux2_sel = 1'b0;
					next_state = 2'b10;
					busy = 1'b1;
					mul_start = 1'b0;
					upd_res = 1'b0;
					upd_cnt = 1'b0;	
				end
				else if ( (mul_busy == 1'b0) && (done == 1'b0) && (init == 1'b1) ) begin
					mux1_sel = 1'b1;
					mux2_sel = 1'b1;
					next_state = 2'b10;
					busy = 1'b1;
					mul_start = 1'b0;
					upd_res = 1'b0;
					upd_cnt = 1'b0;	
					init = 1'b1;
				end
				else if ( (mul_busy == 1'b1) && (done == 1'b0) && (init = 1'b1) ) begin
					mux1_sel = 1'b1;
					mux2_sel = 1'b1;
					next_state = 2'b01;
					busy = 1'b1;
					mul_start = 1'b0;
					upd_res = 1'b0;
					upd_cnt = 1'b0;
					init = 1'b1;
				end
			end
			
            2'b10 : begin
				mux1_sel = 1'b1;
				mux2_sel = 1'b1;
				if (counter == b) begin
					next_state = 2'b00;
					mul_start = 1'b0;
					upd_res = 1'b0;
					busy = 1'b0;
				end
				else begin
					next_state = 2'b01;
					mul_start = 1'b1;
					upd_res = 1'b1;
					busy = 1'b1;
				end
				upd_cnt = 1'b1;
				init = 1'b1;
            end
        endcase
    end
endmodule