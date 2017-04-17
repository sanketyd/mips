module eq4test;

        wire[3:0] test;
        wire clk;
        wire[1:0] pushbutton;
        wire result;

        eq4 uut (
            .test(test),
            .clk(clk),
            .pushbutton(pushbutton),
            .result(result)
        );

        initial begin
            clk = 0;
            pushbutton = 2b'10;
            test=4b'0000;
            pushbutton = 2b'00;
            #100;
            pushbutton = 2b'01;
            test=4b'0000;
            pushbutton = 2b'00;

        end
        always begin
            #10 clk=!clk;
        end

endmodule
