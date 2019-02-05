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
reg [23:0] prescaler;
reg direction, stopped;

debouncer d1(.CLK (CLK), .switch_input (switch_up), .trans_dn (s_up));
debouncer d2(.CLK (CLK), .switch_input (switch_clear), .trans_dn (s_clear));
debouncer d3(.CLK (CLK), .switch_input (switch_stop), .trans_dn (s_stop));

reg [3:0] units, tens, hundreds, thousands;

display_7_seg display(.CLK (CLK), 
		.units (units), .tens (tens), .hundreds (hundreds), .thousands (thousands),
		.SEG (SEG), .DIGIT (DIGIT));

always @(posedge CLK)
begin

	prescaler <= prescaler + 24'd1;

	if(s_up)
	begin
	direction = ~direction;
	end

	if(s_clear)
	begin
    units <= 0;
    tens <= 0;
    hundreds <= 0;
    thousands <= 0;
	 io_led <= 0;
	end
	
	if(s_stop)
	begin
		stopped = ~stopped;
	end
  
	
	if (prescaler == 24'd50000000) // 1 Hz
	begin
	prescaler <= 0;
		if(stopped)
			begin
			if(!direction)
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
			
			else
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
		end
	end
end

endmodule

