`timescale 1ns/1ps

module reg_file_tb;

  parameter POPSIZE = 100;
  parameter FRAME_SIZE = 20;
  parameter DATA_WIDTH = 8;
  
  logic clk;
  logic rst;
  logic [$clog2(POPSIZE)-1:0] read_addr;
  logic [DATA_WIDTH-1:0] data_in;
  logic data_rdy;
  logic rd_rqst;
  logic new_data;
  logic data_vld;
  logic [DATA_WIDTH-1:0] data_out;
  
  reg_file #(
    .POPSIZE(POPSIZE),
    .FRAME_SIZE(FRAME_SIZE),
    .DATA_WIDTH(DATA_WIDTH)
  ) dut (
    .clk(clk),
    .rst(rst),
    .read_addr(read_addr),
    .data_in(data_in),
    .data_rdy(data_rdy),
    .rd_rqst(rd_rqst),
    .new_data(new_data),
    .data_vld(data_vld),
    .data_out(data_out)
  );
  
  // Clock generation
  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end
  
  // Reset generation
  initial begin
    rst = 1'b1;
    #20;
    rst = 1'b0;
  end
  
  // Stimulus
  initial begin
    data_rdy = 1'b0;
    read_addr = 0;
    rd_rqst = 1'b0;
    
    // Wait for reset to complete
    @(negedge rst);
    
    // Write random data into incremental addresses
    for (int i = 0; i < POPSIZE + FRAME_SIZE * 4; i++) begin
      @(posedge clk);
      data_rdy = 1'b1;
      data_in = $random;
      @(posedge clk);
      data_rdy = 1'b0;
    end
    
    // Stop writing data
    @(posedge clk);
    data_rdy = 1'b0;
    
    // Perform read requests
    for (int i = 0; i < POPSIZE; i++) begin
      @(posedge clk);
      read_addr = i;
      rd_rqst = 1'b1;
      @(posedge clk);
      rd_rqst = 1'b0;
      $display("Read data from address %0d: %0d", read_addr, data_out);
    end
    
    // End simulation
    $finish;
  end

endmodule