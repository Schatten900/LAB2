`ifndef PARAM
	`include "Parametros.v"
`endif

module control(
	input wire [7:0] OPCODE,
	output reg  [7:0] constrols
);
	always @(*) begin
		case (OPCODE)
			OPC_RTYPE: constrols <= 8'b00100010;  // Type R
			OPC_LOAD: constrols <= 8'b11110000;   // lw
			OPC_STORE: constrols <= 8'b10001000;  // sw
			OPC_BRANCH: constrols <= 8'b00000101; // beq
			default:    constrols <= 8'b00000000; // caso padrão
		endcase
	end

endmodule
