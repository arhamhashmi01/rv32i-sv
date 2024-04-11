module memory#(
    parameter INIT_MEM  = 0;
    parameter DataWidth = 32;
    parameter Address   = 8;
)(
    input logic clk,
    input logic we_re,
    input logic request,
    input logic [3:0] mask,
    input logic [Address-1 : 0] address,
    input logic [DataWidth-1 : 0] data_in,

    output logic [DataWidth-1 : 0]data_out
);

    logic Depth = 256;

    logic [DataWidth-1 : 0] mem [0 : Depth-1];

    initial begin
        if (INIT_MEM)
            $readmemh("tb/instr.mem",mem);
    end

    always_ff @(posedge clk) begin
        if (request && we_re) begin
            if(mask[0]) begin
                mem[address][7:0] <= data_in[7:0];
            end
            if(mask[1]) begin
                mem[address][15:8] <= data_in[15:8];
            end
            if(mask[2]) begin
                mem[address][23:16] <= data_in[23:16];
            end
            if(mask[3]) begin
                mem[address][31:24] <= data_in[31:24];
            end
        end
        else begin
            if (request && !we_re) begin
                data_out <= mem[address];
            end
        end
    end
endmodule