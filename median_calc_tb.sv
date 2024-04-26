`timescale 1ns / 1ps


module median_calc_tb();


    logic clk;
    logic rst =0;
    logic [7:0]data_in;
    logic data_rdy =0 ;
    logic [7:0] data_in;
    logic [7:0] median;
    logic data_vld;
    int i;
    
    
    median_calc #(
       .POPSIZE(100),
       .DATA_WIDTH(8)
    )
    dut(
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_rdy(data_rdy),
        .median(median),
        .data_vld(data_vld)
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
        for(i =0;i<100;i++) begin
           repeat(2) @(posedge clk);
           data_in = $random;
           $display("The value of data_in is: %h itr %d", data_in,i);
           if(i == 99)begin
           $display("100 times");
           end
           data_rdy = 1;
           @(posedge clk);
           data_rdy = 0;
        end
    end

endmodule