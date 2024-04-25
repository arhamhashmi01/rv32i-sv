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
    

    //FETCH STAGE
    fetch #(
        .DataWidth(DataWidth)
    )u_fetchstage
    (
        .clk(clk),
        .rst(rst),
        .load(load_decode),
        .jalr(jalr_execute),
        .branch(branch),
        .next_sel(next_sel_execute),
        .branch_reselt(branch_result_execute),
        .next_address(alu_res_out_execute),
        .instruction_fetch(instruction),
        .instruction(instruction_fetch),
        .address_in(0),
        .valid(data_mem_valid),
        .mask(instruc_mask_singal),
        .we_re(instruction_mem_we_re),
        .request(instruction_mem_request),
        .pre_address_pc(pre_pc_addr_fetch),
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
        .instruction(instruction_decode),
        .pc_address(pre_pc_addr_decode),
        .rd_wb_data(rd_wb_data),
        .rs1(rs1_decode),
        .rs2(rs2_decode),
        .load(load_decode),
        .store(store_decode),
        .jalr(jalr_decode),
        .Branch(branch),
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
        .operand_a(alu_in_a),
        .operand_b(alu_in_b),
        .pc_address(pre_pc_addr_execute),
        .alu_control(alu_control_execute),
        .alu_out(alu_res_out_execute),
        .next_sel_address(next_sel_address_execute)
    );


endmodule