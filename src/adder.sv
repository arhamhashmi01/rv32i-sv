module adder #(
    parameter DataWidth = 32
    )
    (
        input logic [DataWidth-1 : 0] a,
        output logic [DataWidth-1 : 0] adder_out
    );

    always_comb begin
        adder_out = a + 32'd4;
    end
endmodule