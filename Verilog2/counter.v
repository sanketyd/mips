module counter (
    input wire clk,reset,
    input wire[3:0] set,
    input wire pushbutton,
    output wire [3:0] q
);

reg[3:0] sreg= 4'b0000;
reg [25:0] counter = 50_000_000;

always @(posedge clk)
begin
    counter <= counter-1;
    if(reset)
        sreg = 4'b0000;
    else if(pushbutton)
        sreg = set;
    if(counter==0)
	 begin
        sreg = sreg + 4'b0001;
		  counter <= 50_000_000;
	 end 
	
end
	assign q[3:0] = sreg[3:0];
endmodule
