`timescale 1ns / 1ps

module MADcalc_tb();

  // Parameters
  parameter scale_factor = 'h017C;
  parameter POPSIZE = 10;
  parameter DATA_WIDTH = 8;
  parameter FRAME_SIZE = 3;

  // Inputs
  logic clk;
  logic rst;
  logic [DATA_WIDTH-1:0] data_in;
  logic data_rdy;

  // Outputs
  logic data_vld_MAD;
  logic data_vld_REG;
  logic data_rdy_MAD;
  logic data_rdy_REG;
  logic rd_rqst;
  logic [15:0] local_median;
  logic [15:0] MAD;
  logic [$clog2(POPSIZE)-1:0] addr_out;
  logic new_data;
  logic [DATA_WIDTH-1:0] data_out;
  logic [$clog2(POPSIZE)-1:0] counttillmean;

  // Instantiate the MADcalc module
  MADcalc #(
    .scale_factor(scale_factor),
    .POPSIZE(POPSIZE),
    .DATA_WIDTH(DATA_WIDTH)
  ) mad_calc (
    .clk(clk),
    .rst(rst),
    .data_in(data_out),
    .data_rdy(data_vld_REG),
    .new_data(new_data),
    .data_vld(data_vld_MAD),
    .rd_rqst(rd_rqst),
    .local_median(local_median),
    .MAD(MAD),
    .addr_out(addr_out),
    .counttillmean(countillmean)
  );

  // Instantiate the reg_file module
  reg_file #(
    .POPSIZE(POPSIZE),
    .FRAME_SIZE(FRAME_SIZE),
    .DATA_WIDTH(DATA_WIDTH)
  ) reg_file_inst (
    .clk(clk),
    .rst(rst),
    .read_addr(addr_out),
    .data_in(data_in),
    .data_rdy(data_rdy_REG),
    .rd_rqst(rd_rqst),
    .new_data(new_data),
    .data_vld(data_vld_REG),
    .data_out(data_out)
  );

  // Clock generation
  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end

  // Stimulus
  initial begin
    // Reset
    rst = 1'b1;
    data_in = 'b0;
    data_rdy_REG = 1'b0;
    #20;
    rst = 1'b0;

    // Write data to reg_file every 4 clock cycles
    for (int i = 0; i < (POPSIZE * 5); i++) begin
      for (int j = 0; j < 4; j++) begin
        @(posedge clk);
        if (j == 0) begin
          data_in = $urandom_range(0, 255);
          data_rdy_REG = 1'b1;
        end else begin
          data_rdy_REG = 1'b0;
          repeat(12) @(posedge clk);
        end
      end
    end

    // Wait for MADcalc to finish processing
    wait(data_vld_MAD);

    // Check the results
    $display("Local Median: %d", local_median);
    $display("MAD: %d", MAD);

    // Finish simulation
    #20;
    $finish;
  end

endmodule