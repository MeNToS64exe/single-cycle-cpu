module module_controlunit(
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,
    output reg BranchBeq,
    output reg BranchBlt,
    output reg BranchJal,
    output reg BranchJalr,
    output reg RegWrite,
    output reg MemToReg,
    output reg MemWrite,
    output reg [2:0] ALUControl,
    output reg ALUSrc,
    output reg [2:0] ImmControl
);
    always @(*) begin
        BranchBeq = 0;
        BranchBlt = 0;
        BranchJal  = 0;
        BranchJalr = 0;
        RegWrite   = 0;
        MemToReg   = 0;
        MemWrite   = 0;
        ALUControl = 3'b000;
        ALUSrc     = 0;
        ImmControl = 3'b000;

        case (opcode)
            // R-type
            7'b0110011: begin
                RegWrite = 1;
                ALUSrc = 0;
                ImmControl = 3'b000;
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: ALUControl = 3'b000; // +  (add)
                    {7'b0000000, 3'b111}: ALUControl = 3'b001; // &  (and)
                    {7'b0100000, 3'b000}: ALUControl = 3'b010; // -  (sub)
                    {7'b0000000, 3'b101}: ALUControl = 3'b011; // >> (srl)
                endcase
            end

            7'b0001011: begin
                RegWrite = 1;
                ALUSrc = 0;
                ImmControl = 3'b000;
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: ALUControl = 3'b100; // +   (vec)
                    {7'b0000000, 3'b001}: ALUControl = 3'b101; // avg (vec)
                endcase
            end

            // I-type
            7'b0010011: begin // addi
                RegWrite = 1;
                ALUSrc = 1;
                ALUControl = 3'b000; // +
                ImmControl = 3'b001;
            end

            7'b0000011: begin // lw
                RegWrite = 1;
                MemToReg = 1;
                ALUSrc = 1;
                ALUControl = 3'b000; // +
                ImmControl = 3'b001;
            end

            7'b1100111: begin // jalr
                RegWrite = 1;
                BranchJalr = 1;
                ALUSrc = 1;
                ALUControl = 3'b000; // +
                ImmControl = 3'b001;
            end

            // S-type
            7'b0100011: begin // sw
                MemWrite = 1;
                ALUSrc = 1;
                ALUControl = 3'b000; // +
                ImmControl = 3'b010;
            end

            // B-type
            7'b1100011: begin
                ALUSrc = 0;
                ImmControl = 3'b011;
                case (funct3)
                    3'b000: begin // beq
                        BranchBeq = 1;
                        ALUControl = 3'b010; // sub
                    end
                    3'b100: begin // blt
                        BranchBlt = 1;
                        ALUControl = 3'b010; // sub
                    end
                endcase
            end

            // J-type
            7'b1101111: begin // jal
                BranchJal = 1;
                RegWrite = 1;
                ImmControl = 3'b100;
            end
        endcase
    end
endmodule

