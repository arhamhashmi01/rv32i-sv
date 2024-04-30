module decode #(
    parameter DataWidth  = 32,
    parameter RegAddress = 5
)(
    input logic clk,
    input logic rst,
    input logic valid,
    input logic reg_write_en_in,
    input logic load_control_signal,
    input logic [DataWidth-1 : 0] instruction,
    input logic [DataWidth-1 : 0] pc_address,
    input logic [DataWidth-1 : 0] rd_wb_data,
    input logic [DataWidth-1 : 0] instruction_rd,

    output logic load,
    output logic store,
    output logic jalr,
    output logic Branch,
    output logic next_sel,
    output logic branch_result,
    output logic reg_write_en_out,
    output logic [3 : 0]  alu_control,
    output logic [1 : 0]  mem_to_reg,
    output logic [RegAddress-1 : 0] rs1,rs2,
    output logic [DataWidth-1 : 0] opb_data,
    output logic [DataWidth-1 : 0] opa_mux_out,
    output logic [DataWidth-1 : 0] opb_mux_out
    );

    logic func7;
    logic branch;
    logic operand_a;
    logic operand_b;
    logic [2:0] func3;
    logic [6:0]opcode;
    logic [2:0]  imm_sel;
    logic [RegAddress-1: 0] rd;
    logic [RegAddress-1: 0] rs_1;
    logic [RegAddress-1: 0] rs_2;
    logic [DataWidth-1 : 0] op_a;
    logic [DataWidth-1 : 0] op_b;
    logic [DataWidth-1 : 0] i_immo;
    logic [DataWidth-1 : 0] s_immo;
    logic [DataWidth-1 : 0] sb_immo; 
    logic [DataWidth-1 : 0] uj_immo; 
    logic [DataWidth-1 : 0] u_immo;
    logic [DataWidth-1 : 0] imm_mux_out;

    assign func7 = instruction[30];
    assign func3 = instruction[14:12];
    assign rs_1 = instruction[19:15];
    assign rs_2 = instruction[24:20];
    assign rd = instruction_rd[11:7];
    assign opcode = instruction[6:0];

    // CONTROL UNIT
    control_unit u_cu0 
    (
        .opcode(opcode),
        .fun3(func3),
        .fun7(func7),
        .valid(valid),
        .reg_write(reg_write_en_out),
        .imm_sel(imm_sel),
        .next_sel(next_sel),
        .operand_b(operand_b),
        .operand_a(operand_a),
        .mem_to_reg(mem_to_reg),
        .Load(load),
        .Store(store),
        .jalr_out(jalr),
        .Branch(branch),
        .load_control(load_control_signal),
        .alu_control(alu_control)
    );

    assign Branch = branch;

    // IMMEDIATE GENERATION
    immediate_generation #(
        .DataWidth(DataWidth)
    )u_imm_gen0
    (
        .instruction(instruction),
        .i_imme (i_immo),
        .sb_imme(sb_immo),
        .s_imme (s_immo),
        .uj_imme(uj_immo),
        .u_imme (u_immo)
    );

    //IMMEDIATE SELECTION MUX
    assign imm_mux_out =
                    (imm_sel==3'b000) ? i_immo :
                    (imm_sel==3'b001) ? s_immo :
                    (imm_sel==3'b010) ? sb_immo:
                    (imm_sel==3'b011) ? uj_immo:
                    (imm_sel==3'b100) ? u_immo : 32'd0;

    // REGISTER FILE
    register_file #(
        .DataWidth(DataWidth),
        .RegAddress(RegAddress)
    )u_regfile0 
    (
        .clk(clk),
        .rst(rst),
        .write_enale(reg_write_en_in),
        .source1(rs_1),
        .source2(rs_2),
        .writedata_add(rd),
        .write_data(rd_wb_data),
        .readdata1(op_a),
        .readdata2(op_b)
    );

    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign opb_data = op_b ;

    //SELECTION OF PROGRAM COUNTER OR OPERAND A
    assign opa_mux_out =
            (operand_a) ? op_a : pc_address;
    
    //SELECTION OF OPERAND B OR IMMEDIATE     
    assign opab_mux_out =
            (operand_b) ? op_b : imm_mux_out;

    //BRANCH
    branch #(
        .DataWidth(DataWidth)        
    )u_branch0
    (
        .en(branch),
        .operand_a(op_a),
        .operand_b(op_b),
        .fun3(instruction[14:12]),
        .result(branch_result)
    );
endmodule