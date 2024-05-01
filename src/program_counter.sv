module program_counter(
    input logic clk,
    input logic rst,
    input logic jalr,
    input logic load,
    input logic branch,
    input logic dmem_valid,
    input logic next_select,
    input logic branch_result,
    input logic [31 : 0]  next_address,
    input logic [31 : 0]  pc_address_in,

    output logic [31 : 0] pc_address_out,
    output logic [31 : 0] pre_pc_address
);

    logic [31 : 0] previous_address;

    always_ff @( posedge clk or negedge rst ) begin
        if (!rst) begin
            pc_address_out <= 0;
            previous_address <= pc_address_out;
        end
        else begin
            if (next_select) begin
                pc_address_out   <= next_address;
                previous_address <= pc_address_out;
            end
            else if (jalr) begin
                pc_address_out   <= next_address;
                previous_address <= pc_address_out;
            end
            else if (branch) begin
                if (branch_result) begin
                    pc_address_out   <= next_address;
                    previous_address <= pc_address_out;
                end
                else begin
                    pc_address_out   <= pc_address_out + 32'd4;
                    previous_address <= pc_address_out;
                end
            end
            else if (load | !dmem_valid) begin 
                pc_address_out   <= pc_address_out;
                previous_address <= pre_pc_address;
            end
            else begin
                pc_address_out   <= pc_address_out + 32'd4;
                previous_address <= pc_address_out;
            end
        end
    end
    assign pre_pc_address = previous_address;
endmodule