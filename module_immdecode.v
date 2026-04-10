module module_immdecode(
    input  [24:0] Inst,
    input  [2:0]  ImmControl,
    output reg [31:0] ImmResult
);
    always @(*) begin
        case (ImmControl)
            3'b000: ImmResult = 32'b0;
            3'b001: ImmResult = {{20{Inst[24]}}, Inst[24:13]};
            3'b010: ImmResult = {{20{Inst[24]}}, Inst[24:18], Inst[4:0]};
            3'b011: ImmResult = {{19{Inst[24]}}, Inst[24], Inst[0], Inst[23:18], Inst[4:1], 1'b0};
            3'b100: ImmResult = {{11{Inst[24]}}, Inst[24], Inst[12:5], Inst[13], Inst[23:14], 1'b0};
            default: ImmResult = 32'b0;
        endcase
    end
endmodule

