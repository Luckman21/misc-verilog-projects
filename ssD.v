module ssD(input[3:0] a, output[6:0] o);

    //Luqmaan Irshad 217222365 luq21
    
    assign o[0] = (~a[3]&a[1] | a[3]&a[2]&~a[1] | a[2]&~a[1]&a[0] | a[3]&a[2]&~a[0]);
    assign o[1] = (~a[3]&~a[2] | ~a[3]&~a[1]&~a[0] | ~a[3]&a[1]&a[0] | a[3]&a[2]&~a[1]);
    assign o[2] = (~a[3]&a[2] | ~a[3]&~a[1] | ~a[3]&a[0] | a[2]&~a[1]);
    assign o[3] = (~a[3]&~a[2]&a[1] | ~a[3]&a[1]&~a[0] | ~a[3]&~a[2]&~a[0] | a[3]&a[2]&~a[1] | a[2]&~a[1]&a[0]);
    assign o[4] = (a[3]&a[2]&~a[1]&~a[0] | ~a[3]&a[2]&~a[0] | ~a[3]&~a[2]&~a[0]);
    assign o[5] = (a[2]&~a[1] | ~a[3]&~a[1]&~a[0] | ~a[3]&a[2]&~a[0]);
    assign o[6] = (a[2]&~a[1] | ~a[3]&~a[2]&a[1] | ~a[3]&a[1]&~a[0]);
    
endmodule