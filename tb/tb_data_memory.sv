/////////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Design Name:
// Module Name: tb_data_memory
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

module tb_data_memory;

    logic           clk;
    logic           rst_n;
    logic           i_we;
    logic [31:0]    i_addr;
    logic [31:0]    i_wdata;
    logic [31:0]    o_rdata;

    data_memory DUT_DATA_MEM (
        .clk(clk),
        .rst_n(rst_n),
        .i_we(i_we),
        .i_addr(i_addr),
        .i_wdata(i_wdata),
        .o_rdata(o_rdata)
    );

    always begin
        #1 clk=1'b1; #1 clk=1'b0;
    end

    task display_result;
        begin
            #1 display("Time: %4t | rst_n:: %0b | i_we: %0b | i_addr: %8h | i_wdata: %8h | o_rdata: %8h,
                $time, rst_n, i_we, i_addr, i_wdata, o_rdata);
        end
    endtask

    initial begin

        $display("--- Resetting the memory ---");
        repeat(5) @(posedge clk) begin
            rst_n = 1'b0;
        end

        $display("--- Writing data in memory ---");
        for (int i=0; i<130; i++) begin
            @(posedge clk);
            rst_n = 1'b1;
            i_we = 1'b1;
            i_addr = i;
            i_wdata = $urandom_range(32'h0, 32'hffff_ffff);
            display_result();
        end

        $display("--- Reading data from memory at random slots ---");
        repeat (30) @(posedge clk);
            rst_n = 1'b1;
            i_we = 1'b0;
            i_addr = $urandom_range(32'h0, 32'h0000_00ff);
            display_result();
        end

        $display("\nAll tests completed.");
        $finish;
    end

    initial begin
        $dumpfile("waveform_tb_data_memory.vcd");
        $dumpvars(0, tb_data_memory);
    end

endmodule

