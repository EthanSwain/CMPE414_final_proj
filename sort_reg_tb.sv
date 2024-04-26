`timescale 1ns / 1ps


module sort_reg_tb();


    logic clk;
    logic rst =0;
    logic [7:0]data_in;
    logic [7:0]data_out;
    logic [7:0]prev_data;
    logic GT_in;
    logic GT_out;
    

    assign GT_in = (data_in > prev_data);
    sort_reg dut(
        .clk(clk),
        .rst(rst),
        .GT_in(GT_in),
        .data_in(data_in),
        .prev_data(prev_data),
        .data_out(data_out),
        .GT(GT_out)

    );
    
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst =1;
        #50;
        rst = 0;
        data_in = 'hAA;
        prev_data = 'h0A;
        #50;
        data_in = 'h0B;
        prev_data = 'h11;
        #50;
        data_in = 'h5;
        prev_data = 'h4;
        #1000;
    end

endmodule