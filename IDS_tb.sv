`timescale 1ns / 1ps


module IDS_tb();
parameter POPSIZE = 100;
parameter WINSIZE = 200;
parameter FRAME_SIZE = 20;
parameter DATA_WIDTH = 8;
parameter scale_factor = 'h017C;
parameter DoF = 5;

    logic clk;
    logic rst;
    logic data_rdy;
    logic [DATA_WIDTH-1:0] data_in;
    int edge_nums[100];
    
    logic is_attacked;
    
    
    IDS #(.POPSIZE(POPSIZE),.WINSIZE(WINSIZE),.FRAME_SIZE(FRAME_SIZE),.DATA_WIDTH(DATA_WIDTH),.scale_factor(scale_factor),.DoF(DoF))
    dut(
        .clk(clk),
        .rst(rst),
        
        .data_rdy(data_rdy),
        .data_in(data_in),
        .is_attacked(is_attacked)
    );
    
    
    
    always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end

  // Stimulus
  initial begin
    rst = 1'b1;
    data_in = 'b0;
    data_rdy = 1'b0;
    #20;
    rst = 1'b0;

    // Wait for a few clock cycles
    #20;

    // Load edge_nums into reg_file
    //edge_nums = '{41, 40, 40, 39, 38, 43, 39, 70, 48, 51, 54, 53, 52, 46, 45, 43, 48, 48, 47, 43, 54, 49, 49, 48, 50, 45, 47, 54, 47, 51, 52, 54, 56, 57, 52, 41, 47, 47, 46, 50, 49, 53, 78, 52, 47, 41, 41, 43, 46, 43, 43, 43, 46, 42, 40, 42, 44, 42, 41, 41, 48, 52, 56, 50, 49, 54, 54, 54, 37, 74, 59, 68, 62, 71, 64, 59, 59, 49, 50, 50, 49, 50, 50, 44, 49, 45, 78, 47, 41, 35, 35, 40, 33, 34, 37, 37, 38, 37, 37, 37};
      edge_nums = '{45, 34, 36, 34, 50, 47, 43, 45, 33, 56, 44, 42, 38, 35, 43, 35, 39, 36, 43, 40, 42, 42, 44, 43, 46, 45, 48, 40, 45, 37, 37, 45, 47, 50, 44, 40, 42, 43, 43, 44, 39, 39, 39, 37, 41, 38, 35, 35, 40, 40, 41, 39, 44, 39, 41, 46, 42, 43, 42, 39, 45, 45, 50, 46, 43, 48, 46, 45, 47, 44, 47, 42, 39, 42, 36, 41, 44, 48, 45, 47, 50, 43, 48, 50, 44, 46, 57, 57, 50, 55, 50, 56, 51, 48, 39, 44, 44, 62, 47, 47};
    for (int i = 0; i < (POPSIZE); i++) begin
      for (int j = 0; j < 4; j++) begin
        @(posedge clk);
        if (j == 0) begin
          data_in = edge_nums[i];
          data_rdy = 1'b1;
        end else begin
          data_rdy = 1'b0;
          repeat(12) @(posedge clk);
        end
      end
    end

    // Wait for a few clock cycles
    #20;

    // Assert opp_rdy to start the generation state

    // Wait for calc_done signal

    // Assert rd_rqst to read the bins

    // Finish simulation
    #20;
    $finish;
  end

endmodule