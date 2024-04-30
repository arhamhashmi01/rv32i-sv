module control_unit (
    input logic fun7,
    input logic valid,
    input logic load_control,
    input logic [2 : 0] fun3,
    input logic [6 : 0] opcode,

    output logic Load,
    output logic Store,
    output logic Branch,
    output logic mem_en,
    output logic next_sel,
    output logic jalr_out,
    output logic reg_write,
    output logic operand_b,
    output logic operand_a,
    output logic [2 : 0] imm_sel,
    output logic [1 : 0] mem_to_reg,
    output logic [3 : 0] alu_control
);
    logic r_type;
    logic i_type; 
    logic load;
    logic store;
    logic branch; 
    logic jal;
    logic jalr;
    logic lui;
    logic auipc;

    /////////////////////////////////////////////////////////////////////////////////
    //--------------------------------TYPE DECODER-----------------------------------
    /////////////////////////////////////////////////////////////////////////////////
    always_comb begin
        r_type = 1'b0;
        i_type = 1'b0;
        store  = 1'b0;
        load   = 1'b0;
        branch = 1'b0;
        auipc  = 1'b0; 
        jal    = 1'b0; 
        jalr   = 1'b0; 
        lui    = 1'b0; 
        case(opcode)
            7'b0110011:begin 
                r_type = 1'b1;
            end 
            7'b0010011:begin 
                i_type = 1'b1;
            end
            7'b0100011:begin 
                store = 1'b1;
            end
            7'b0000011:begin
                if (valid | load_control) begin 
                    load = 1'b0;
                end
                else begin
                    load = 1'b1;
                end
            end
            7'b1100011:begin 
                branch = 1'b1;
            end
            7'b0010111:begin 
                auipc = 1'b1;
            end
            7'b1101111:begin 
                jal = 1'b1;
            end
            7'b1100111:begin 
                jalr = 1'b1;
            end
            7'b0110111:begin 
                lui = 1'b1;
            end
            default:begin 
                r_type = 1'b0;
                i_type = 1'b0;
                store  = 1'b0;
                load   = 1'b0;
                branch = 1'b0;
                auipc  = 1'b0;
                jal    = 1'b0; 
                jalr   = 1'b0; 
                lui    = 1'b0; 
            end
        endcase
    end
    /////////////////////////////////////////////////////////////////////////////////
    //------------------------------CONTROL DECODER----------------------------------
    /////////////////////////////////////////////////////////////////////////////////
    always_comb begin
        //reg write signal for register file
        reg_write = r_type | i_type | load | jal | jalr | lui | auipc | load_control;
        //operand a select for first input of alu
        operand_a = branch | jal | auipc;
        //operand b signal for second input of alu
        operand_b = i_type | load | store | branch | jal | jalr | lui | auipc;
        //load
        Load  = load;
        //store
        Store = store;
        //branch
        Branch =  branch;
        //selection for next address if any jump instrucion run
        next_sel = jal;
        jalr_out = jalr;
        //mem enable
        mem_en = store;

        if(r_type)begin //rtype
            mem_to_reg = 2'b00;
            if(fun3==3'b000 & fun7==0)begin
                alu_control = 4'b0000;
            end
            else if(fun3==3'b000 & fun7==1)begin
                alu_control = 4'b0001;
            end
            else if (fun3==3'b001 & fun7==0)begin
                alu_control = 4'b0010;
            end
            else if (fun3==3'b010 & fun7==0)begin
                alu_control = 4'b0011;
            end
            else if (fun3==3'b011 & fun7==0)begin
                alu_control = 4'b0100;
            end
            else if (fun3==3'b100 & fun7==0)begin
                alu_control = 4'b0101;
            end
            else if (fun3==3'b101 & fun7==0)begin
                alu_control = 4'b0110;
            end
            else if (fun3==3'b101 & fun7==1)begin
                alu_control = 4'b0111;
            end
            else if (fun3==3'b110 & fun7==0)begin
                alu_control = 4'b1000;
            end
            else if (fun3==3'b111 & fun7==0)begin
                alu_control = 4'b1001;
            end
        end
        else if (i_type)begin //itype
            imm_sel = 3'b000; //i_type selection
            mem_to_reg = 2'b00;
            if(fun3==3'b000 & fun7==0)begin
                alu_control = 4'b0000;
            end
            else if (fun3==3'b001 & fun7==0)begin
                alu_control = 4'b0010;
            end
            else if (fun3==3'b010 & fun7==0)begin
                alu_control = 4'b0011;
            end
            else if (fun3==3'b011 & fun7==0)begin
                alu_control = 4'b0100;
            end
            else if (fun3==3'b100 & fun7==0)begin
                alu_control = 4'b0101;
            end
            else if (fun3==3'b101 & fun7==0)begin
                alu_control = 4'b0110;
            end
            else if (fun3==3'b101 & fun7==1)begin
                alu_control = 4'b0111;
            end
            else if (fun3==3'b110 & fun7==0)begin
                alu_control = 4'b1000;
            end
            else if (fun3==3'b111 & fun7==0)begin
                alu_control = 4'b1001;
            end
        end
        else if (store) begin //store
            imm_sel = 3'b001; //store selection
            mem_to_reg = 2'b00;
            if (fun3==3'b000)begin //sb
                alu_control = 4'b0000;
                //signal = 2'b00;
            end
            else if (fun3==3'b001)begin //sh
                alu_control = 4'b0000;
                //signal = 2'b01;
            end
            else if (fun3==3'b010)begin //sw
                alu_control = 4'b0000;
                //signal = 2'b10;
            end
        end
        else if (load) begin
            imm_sel = 3'b000; //i_type selection
            mem_to_reg = 2'b01;
            if (fun3==3'b000)begin //lb
                alu_control = 4'b0000;
            end
            else if(fun3==3'b001)begin //lh
                alu_control = 4'b0000;
            end
            else if(fun3==3'b010)begin //lw
                alu_control = 4'b0000;
            end
            else if(fun3==3'b100)begin //lbu
                alu_control = 4'b0000;
            end
            else if(fun3==3'b101)begin //lhu
                alu_control = 4'b0000;
            end
            else if(fun3==3'b110)begin //lwu
                alu_control = 4'b0000;
            end
        end
        else if (branch)begin
            alu_control = 4'b0000;
            mem_to_reg = 2'b00;
            imm_sel = 3'b010; //branch selection
        end
        else if (jal)begin
            alu_control = 4'b0000;
            mem_to_reg = 2'b10;
            imm_sel = 3'b011; //jal selection
        end
        if(jalr)begin
            mem_to_reg = 2'b00;
            alu_control = 4'b0000;
            imm_sel = 3'b000;//i_type selection
        end
        else if(lui)begin
            mem_to_reg = 2'b00;
            imm_sel = 3'b100;//u_type selection
            alu_control = 4'b1111;
        end
        else if(auipc)begin
            mem_to_reg = 2'b00;
            alu_control = 4'b0000;
            imm_sel = 3'b100;//u_type selection
        end
    end
endmodule