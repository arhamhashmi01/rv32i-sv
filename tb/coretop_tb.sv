`timescale 1ns/1ps
module coretop_tb();

     // Parameters
    parameter DataWidth  = 32;
    parameter RegAddress = 5;
    parameter Address    = 8;

    logic clk;
    logic rst;
    logic [31:0]instruction;
    logic [31:0] res_out;

    core_top #(
        .DataWidth (DataWidth),
        .RegAddress(RegAddress),
        .Address   (Address)
    )u_coretop
    (
        .clk(clk),
        .rst(rst),
        .instruction(instruction)
    );

    initial begin
        clk = 0;
        rst = 1;
        #10;
        rst=0;
        #10;

        rst = 1;
        #140;
        #200;

        $finish;       
    end

     initial begin
       $dumpfile("temp/core.vcd");
       $dumpvars(0,coretop_tb);
    end

    always begin
        #5 clk= ~clk;
    end
endmodule