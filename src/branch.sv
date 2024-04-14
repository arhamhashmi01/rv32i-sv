module branch #(
    parameter DataWidth = 32;
    )(
        input logic en;
        input logic [2 : 0] fun3,
        input logic [DataWidth-1 : 0] operand_a,
        input logic [DataWidth-1 : 0] operand_b,

        output logic result,
    );
    
    always_comb begin
        if(en)begin
            case (fun3)
                3'b000 : result = (operand_a == operand_b) ? 1 : 0 ;
                3'b001 : result = (operand_a != operand_b) ? 1 : 0 ;
                3'b100 : result = ($signed (operand_a) <  $signed (operand_b)) ? 1 : 0 ;
                3'b101 : result = ($signed (operand_a) >= $signed (operand_b)) ? 1 : 0 ;
                3'b110 : result = (operand_a <  operand_b) ? 1 : 0 ;
                3'b111 : result = (operand_a >= operand_b) ? 1 : 0 ;
            endcase
        end
        else begin
            result = 0;
        end
    end
endmodule