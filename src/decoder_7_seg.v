module decoder_7_seg(
	input CLK,
   input [3:0] D,
   output reg [7:0] SEG
   );
	
	//SEG <= 8'b11111111;
	 
always @(posedge CLK) 
begin
	case(D)
    4'd0: SEG <= 8'b10000001;
    4'd1: SEG <= 8'b11110011; 
    4'd2: SEG <= 8'b01001001;
    4'd3: SEG <= 8'b01100001;
    4'd4: SEG <= 8'b00110011;
    4'd5: SEG <= 8'b00100101;
    4'd6: SEG <= 8'b00000101;
    4'd7: SEG <= 8'b11110001;
    4'd8: SEG <= 8'b00000001;
    4'd9: SEG <= 8'b00100001;
	 4'hA: SEG <= 8'b00010001;
	 4'hB: SEG <= 8'b00000111;
	 4'hC: SEG <= 8'b10001101;
	 4'hD: SEG <= 8'b01000011;
	 4'hE: SEG <= 8'b00001101;
	 4'hF: SEG <= 8'b00011101;
    default: SEG <= 8'b11111111;
	endcase
end

endmodule
