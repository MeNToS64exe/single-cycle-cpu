module module_instrmem(
    input  [31:0] A,
    output [31:0] RD
);
    reg [31:0] mem [0:255];

    initial begin
        $readmemh("program.mem", mem);
    end

    assign RD = mem[A[9:2]];
endmodule

