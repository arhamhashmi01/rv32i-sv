module core_top #(
    parameter DataWidth  = 32;
    parameter RegAddress = 5;
    parameter Address    = 8;
    )(
        input logic clk,
        input logic rst,
        input logic [DataWidth-1  : 0] instruction
    );

    logic [3:0]  mask;
    logic [3:0]  instruc_mask_singal;
    logic [DataWidth-1  : 0] instruction_data;
    logic [DataWidth-1  : 0] pc_address;
    logic [DataWidth-1  : 0] load_data_out;
    logic [DataWidth-1  : 0] alu_out_address;
    logic [DataWidth-1  : 0] store_data;
    logic instruction_mem_we_re;
    logic instruction_mem_request;
    logic instruc_mem_valid;
    logic data_mem_valid;
    logic data_mem_we_re;
    logic data_mem_request;
    logic load_signal;
    logic store;

    // INSTRUCTION MEMORY
    instruc_mem_top #(
        .INIT_MEM(1),
        .DataWidth(DataWidth),
        .Address  (Address)
    )u_instruction_memory(
        .clk(clk),
        .rst(rst),
        .we_re(instruction_mem_we_re),
        .request(instruction_mem_request),
        .mask(instruc_mask_singal),
        .address(pc_address[9:2]),
        .data_in(instruction),
        .valid(instruc_mem_valid),
        .data_out(instruction_data)
    );

    //CORE
    core u_core(
        .clk(clk),
        .rst(rst),
        .instruction(instruction_data),
        .load_data_in(load_data_out),
        .mask_singal(mask),
        .load_signal(load_signal),
        .instruc_mask_singal(instruc_mask_singal),
        .instruction_mem_we_re(instruction_mem_we_re),
        .instruction_mem_request(instruction_mem_request),
        .data_mem_we_re(data_mem_we_re),
        .data_mem_request(data_mem_request),
        .instruc_mem_valid(instruc_mem_valid),
        .data_mem_valid(data_mem_valid),
        .store_data_out(store_data),
        .pc_address(pc_address),
        .alu_out_address(alu_out_address)
    );


    // DATA MEMORY
    data_mem_top  #(
        .DataWidth(DataWidth),
        .Address  (Address)
    )u_data_memory(
        .clk(clk),
        .rst(rst),
        .we_re(data_mem_we_re),
        .request(data_mem_request),
        .address(alu_out_address[9:2]),
        .data_in(store_data),
        .mask(mask),
        .load(load_signal),
        .valid(data_mem_valid),
        .data_out(load_data_out)
    );
endmodule