//Luqmaan Irshad 217222365 luq21
//EECS 3216 Z Lab 4
module Lab4(input [3:0] SW, input reset, input sys_clk, output [6:0] HEX1, output [6:0] HEX0);

int stale5  = 0;
int stale10 = 0;
int stale20 = 0;
reg SDCtrl = 0;
reg [6:0] timer = 7'd0;
reg [3:0] time1 = 4'd0;
reg [3:0] time0 = 4'd0;
reg [1:0] second = 2'd0;
reg [31:0] count = 32'd0;
parameter D = 25000000;

//Left 7SD
assign HEX1[0] = (time1 == 1 || time1 == 4) || SDCtrl;
assign HEX1[1] = (time1 == 5 || time1 == 6) || SDCtrl;
assign HEX1[2] = (time1 == 2) || SDCtrl;
assign HEX1[3] = (time1 == 1 || time1 == 4 || time1 == 7) || SDCtrl;
assign HEX1[4] = ~(time1 == 0 || time1 == 2 || time1 == 6 || time1 == 8) || SDCtrl;
assign HEX1[5] = (time1 == 1 || time1 == 2 || time1 == 3 || time1 == 7) || SDCtrl;
assign HEX1[6] = (time1 == 0 || time1 == 1 || time1 == 7) || SDCtrl;

//Right 7SD
assign HEX0[0] = (time0 == 1 || time0 == 4) || SDCtrl;
assign HEX0[1] = (time0 == 5 || time0 == 6) || SDCtrl;
assign HEX0[2] = (time0 == 2) || SDCtrl;
assign HEX0[3] = (time0 == 1 || time0 == 4 || time0 == 7) || SDCtrl;
assign HEX0[4] = ~(time0 == 0 || time0 == 2 || time0 == 6 || time0 == 8) || SDCtrl;
assign HEX0[5] = (time0 == 1 || time0 == 2 || time0 == 3 || time0 == 7) || SDCtrl;
assign HEX0[6] = (time0 == 0 || time0 == 1 || time0 == 7) || SDCtrl;


always @ (posedge sys_clk) begin

	if (!reset) begin
		
		//Reset timers
		timer = 7'd0;
		time1 = 4'd0;
		time0 = 4'd0;
		
		//Reset stale trackers
		stale5  = 0;
		stale10 = 0;
		stale20 = 0;
		
		//Reset clock tracker
		count = 0;
		
		//Reset blink control
		SDCtrl = 0;
		
	end
	
	if (timer == 0) begin
			SDCtrl = 0;
	end
	
	if (SW[3] || timer > 0) begin
	
		if (count < (D + D)) begin
			count = count + 32'd1;
		end
		
		else begin
			count = 0;
		end
		
		if ((count == D + D - 1) && (timer > 0)) begin
		
			timer = timer - 1;
			
			if (time0 == 0) begin
				time1 = time1 - 1;
				time0 = 9;
			end
			
			else begin
				time0 = time0 - 1;
			end
			
		end
		
		if ((timer <= 10) && (count == D || count == D + D - 1)) begin
			SDCtrl = ~SDCtrl;
		end
		
	end
	
	//If tokens exceed time limit
	if ((SW[2] && (stale20 == 0) && ((timer + 20) > 99)) || (SW[1] && (stale10 == 0) && ((timer + 10) > 99)) || (SW[0] && (stale5 == 0) && ((timer + 5) > 99))) begin
		time1 = 9;
		time0 = 9;
		timer = 99;
	end

	//Insert a 20 second token
	if (SW[2] && (stale20 == 0) && ((timer + 20) <= 99)) begin
		time1 = time1 + 2;
		timer = timer + 20;
		stale20 = 1;
	end
	
	//Insert a 10 second token
	if (SW[1] && (stale10 == 0) && ((timer + 10) <= 99)) begin
		time1 = time1 + 1;
		timer = timer + 10;
		stale10 = 1;
	end
	
	//Insert a 5 second token
	if (SW[0] && (stale5 == 0) && ((timer + 5) <= 99)) begin
		
		if (time0 == 5) begin
			time1 = time1 + 1;
			time0 = 0;
		end
		
		else begin
			time0 = time0 + 5;
		end
		
		timer = timer + 5;
		stale5 = 1;
		
	end
	
	//Reset token insert slots
	if (~SW[2]) begin
		stale20 = 0;
	end
	if (~SW[1]) begin
		stale10 = 0;
	end
	if (~SW[0]) begin
		stale5 = 0;
	end

end

endmodule
