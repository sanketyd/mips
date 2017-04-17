module adder (
    input a,
    input b,
    input cin,
    output s,
    output cout
);
 
assign {cout,s} = a+b+cin;
 
endmodule
 
 
module LCD(clk, sf_e, e, rs, rw, d, c, b, a,t0,t1,t2,t3,pushbutton0,pushbutton1,carryw);
input clk; // pin C9 is the 50-MHz on-board clock
output reg sf_e; // 1 LCD access (0 strataFlash access)
output reg e; // enable (1)
output reg rs;  // Register Select (1 data bits for R/W)
output reg rw;  // Read/Write 1/0
output reg d;   // 4th data bits (to form a nibble)
output reg c;   // 3rd data bits (to form a nibble)
output reg b;   // 2nd data bits (to form a nibble)
output reg a;
input wire pushbutton0;
input wire pushbutton1;
input wire t0;
input wire t1;
input wire t2;
input wire t3;
output wire carryw;
reg [26:0] count = 0;   // 27-bit count, 0-(128M-1), over 2 secs
reg [5:0] code; // 6-bits different signals to give out
reg refresh;
wire[3:0] result;
reg salvi[3:0];
reg natti[3:0];
always @ (posedge clk) begin
    count <= count + 1;
    if(pushbutton0 == 1) begin
        salvi[0] <= t0;
        salvi[1] <= t1;
        salvi[2] <= t2;
        salvi[3] <= t3;
    end else if(pushbutton1 == 1) begin
        natti[0] <= t0;
        natti[1] <= t1;
        natti[2] <= t2;
        natti[3] <= t3;
    end
   
case (count [26:21]) // as top 6 bits change
// power-on init can be carried out befor this loop to avoid the flickers
0: code <= 6'h03; // power-on init sequence
1: code <= 6'h03; // this is needed at least once
2: code <= 6'h03; // when LCD's powered on
3: code <= 6'h02; // it flickers existing char dislay
// Table 5-3, Function Set
// Send 00 and upper nibble 0010, then 00 and lower nibble 10xx
4: code <= 6'h02; // Function Set, upper nibble 0010
5: code <= 6'h08; // lower nibble 1000 (10xx)
// Table 5-3, Entry Mode
// send 00 and upper nibble: I/D bit (Incr 1, Decr 0), S bit (Shift 1, 0 no)
6: code <= 6'h00; // see table, upper nibble 0000, then lower nibble:
7: code <= 6'h06; // 0110: Incr, Shift disabled
// Table 5-3, Display On/Off
// send 00 and upper nibble 0000, then 00 and lower nibble 1 DCB
// D: 1, show char represented by code in DDR, 0 don't, but code remains
// C: 1, show cursor, 0 don't
// B: 1, cursor blinks (if shown), 0 don't blink (if shown)
8: code <= 6'h00; // Display On/Off, upper nibble 0000
9: code <= 6'h0C; // lower nibble 1100 (1 D C 😎
// Table 5-3 Clear Display, 00 and upper nibble 0000, 00 and lower nibble 0001
10: code <= 6'h00; // Clear Display, 00 and upper nibble 0000
11: code <= 6'h01; // then 00 and lower nibble 0001
// Chararters are then given out, the cursor will advance to the right
// Table 5-3, Write Data to DD RAM (or CG RAM)
// Fig 5-4, 'H' send 10 and upper nibble 0100, then 10 and lower nibble
12: casez(result)
        4'b0000 : code <= 6'h23;  
                  //code <= 6'h20;
        4'b0001 : code <= 6'h23;
                  //code <= 6'h21;
        4'b0010 : code <= 6'h23;
                  //code <= 6'h22;
        4'b0011 : code <= 6'h23;
                  //code <= 6'h23;
        4'b0100 : code <= 6'h23;
                    //code <= 6'h24;
        4'b0101 : code <= 6'h23;
                    //code <= 6'h25;
        4'b0110 : code <= 6'h23;
                    //code <= 6'h26;
        4'b0111 : code <= 6'h23;
                    //code <= 6'h27;
        4'b1000 : code <= 6'h23;
                    //code <= 6'h28;
        4'b1001 : code <= 6'h23;
                    //code <= 6'h29;
        4'b1010 : code <= 6'h24;
                   // code <= 6'h21;
        4'b1011 : code <= 6'h24;
                   // code <= 6'h22;
        4'b1100 : code <= 6'h24;
                    //code <= 6'h23;
        4'b1101 : code <= 6'h24;
                    //code <= 6'h24;
        4'b1110 : code <= 6'h24;
                    //code <= 6'h25;
        4'b1111 : code <= 6'h24;
                    //code <= 6'h26;
    endcase
   
13: casez(result)
        4'b0000 : code <= 6'h20; //'0' low nibble
        4'b0001 : code <= 6'h21;
        4'b0010 : code <= 6'h22;
        4'b0011 : code <= 6'h23;
        4'b0100 : code <= 6'h24;
        4'b0101 : code <= 6'h25;
        4'b0110 : code <= 6'h26;
        4'b0111 : code <= 6'h27;
        4'b1000 : code <= 6'h28;
        4'b1001 : code <= 6'h29;
        4'b1010 : code <= 6'h21; //'A' low nibble
        4'b1011 : code <= 6'h22;
        4'b1100 : code <= 6'h23;
        4'b1101 : code <= 6'h24;
        4'b1110 : code <= 6'h25;
        4'b1111 : code <= 6'h26;
    endcase
 
        default: code <= 6'h10; // the restun-used time
    endcase
// refresh (enable) the LCD when bit 20 of the count is 1
// (it flips when counted upto 2M, and flips again after another 2M)
    refresh <= count[ 20 ]; // flip rate about 25 (50MHz/2*21=2M)
    sf_e <= 1; e <= refresh;
    rs <= code[5]; rw <= code[4];
    d <= code[3]; c <= code[2];
    b <= code[1]; a <= code[0];
end // always
 //fourbitadder abc (.one(salvi),.two(natti),.sum(result),.carry(carryw));
 wire[2:0] cr;
 adder b1 (.a(salvi[0]),.b(natti[0]),.cin(1'b0),.s(result[0]),.cout(cr[0]));
 adder b2 (.a(salvi[1]),.b(natti[1]),.cin(cr[0]),.s(result[1]),.cout(cr[1]));
 adder b3 (.a(salvi[2]),.b(natti[2]),.cin(cr[1]),.s(result[2]),.cout(cr[2]));
 adder b4 (.a(salvi[3]),.b(natti[3]),.cin(cr[2]),.s(result[3]),.cout(carryw));

    endmodule

