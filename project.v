module project(clk, enable, rst, select, o1, o2);

//edge triggered D flip flop with enable

output [6:0] o1, o2;
reg [3:0] lsb, msb = 4'd0;
input clk, enable, rst, select;
integer loaded = 0;

//input [7:0] d_in;
//output reg [7:0] d_out;
//parameter int loaded = 0;

always @(posedge clk or negedge rst)
begin
    
    if (~rst)
    begin
        //d <= 8'd0;
		  lsb <= 4'd0;
        msb <= 4'd0;
        loaded = 0;
    end
        
    else
    begin
        
        if (select <= 0 && loaded == 0)
        begin
            lsb <= 4'd4;
            msb <= 4'd2;
            loaded <= 1;
        end
        
        else if (select <= 1 && loaded == 0)
        begin 
            lsb <= 4'd0;
            msb <= 4'd3;
            loaded <= 1;
        end
    
        if (enable <= 1 && loaded == 1)
        begin
				
				//ClockDivider clock(enable, lsb);
		  
            if (lsb != 0)
            begin
                lsb <= lsb - 4'd1;    
            end
            
				else if (lsb <= 4'd0)
            begin 
            
					if (msb <= 4'd0)
                begin
                    lsb <= 4'd0;
                    msb <= 4'd0;
                end
                
                else
                    msb <= msb - 4'd1;
                    lsb <= 4'd9;
            end
        end
		  //ssD num1(lsb, o1);
		  //ssD num2(msb, o2);
    end
    
end

endmodule