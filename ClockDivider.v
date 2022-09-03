module ClockDivider(cin,cout);

// written by Jaspal Singh
// edited by Luqmaan Irshad

input cin;
output reg cout;
   
reg[18:0] count     = 19'd0;
parameter D         = 400000;         // toggle every 0.008 sec  

always @(posedge cin) begin
        
    if (count >= D-1) begin             //reset to 0
        count <= 19'd0;
        cout  <= ~cout;                 // toggle           
    end else begin
        count <= count + 19'd1;
    end
end

endmodule