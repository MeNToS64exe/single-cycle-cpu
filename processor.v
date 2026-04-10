`default_nettype none
module processor(
    input        clk,
    input        Reset,

    output [31:0] PC,
    input  [31:0] Instruction,

    output        WriteEnable,
    output [31:0] Address,
    output [31:0] Results,
    input  [31:0] ReadData
);
    reg [31:0] PC_reg;
    assign PC = PC_reg;

    wire [31:0] PCNext;

    always @(posedge clk or posedge Reset) begin
        if (Reset)
            PC_reg <= 0;
        else
            PC_reg <= PCNext;
    end

    wire [31:0] Instr = Instruction;

    wire [6:0] opcode = Instr[6:0];
    wire [4:0] rd     = Instr[11:7];
    wire [2:0] funct3 = Instr[14:12];
    wire [4:0] rs1    = Instr[19:15];
    wire [4:0] rs2    = Instr[24:20];
    wire [6:0] funct7 = Instr[31:25];

    wire BranchBeq, BranchBlt, BranchJal, BranchJalr;
    wire RegWrite, MemWrite, MemToReg, ALUSrc;
    wire [2:0] ALUControl;
    wire [2:0] ImmControl;

    module_controlunit CU(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .BranchBeq(BranchBeq),
        .BranchBlt(BranchBlt),
        .BranchJal(BranchJal),
        .BranchJalr(BranchJalr),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ImmControl(ImmControl),
        .MemToReg(MemToReg)
    );

    wire [31:0] SrcA, RD2;
    wire [31:0] WriteData;

    module_gprset RF(
        .clk(clk),
        .WE3(RegWrite),
        .A1(rs1),
        .A2(rs2),
        .A3(rd),
        .WD3(WriteData),
        .RD1(SrcA),
        .RD2(RD2)
    );

    wire [31:0] Imm;

    module_immdecode IMM(
        .Inst(Instr[31:7]),
        .ImmControl(ImmControl),
        .ImmResult(Imm)
    );

    wire [31:0] SrcB;

    module_multiplexor MUX_ALUSrc(
        .SrcA(RD2),
        .SrcB(Imm),
        .select(ALUSrc),
        .out(SrcB)
    );

    wire [31:0] ALUResult;
    wire Zero, Less;

    module_alu ALU(
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero),
        .Less(Less)
    );

    wire isEq = BranchBeq & Zero;
    wire isLess = BranchBlt & Less;
    wire BranchCond = isEq | isLess;
    wire BranchJalx = BranchJal | BranchJalr;
    wire Branch = BranchCond | BranchJalx;

    assign WriteEnable  = MemWrite;
    assign Address      = ALUResult;
    assign Results      = RD2;

    wire [31:0] PCPlus4     = PC_reg + 4;
    wire [31:0] PCPlusImm   = PC_reg + Imm;

    wire [31:0] ToLoad;

    module_multiplexor MUX_ToLoad(
        .SrcA(ALUResult),
        .SrcB(PCPlus4),
        .select(BranchJalx),
        .out(ToLoad)
    );

    module_multiplexor MUX_WriteData(
        .SrcA(ToLoad),
        .SrcB(ReadData),
        .select(MemToReg),
        .out(WriteData)
    );

    wire [31:0] PCJump;
    module_multiplexor MUX_Jalr(
        .SrcA(PCPlusImm),
        .SrcB(ALUResult),
        .select(BranchJalr),
        .out(PCJump)
    );

    wire [31:0] PCResult;
    module_multiplexor MUX_Branch(
        .SrcA(PCPlus4),
        .SrcB(PCJump),
        .select(Branch),
        .out(PCResult)
    );

    assign PCNext = PCResult;
endmodule
`default_nettype wire

