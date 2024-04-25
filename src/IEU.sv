module execute #(
    #parameter DataWidth = 32;
    )
    (
        input logic [3 : 0]  alu_control,
        input logic [DataWidth-1 : 0] operand_a,
        input logic [DataWidth-1 : 0] operand_b,
        input logic [DataWidth-1 : 0] pc_address,

        output logic [DataWidth-1 : 0] alu_out,
        output logic [DataWidth-1 : 0] next_sel_address
    );

    // ALU INSTANCE
    alu #(
        .DataWidth(DataWidth)
    )u_alu0 
    (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_control(alu_control),
        .result(alu_out)
    );
    // ADDER INSTANCE
    adder #(
        .DataWidth(DataWidth)
    )u_adder0
    (
        .a(pc_address),
        .adder_out(next_sel_address)
    );
endmodule