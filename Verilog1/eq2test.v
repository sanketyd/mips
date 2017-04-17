module eq2test;

        wire[1:0] w1,w2;
        wire chk;

        eq2 uut (
            .w1(w1),
            .w2(w2),
            .chk(chk)
        );

        initial begin
            w1=2b'00;
            w2=2b'01;
            #100;
            w1=2b'01;
            w2=2b'01;
            #100;
            w1=2b'10;
            w2=2b'11;
            #100;
            w1=2b'11;
            w2=2b'11;
        end

endmodule
