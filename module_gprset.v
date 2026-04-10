module module_gprset(
    input  clk,
    input  WE3,
    input  [4:0] A1,
    input  [4:0] A2,
    input  [4:0] A3,
    input  [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2
);
    reg [31:0] rf[31:0];

    assign RD1 = rf[A1];
    assign RD2 = rf[A2];

    always @(posedge clk) begin
        if (WE3 && A3 != 0)
            rf[A3] <= WD3;

        rf[0] <= 32'b0;
    end
endmodule

