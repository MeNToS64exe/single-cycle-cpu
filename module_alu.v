module module_alu(
    input [31:0] SrcA, SrcB,
    input [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output Zero,
    output Less
);
    always @(*) begin
        ALUResult = 32'b0;
        case (ALUControl)
            3'b000: ALUResult = SrcA + SrcB;
            3'b001: ALUResult = SrcA & SrcB;
            3'b010: ALUResult = SrcA - SrcB;
            3'b011: ALUResult = SrcA >> SrcB[4:0];
            3'b100: begin
                ALUResult[31:24] = SrcA[31:24] + SrcB[31:24];
                ALUResult[23:16] = SrcA[23:16] + SrcB[23:16];
                ALUResult[15:8]  = SrcA[15:8]  + SrcB[15:8];
                ALUResult[7:0]   = SrcA[7:0]   + SrcB[7:0];
            end
            3'b101: begin
                ALUResult[31:24] = ($signed(SrcA[31:24]) + $signed(SrcB[31:24])) >>> 1;
                ALUResult[23:16] = ($signed(SrcA[23:16]) + $signed(SrcB[23:16])) >>> 1;
                ALUResult[15:8]  = ($signed(SrcA[15:8])  + $signed(SrcB[15:8]))  >>> 1;
                ALUResult[7:0]   = ($signed(SrcA[7:0])   + $signed(SrcB[7:0]))   >>> 1;
            end
            default: ALUResult = 32'b0;
        endcase
    end
    assign Zero = (ALUResult == 0);
    assign Less = ($signed(SrcA) < $signed(SrcB));
endmodule
