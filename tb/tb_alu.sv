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
            #1 display("Time: %0t | Op: %b | A: %h | B: %h | Res: %h | Zero: %b",
                $time, i_alu_control, i_alu_srcA, i_alu_srcB, o_alu_result, o_zero);
        end
    endtask

    initial begin
        // testing all modes
        $display("--- Starting ALU Sequential Test ---");
        for (int i=0; i<=16; i++) begin
            i_alu_control = i[4:0];
            i_alu_srcA = $urandom_range(32'h0, 32'hffff_ffff);
            i_alu_srcB = $urandom_range(32'h0, 32'hffff_ffff);
            display_result();
        end

        $display("\n--- Starting ALU Random Test ---");

        // random test loop
        repeat(32) begin
            i_alu_control = $urandom_range(5'h0, 5'h1f);
            i_alu_srcA = $urandom_range(32'h0, 32'hffff_ffff);
            i_alu_srcB = $urandom_range(32'h0, 32'hffff_ffff);
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

