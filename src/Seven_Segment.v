`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:00:18 01/28/2019 
// Design Name: 
// Module Name:    Seven_Segment 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Seven_Segment(
    input CLK,
    input switch_up,
    input switch_clear,
	 input switch_stop,
    output [7:0] SEG,
    output [3:0] DIGIT,
	 output reg [23:0] io_led
    );

wire s_up, s_clear, s_stop;
reg [25:0] prescaler = 26'b0;
//reg count_down, stopped;

debouncer d1(.CLK (CLK), .switch_input (switch_up), .trans_dn (s_up));
debouncer d2(.CLK (CLK), .switch_input (switch_clear), .trans_dn (s_clear));
debouncer d3(.CLK (CLK), .switch_input (switch_stop), .trans_dn (s_stop));

reg [3:0] units, tens, hundreds, thousands;

display_7_seg display(.CLK (CLK), 
		.units (units), .tens (tens), .hundreds (hundreds), .thousands (thousands),
		.SEG (SEG), .DIGIT (DIGIT));
		
localparam STOPPED = 0, COUNT_UP = 1, COUNT_DOWN = 2;
reg [1:0] state = STOPPED; 
reg [1:0] last_state = COUNT_UP;

always @(posedge CLK)
begin

	if(s_up)
	begin
		if(state == COUNT_DOWN)
		begin
			state <= COUNT_UP;
		end

		else
		begin
			state <= COUNT_DOWN;
		end
	end

	if(s_clear)
	begin
		units <= 0;
		tens <= 0;
		hundreds <= 0;
		thousands <= 0;
		io_led <= 0;
		if(state != STOPPED)
		begin
			last_state <= state;
		end
		state <= STOPPED;
	end
	
	if(s_stop)
	begin
		if(state == STOPPED)
		begin
			state <= last_state;
		end
		else
		begin
			last_state <= state;
			state <= STOPPED;
		end
	end
  
	prescaler <= prescaler + 26'd1;
	
	if (prescaler == 26'd49999999) // 1 Hz
	begin
	prescaler <= 0;
		
	case (state)
		STOPPED : begin
		end
		
		COUNT_UP : begin
		count_up();
		end
		
		COUNT_DOWN : begin
		count_down();
		end
		
	endcase
	end
end


task count_up;
begin
	io_led <= io_led + 24'd1;
	units <= units + 4'd1;
	if (units == 4'h9) 
	begin
		units <= 0;
		tens <= tens + 4'd1;
		if (tens == 4'h9) 
		begin
			tens <= 0;
			hundreds <= hundreds + 4'd1;
			if (hundreds == 4'h9) 
			begin
				hundreds <= 0;
				thousands <= thousands + 4'd1;
				if (thousands == 4'h9) 
				begin
					thousands <= 0;
				end
			end
		end
	end
end
endtask

task count_down;
begin
	io_led <= io_led - 24'd1;
	units <= units - 4'd1;
	if (units == 4'h0) 
	begin
		units <= 9;
		tens <= tens - 4'd1;
		if (tens == 4'h0) 
		begin
			tens <= 9;
			hundreds <= hundreds - 4'd1;
			if (hundreds == 4'h0) 
			begin
				hundreds <= 9;
				thousands <= thousands - 4'd1;
				if (thousands == 4'h0) 
				begin
					thousands <= 9;
				end
			end
		end
	end
end
endtask

endmodule

