/*
Reset turns off all 8 LEDs

If SW0 = 1
	- Turn on one LED each second from left to right
	- If all 8 LEDs are on, reset this
	
If SW9 = 1
	- Turn on one LED each 2/n seconds (where n = time elapsed from the first LED in the sequence on)
	- If all 8 LEDs are on, reset this

If SW0 = SW9 = 0
	- Turn off all LEDs
*/

//Luqmaan Irshad 217222365 luq21
//EECS 3216 Lab 2

module Lab2(input MAX10_CLK1_50, input [1:0] SW, input r_in, output [7:0] LEDR);

	wire sys_clk, reset;
	reg [21:0] sys1 = 22'd0;
	reg [19:0] sys2 = 20'd0;
	
	ClockDivider(MAX10_CLK1_50, sys_clk);
	
	always @ (posedge sys_clk) begin
	
		if (reset == 1 || r_in == 1) begin
			sys1 <= 22'd0;
			sys2 <= 20'd0;
			reset <= 0;
		end
	
		else if (SW[0] == 1 && SW[1] == 0) begin
			sys1 <= sys1 + 1;
			
			if (sys1 >= 22'd3600000) begin
				reset <= 1;
			end
		end
		
		else if (SW[0] == 0 & SW[1] == 1) begin
			sys2 <= sys2 + 1;
			
			if (sys2 == 20'd800000) begin
				reset <= 1;
			end
		end
	end
	
	assign LEDR[0] = (sys1 <= 22'd400000  || sys2 <= 20'd400000);
	assign LEDR[1] = (sys1 <= 22'd800000  || sys2 <= 20'd600000);
	assign LEDR[2] = (sys1 <= 22'd1200000 || sys2 <= 20'd700000);
	assign LEDR[3] = (sys1 <= 22'd1600000 || sys2 <= 20'd750000);
	assign LEDR[4] = (sys1 <= 22'd2000000 || sys2 <= 20'd775000);
	assign LEDR[5] = (sys1 <= 22'd2400000 || sys2 <= 20'd787500);
	assign LEDR[6] = (sys1 <= 22'd2800000 || sys2 <= 20'd793750);
	assign LEDR[7] = (sys1 <= 22'd3200000 || sys2 <= 20'd796875);

endmodule