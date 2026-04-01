/////////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Design Name:
// Module Name: tb_instruction_memory
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

module tb_instruction_memory;

    logic [31:0]    i_addr;
    logic [31:0]    o_rdata;

    instruction_memory DUT_INSTRUCTION_MEMORY (
        .i_addr(i_addr),
        .o_rdata(o_rdata)
    );

    task display_result;
        begin
            #1 $display("Time: %4t | i_addr: %8h | o_rdata: %8h = %4b_%4b_%4b_%4b_%4b_%4b_%4b_%4b",
                $time, i_addr, o_rdata,
                o_rdata[31:28], o_rdata[27:24], o_rdata[23:20], o_rdata[19:16],
                o_rdata[15:12], o_rdata[11:8], o_rdata[7:4], o_rdata[3:0]);
        end
    endtask

    initial begin

        $display("--- Writing data in memory ---");
        for (int i=0; i<260; i++) begin
            #1 i_addr = i;
            display_result();
        end

        $display("--- Reading data from memory at random slots ---");
        repeat(30) begin
            #1 i_addr = $urandom_range(0, 260);
            display_result();
        end

        $display("\nAll tests completed.");
        $finish;
    end

    initial begin
        $dumpfile("waveform_tb_instruction_memory.vcd");
        $dumpvars(0, tb_instruction_memory);
    end

endmodule

