module alu #(
    parameter DataWidth = 32
    )
    (
        input logic [DataWidth-1 : 0] operand_a,
        input logic [DataWidth-1 : 0] operand_b,
        input logic [3 : 0] alu_control,

        output logic [DataWidth-1 : 0] result
    );

    always_comb begin
        if (alu_control == 4'b0000) begin
            result = operand_a + operand_b;  //add
        end
        else if (alu_control == 4'b0001) begin
            result = operand_a - operand_b;  //sub
        end
        else if (alu_control == 4'b0010) begin
            result = operand_a << operand_b; //shift left logical
        end
        else if (alu_control == 4'b0011) begin
            result = $signed (operand_a) < $signed (operand_b); //shift less then
        end 
        else if (alu_control == 4'b0100) begin
            result = operand_a < operand_b;  //shift less then unsigned
        end          
        else if (alu_control == 4'b0101) begin
            result = operand_a ^ operand_b;  //xor
        end
        else if (alu_control == 4'b0110) begin
            result = operand_a >> operand_b; //shift right logical
        end
        else if (alu_control == 4'b0111) begin
            result = operand_a >>> operand_b; //shift right arithematic
        end
        else if (alu_control == 4'b1000) begin
            result = operand_a | operand_b;   //or
        end
        else if (alu_control == 4'b1001) begin
            result = operand_a & operand_b;  //and
        end
        else if (alu_control == 4'b1111) begin
            result = operand_b;               //for lui 
        end
        else begin
            result = 0;
        end
    end
endmodule