`ifndef PARAM
`include "Parametros.v"
`endif

module control(
input wire [6:0] OPCODE,
output reg  [7:0] controls
// constrols = {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp1, ALUOp0}
);
always @(*) begin
case (OPCODE)
OPC_RTYPE: controls = 8'b00100010;  // Type R{ALUSrc=0, MemtoReg=0, RegWrite=1, MemRead=0, MemWrite=0, Branch=0, ALUOp=10}
            OPC_LOAD:  controls = 8'b11110000;  // lw:     {ALUSrc=1, MemtoReg=1, RegWrite=1, MemRead=1, MemWrite=0, Branch=0, ALUOp=00}
            OPC_STORE: controls = 8'b10001000;  // sw:     {ALUSrc=1, MemtoReg=0 (X), RegWrite=0, MemRead=0, MemWrite=1, Branch=0, ALUOp=00}
            OPC_BRANCH: controls = 8'b00000101;  // beq:   {ALUSrc=0, MemtoReg=0 (X), RegWrite=0, MemRead=0, MemWrite=0, Branch=1, ALUOp=01}
            OPC_OPIMM: controls = 8'b10100000;  // addi:   {ALUSrc=1, MemtoReg=0, RegWrite=1, MemRead=0, MemWrite=0, Branch=0, ALUOp=00}
            OPC_JALR:  controls = 8'b10100100;  // jalr:   {ALUSrc=1, MemtoReg=0 (for PC+4 via ALU path assumed), RegWrite=1, MemRead=0, MemWrite=0, Branch=1, ALUOp=00 (for target addr)}
            OPC_JAL:   controls = 8'b10100100;  // jal:    {ALUSrc=1, MemtoReg=0 (for PC+4 via ALU path assumed), RegWrite=1, MemRead=0, MemWrite=0, Branch=1, ALUOp=00 (for target addr)}
            default:   controls = 8'b00000000;
endcase
end
endmodule
