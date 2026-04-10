module module_multiplexor(
    input  [31:0] SrcA, SrcB,
    input         select,
    output [31:0] out
);
    assign out = (select == 0) ? SrcA : SrcB;
endmodule

