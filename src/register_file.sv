module register_file #(
    parameter DataWidth  = 32,
    parameter RegAddress = 5
    )
    (
        input logic clk,
        input logic rst,
        input logic write_enale,
        input logic [RegAddress-1 : 0] source1,
        input logic [RegAddress-1 : 0] source2,
        input logic [RegAddress-1 : 0] writedata_add,
        input logic [DataWidth-1  : 0] write_data,

        output logic [DataWidth-1 : 0] readdata1,
        output logic [DataWidth-1 : 0] readdata2
    );

    localparam number_of_registers = 32;

    logic [DataWidth-1 : 0] RegFile [number_of_registers-1 : 0];

    integer i;
    always_ff @( posedge clk or negedge rst ) begin
        if (!rst) begin
            for (i=0 ; i < number_of_registers ; i++)
                RegFile[i] <= 0;
        end
        else if (write_enale) begin
            if(writedata_add == 5'd0)
                RegFile[0] <= 32'h00000000;
            else
                RegFile[writedata_add] <= write_data;
        end
    end

    assign readdata1 = RegFile[source1];
    assign readdata1 = RegFile[source2];
endmodule