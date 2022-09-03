//Luqmaan Irshad 217222365 luq21
//EECS 3216 Z Lab 5
module Lab5(input sys_clk, input [5:0] num, input [1:0] op, input do_op, input reset, output [6:0] HEX1, output [6:0] HEX0);

//Push: 10
//Pop:  01

//Top and bottom of stack
int top = 0;
int bottom = 0;

//Stack stored in a 2D array
reg [5:0] stack[0:15]; 

//current value held by switches
reg [5:0] current = 6'b0;

reg stale = 1'b0;
reg [22:0] count = 23'd0;
parameter D = 5000000;

//10s Column Digits
assign HEX1[0] = ((current >= 6'd10 && current < 6'd20) || (current >= 6'd40 && current < 6'd50));
assign HEX1[1] = (current >= 6'd50);
assign HEX1[2] = (current >= 6'd20 && current < 6'd30);
assign HEX1[3] = ((current >= 6'd10 && current < 6'd20) || (current >= 6'd40 && current < 6'd50));
assign HEX1[4] = ((current >= 6'd10 && current < 6'd20) || (current >= 6'd30 && current < 6'd60));
assign HEX1[5] = (current >= 6'd10 && current < 6'd40);
assign HEX1[6] = (current >= 6'd0 && current < 6'd20);

//1s Column Digits
assign HEX0[0] = (current % 6'd10 == 1 || current % 6'd10 == 4);
assign HEX0[1] = (current % 6'd10 == 5 || current % 6'd10 == 6);
assign HEX0[2] = (current % 6'd10 == 2);
assign HEX0[3] = (current % 6'd10 == 1 || current % 6'd10 == 4 || current % 6'd10 == 7);
assign HEX0[4] = ~(current % 6'd10 == 0 || current % 6'd10 == 2 || current % 6'd10 == 6 || current % 6'd10 == 8);
assign HEX0[5] = (current % 6'd10 == 1 || current % 6'd10 == 2 || current % 6'd10 == 3 || current % 6'd10 == 7);
assign HEX0[6] = (current % 6'd10 == 0 || current % 6'd10 == 1 || current % 6'd10 == 7);

always @ (posedge sys_clk) begin

	if (!reset) begin
	
		//Reset Stack
		for (int i = 0; i < 6; i++) begin
			for (int j = 0; j < 16; j++) begin
				stack[i][j] <= 6'b0;
			end
		end
		
		//Reset Display
		current <= 0;
		
		//Reset top level
		top <= 0;
		
		//Reset stale and stale counter
		stale <= 0;
		count <= 0;
	end
	
	else if (stale) begin
		if (count == D) begin
			stale <= 0;
			count <= 0;
		end
		
		else begin
			count <= count + 1;
		end
	end
	
	else if (!do_op && !stale) begin
		
		stale <= 1;
	
		//Check if Push or Pop
		//Read the current 6 bit #
		//Execute
	
		//Push: 10
		if (op[1] == 1'b1 && op[0] == 1'b0 && top < 15) begin
			
			//Push current value to stack
			stack[5][top] <= num[5];
			stack[4][top] <= num[4];
			stack[3][top] <= num[3];
			stack[2][top] <= num[2];
			stack[1][top] <= num[1];
			stack[0][top] <= num[0];
			
			//Update display
			current <= (32 * num[5]) + (16 * num[4]) + (8 * num[3]) + (4 * num[2]) + (2 * num[1]) + (1 * num[0]);
			top = top + 1;
		end
		
		//Pop: 01
		else if (op[1] == 1'b0 && op[0] == 1'b1) begin
		
			if (top > 0) begin
				top = top - 1;
			end
			
			//Reset values in the register
			stack[5][top] <= 0;
			stack[4][top] <= 0;
			stack[3][top] <= 0;
			stack[2][top] <= 0;
			stack[1][top] <= 0;
			stack[0][top] <= 0;
			
			
			//Update display
			current <= (32 * stack[5][top]) + (16 * stack[4][top]) + (8 * stack[3][top]) + (4 * stack[2][top]) + (2 * stack[1][top]) + (1 * stack[0][top]);
		end
	end

end

endmodule