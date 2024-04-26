`timescale 1ns / 1ps


module IDS_tb();


    logic clk;
    logic rst =0;
    logic [15:0]E_in;
    logic [15:0]O_in;
    logic data_rdy =0;
    logic is_attacked;
    
    wire [7:0]addra_out;
    wire [7:0]addrb_out;
    
    
    IDS dut(
        .clk(clk),
        .rst(rst),
        .E_in(E_in),
        .O_in(O_in),
        .data_rdy(data_rdy),
        .addra_out(addra_out),
        .addrb_out(addrb_out),
        .is_attacked(is_attacked)
    );
    
    blk_mem_gen_0 mem(
        .clka(clk),
        .addra(addra_out),
        .douta(E_in),
        .doutb(O_in),
        .clkb(clk),
        .addrb(addrb_out)
    );
    
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst =1;
        #50;
        rst = 0;
        #20;
        data_rdy = 1;
        #1000;
    end

endmodule