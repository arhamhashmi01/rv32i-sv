module memory_stage #(
    parameter DataWidth = 32
    )(
        input logic rst,
        input logic load,
        input logic store,
        input logic valid,
        input logic data_valid,
        input logic [DataWidth-1 : 0] operand_b,
        input logic [DataWidth-1 : 0] instruction,
        input logic [DataWidth-1 : 0] wrap_load_in,
        input logic [DataWidth-1 : 0] alu_out_address,

        output logic we_re,
        output logic request,
        output logic [3 : 0]  mask,
        output logic [DataWidth-1 : 0] store_data_out,
        output logic [DataWidth-1 : 0] wrap_load_out
    );

    // WRAPPER MEMORY
    wrappermem u_wrap_mem0 (
        .data_i(operand_b),
        .byteadd(alu_out_address [1:0]),
        .fun3(instruction [14:12]),
        .mem_en(store),
        .Load(load),
        .wrap_load_in(wrap_load_in),
        .masking(mask),
        .data_valid(data_valid),
        .data_o(store_data_out),
        .wrap_load_out(wrap_load_out)
    );

    always_comb begin
        if (!valid | !load | !store) begin
            request = 0;
            we_re = 0;
        end
        else begin
            request = load | store ;
            we_re = store ;
        end
    end
endmodule