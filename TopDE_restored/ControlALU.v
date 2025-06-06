`ifndef PARAM
	`include "Parametros.v"
`endif

module CntrlALU (
    input  [1:0] ALUOP,
	 input [2:0] func3,
    input  [6:0] func7,
    output reg [3:0] operation
);

	 wire [9:0] func10;
    assign func10 = {func7, func3};  
	 
    always @(*) begin
        case (ALUOP)
            2'b00: operation = OPADD;
            2'b01: operation = OPSUB;
            2'b10: begin
                case (func10)			
                    FUNCT10_ADD: operation = OPADD;
                    FUNCT10_SUB: operation = OPSUB;
                    FUNCT10_AND: operation = OPAND;
                    FUNCT10_OR : operation = OPOR;
                    FUNCT10_SLT: operation = OPSLT;
                    default: operation = OPNULL;
                endcase
            end
            default: operation = OPNULL;
        endcase
    end

endmodule