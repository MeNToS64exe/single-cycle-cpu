module module_datamem(
    input  clk,
    input  WE,
    input  [4:0] A,
    input  [31:0] WD,
    output [31:0] RD
);
    reg [31:0] rf[31:0];

    assign RD = rf[A];

    always @(posedge clk) begin
        if (WE) rf[A] <= WD;
    end
endmodule

