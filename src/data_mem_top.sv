module data_mem_top #(
    parameter INIT_MEM  = 0,
    parameter DataWidth = 32,
    parameter Address   = 8
)(
    input logic clk,
    input logic rst,
    input logic we_re,
    input logic request,
    input logic load,
    input logic [3 : 0]  mask,
    input logic [Address-1 : 0]  address,
    input logic [DataWidth-1 : 0] data_in,

    output logic valid,
    output logic [DataWidth-1 : 0] data_out
    );

    always_ff @(posedge clk or negedge rst) begin
        if(!rst)begin
            valid <= 0;
        end
        else begin
            valid <= load;
        end
    end

    memory #(
      .INIT_MEM(INIT_MEM),
      .DataWidth(DataWidth),
      .Address(Address)
    )u_memory(
        .clk(clk),
        .we_re(we_re),
        .request(request),
        .mask(mask),
        .address(address),
        .data_in(data_in),
        .data_out(data_out)
    );
endmodule