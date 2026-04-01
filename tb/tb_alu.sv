/////////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Design Name:
// Module Name: tb_alu
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
/////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

module alu_tb;

    logic [4:0]  i_alu_control;
    logic [31:0] i_alu_srcA;
    logic [31:0] i_alu_srcB;
    logic [31:0] o_alu_result;
    logic        o_zero;

    alu DUT_ALU (
        .i_alu_control(i_alu_control),
        .i_alu_srcA(i_alu_srcA),
        .i_alu_srcB(i_alu_srcB),
        .o_alu_result(o_alu_result),
        .o_zero(o_zero)
    );

    task display_result;
        begin
            #1 $display("Time: %3t | i_alu_control: %2d | i_alu_srcA: %8h | i_alu_srcB: %8h | o_alu_result: %8h | zero: %0b",
                $time, i_alu_control, i_alu_srcA, i_alu_srcB, o_alu_result, o_zero);
        end
    endtask

    initial begin

        $display("--- Testing all ALU modes sequentially ---");
        for (int i=0; i<=31; i++) begin
            i_alu_control = i;
            i_alu_srcA = $urandom();
            i_alu_srcB = $urandom();
            display_result();
        end

        $display("--- Testing ALU modes randomly ---");
        repeat(32) begin
            i_alu_control = $urandom_range(0, 17);
            i_alu_srcA = $urandom();
            i_alu_srcB = $urandom();
            display_result();
        end

        $display("\nAll tests completed.");
        $finish;
    end

    initial begin
        $dumpfile("waveform_tb_alu.vcd");
        $dumpvars(0, alu_tb);
    end

endmodule

