module core #(
    parameter DataWidth  = 32;
    parameter RegAddress = 5;
) (
    input logic clk,
    input logic rst,
    input logic data_mem_valid,
    input logic instruc_mem_valid,
    input logic [DataWidth-1 : 0] instruction,
    input logic [DataWidth-1 : 0] load_data_in,

    output logic load_signal,
    output logic data_mem_we_re,
    output logic data_mem_request,
    output logic instruction_mem_we_re,
    output logic instruction_mem_request,
    output logic [3 : 0] mask_singal,
    output logic [3 : 0] instruc_mask_singal,
    output logic [DataWidth-1 : 0] store_data_out,
    output logic [DataWidth-1 : 0] alu_out_address,
    output logic [DataWidth-1 : 0] pc_address
);
    
    logic load_decode;
    logic jalr_decode;
    logic store_decode;
    logic reg_write_wb;
    logic branch_decode;
    logic next_sel_decode;
    logic reg_write_decode;
    logic branch_result_decode;
    logic [3 : 0] mask;
    logic [1 : 0] mem_to_reg_decode;
    logic [3 : 0] alu_control_decode;
    logic [DataWidth-1 : 0] rd_wb_data;
    logic [DataWidth-1 : 0] op_b_decode;
    logic [DataWidth-1 : 0] instruction_wb;
    logic [DataWidth-1 : 0] pc_address_fetch;
    logic [DataWidth-1 : 0] instruction_fetch;
    logic [DataWidth-1 : 0] opa_mux_out_decode;
    logic [DataWidth-1 : 0] opb_mux_out_decode;
    logic [DataWidth-1 : 0] wrap_load_memstage;
    logic [DataWidth-1 : 0] alu_res_out_execute;
    logic [DataWidth-1 : 0] next_sel_address_execute;


    //FETCH STAGE
    fetch #(
        .DataWidth(DataWidth)
    )u_fetchstage
    (
        .clk(clk),
        .rst(rst),
        .load(load_decode),
        .jalr(jalr_decode),
        .branch(branch_decode),
        .next_sel(next_sel_decode),
        .branch_reselt(branch_result_decode),
        .next_address(alu_res_out_execute),
        .instruction_fetch(instruction),
        .instruction(instruction_fetch),
        .address_in(0),
        .valid(data_mem_valid),
        .mask(instruc_mask_singal),
        .we_re(instruction_mem_we_re),
        .request(instruction_mem_request),
        .pre_address_pc(pc_address_fetch),
        .pc_address(pc_address)
    );

    //DECODE STAGE
    decode #(
        .DataWidth (DataWidth),
        .RegAddress(RegAddress)
    )u_decodestage
    (
        .clk(clk),
        .rst(rst),
        .valid(data_mem_valid),
        .load_control_signal(load_execute),
        .reg_write_en_in(reg_write_wb),
        .instruction(instruction_fetch),
        .pc_address(pc_address_fetch),
        .rd_wb_data(rd_wb_data),
        .rs1(rs1_decode),
        .rs2(rs2_decode),
        .load(load_decode),
        .store(store_decode),
        .jalr(jalr_decode),
        .Branch(branch_decode),
        .next_sel(next_sel_decode),
        .reg_write_en_out(reg_write_decode),
        .mem_to_reg(mem_to_reg_decode),
        .branch_result(branch_result_decode),
        .opb_data(op_b_decode),
        .instruction_rd(instruction_wb),
        .alu_control(alu_control_decode),
        .opa_mux_out(opa_mux_out_decode),
        .opb_mux_out(opb_mux_out_decode)
    );

    //EXECUTE STAGE
    execute #(
        .DataWidth(DataWidth)
    )u_executestage
    (
        .operand_a(opa_mux_out_decode),
        .operand_b(opb_mux_out_decode),
        .pc_address(pc_address_fetch),
        .alu_control(alu_control_decode),
        .alu_out(alu_res_out_execute),
        .next_sel_address(next_sel_address_execute)
    );

    //MEMORY STAGE
    memory_stage #(
        .DataWidth(DataWidth)
    )u_memorystage
    (
        .rst(rst),
        .load(load_decode),
        .store(store_decode),
        .operand_b(op_b_decode),
        .instruction(instruction_fetch),
        .alu_out_address(alu_res_out_execute),
        .wrap_load_in(load_data_in),
        .mask(mask),
        .data_valid(data_mem_valid),
        .valid(instruc_mem_valid),
        .we_re(data_mem_we_re),
        .request(data_mem_request),
        .store_data_out(store_data_out),
        .wrap_load_out(wrap_load_memstage)
    );

    assign reg_write_wb   = reg_write_decode;
    assign instruction_wb = instruction_fetch;

    //WRITE BACK STAGE
    write_back #(
        .DataWidth(DataWidth)
    )u_wbstage
    (
        .mem_to_reg(mem_to_reg_decode),
        .alu_out(alu_res_out_execute),
        .data_mem_out(wrap_load_memstage),
        .next_sel_address(next_sel_address_execute),
        .rd_mux_out(rd_wb_data)
    );
endmodule
