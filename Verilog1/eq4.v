module eq1
(
    input wire i0,i1,
    output wire eq
);

wire p0,p1;

assign eq = p0 | p1;

assign p0 = ~i0 & ~i1;
assign p1 = i0 & i1;

endmodule

module eq2
(
    input wire[1:0] w1,w2,
    output wire chk
);
wire e0,e1;
eq1 eq_1 (.i0(w1[0]), .i1(w2[0]),.eq(e0));
eq1 eq_2 (.eq(e1), .i0(w1[1]), .i1(w2[1]));

assign chk = e0 & e1;

endmodule

module eq4
(
	 input wire clk,
	 input wire[3:0] test,
	 input wire[1:0] pushbutton,
	 output wire result
);
reg[3:0] one = 4'b0000;
reg[3:0] two = 4'b0000;
always @(posedge clk)
begin
	if (pushbutton[0] == 1)		
		one <= test;
	if (pushbutton[1] == 1)
		two <= test;
end
	
	wire t1,t2;
	eq2 yo (.w1(one[1:0]),.w2(two[1:0]),.chk(t1));
	eq2 yo2 (.chk(t2),.w1(one[3:2]),.w2(two[3:2]));
	assign result = t1 & t2;
	
endmodule

