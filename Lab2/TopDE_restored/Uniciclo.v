`ifndef PARAM
	`include "Parametros.v"
`endif

module Uniciclo (
	input logic clockCPU, clockMem,
	input logic reset,
	output reg [31:0] PC,
	output logic [31:0] Instr,
	input  logic [4:0] regin,
	output logic [31:0] regout
	);
	
	
	initial
		begin
			PC<=TEXT_ADDRESS;
			Instr<=32'b0;
			regout<=32'b0;
		end
		
		wire [31:0] SaidaULA, Leitura2, MemData;
		wire EscreveMem, LeMem;
		
//******************************************
// Aqui vai o seu código do seu processador

	// Instruction 
	wire [6:0] opcode = Instr[6:0];
	wire [2:0] funct3 = Instr[14:12];
	wire [6:0] funct7 = Instr[31:25];
	
	// Registers
	wire [4:0] rs1 = Instr[19:15];
	wire [4:0] rs2 = Instr[24:20];
	wire [4:0] rd  = Instr[11:7];
	
	
	// Control
	wire ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
	wire [7:0] controls;
	wire [1:0] ALUOp;
	
	control ControlUnity (
		 .OPCODE(opcode),
		 .constrols(controls)
	);
	
	assign ALUSrc   = controls[7];	//MSB
	assign MemtoReg = controls[6];
	assign RegWrite = controls[5];
	assign MemRead  = controls[4];
	assign MemWrite = controls[3];
	assign Branch   = controls[2];
	assign ALUOp = controls[1:0]; 	//LSB
	
	// Registers
	
	wire [31:0] ReadData1;
	wire [31:0] ReadData2;
	wire [31:0] WriteData;
	
	Registers registers(
	  //input
	 .iCLK(clockCPU),
	 .iRST(reset), 
	 .iRegWrite(RegWrite),
    .iReadRegister1(rs1),
	 .iReadRegister2(rs2),
	 .iWriteRegister(rd),
    .iWriteData(WriteData),
	 .iRegDispSelect(regin),
	 
	  // output
    .oReadData1(ReadData1),	
	 .oReadData2(ReadData2), 	
    .oRegDisp(regout)
	);
	
	// Immediate Generator
	wire [31:0] immediate;
	ImmGen imediateGenerator(
	 .iInstrucao(Instr),
    .oImm(immediate)
	);
	
	// ALU Control
	wire [3:0] ALUControl;
	wire [31:0] ALU_input2;
	assign ALU_input2 = (ALUSrc) ? immediate : ReadData2;
	
	CntrlALU ControlALU (
    .ALUOP(ALUOp),
    .func3(funct3),
    .func7(funct7),
    .operation(ALUControl)
	);
	
	// ULA
	ALU Ula(
	.iControl(ALUControl),
	.iA(ReadData1), 
	.iB(ALU_input2),
	.oResult(SaidaULA)
	);

always @(posedge clockCPU  or posedge reset)
	if(reset)
		PC <= TEXT_ADDRESS;
	else
		PC <= PC + 32'd4;

		
		
assign EscreveMem = 1'b0;
assign LeMem = 1'b1;
assign SaidaULA = 32'b0;


// Instanciação das memórias
ramI MemC (.address(PC[11:2]), .clock(clockMem), .data(), .wren(1'b0), .rden(1'b1), .q(Instr));
ramD MemD (.address(SaidaULA[11:2]), .clock(clockMem), .data(Leitura2), .wren(EscreveMem), .rden(LeMem),.q(MemData));
		

	
		
//*****************************************	
			
endmodule
