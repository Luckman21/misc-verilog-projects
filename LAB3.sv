//Luqmaan Irshad 217222365 luq21
//EECS 3216 Z Lab 3

module LAB3(input sys_clk, input reset, input [1:0] SW, output [2:0] lSignal, output [2:0] rSignal, output [3:0] back, output [6:0] Error);

reg [2:0] left = 3'b111;
reg [2:0] right = 3'b111;
wire clk;
int countL = 0;
int countR = 0;

//Instantiate Clock using ClockDivider
ClockDivider clock(sys_clk, clk);

always @ (posedge clk) begin

	//State 0	All OFF / Error
	if ((~SW[0] && ~SW[1]) || (SW[0] && SW[1]) || reset) begin
		left <= 3'b111;
		right <= 3'b111;
		countL <= 0;
		countR <= 0;
	end
	
	//State 1	Left Turn
	else if (SW[0] && ~SW[1] && countL < 3) begin
		
		//We can reset the right turn count since it must be off if in this state
		countR <= 0;
		
		//Once all 3 LEDs are on, reset
		
		if (left == 3'b0 && countL < 2) begin
			left <= 3'b111;
			countL <= countL + 1;
		end
		
		else begin
			left <= left << 1;
		end
		
	end
	
	//State 2	Right Turn
	else if (~SW[0] && SW[1] && countR < 3) begin
		
		//We can reset the left turn count since it must be off if in this state
		countL <= 0;
		
		//Once all 3 LEDs are on, reset
		
		if (right == 3'b0 && countR < 2) begin
			right <= 3'b111;
			countR <= countR + 1;
		end
		
		else begin
			right <= right << 1;
		end
		
	end

end

//Turn Signal Assignment
assign lSignal[2:0] = ~left;
assign rSignal [2:0] = ~right;

//Error Signal
//1 is OFF and 0 is ON for 7SD, so we inverse the input signals
assign Error[0] = ~(SW[0] && SW[1]);
assign Error[1] = 1;
assign Error[2] = 1;
assign Error[3] = ~(SW[0] && SW[1]);
assign Error[4] = ~(SW[0] && SW[1]);
assign Error[5] = ~(SW[0] && SW[1]);
assign Error[6] = ~(SW[0] && SW[1]);

//Keep the rest of the board LEDs OFF
assign back[3:0] = 0;

endmodule 