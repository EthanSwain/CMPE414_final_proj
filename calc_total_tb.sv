module calc_total_tb;
parameter POPSIZE = 100;
parameter WINSIZE = 200;
parameter FRAME_SIZE = 20;
parameter DATA_WIDTH = 8;
parameter scale_factor = 'h017C;
logic clk;
logic rst;
logic data_rdy;
logic [DATA_WIDTH -1:0] data_in;
logic new_data;
logic rd_from_chi;

logic rd_rqst;
logic [$clog2(POPSIZE)-1:0] addr_out;
logic data_vld;
logic [$clog2(POPSIZE):0] bin_out;
logic calc_done;
 logic [DATA_WIDTH-1:0] data_out;
  int edge_nums[100];
    logic data_rdy_REG;
  logic data_vld_REG;
  
  
calc_total #(.WINSIZE(WINSIZE),.scale_factor(scale_factor),.POPSIZE(POPSIZE),.DATA_WIDTH(DATA_WIDTH))
dut_0(
    .clk(clk),
    .rst(rst),
    .data_rdy(data_vld_REG),
    .data_in(data_out),
    .new_data(new_data),
    .rd_from_chi(rd_from_chi),
    .rd_rqst(rd_rqst),
    .addr_out(addr_out),
    .data_vld(data_vld),
    .bin_out(bin_out),
    .calc_done(calc_done)
);


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
    rst = 1'b1;
    data_in = 'b0;
    data_rdy_REG = 1'b0;
    #20;
    rst = 1'b0;

    // Wait for a few clock cycles
    #20;

    // Load edge_nums into reg_file
    edge_nums = '{41, 40, 40, 39, 38, 43, 39, 70, 48, 51, 54, 53, 52, 46, 45, 43, 48, 48, 47, 43, 54, 49, 49, 48, 50, 45, 47, 54, 47, 51, 52, 54, 56, 57, 52, 41, 47, 47, 46, 50, 49, 53, 78, 52, 47, 41, 41, 43, 46, 43, 43, 43, 46, 42, 40, 42, 44, 42, 41, 41, 48, 52, 56, 50, 49, 54, 54, 54, 37, 74, 59, 68, 62, 71, 64, 59, 59, 49, 50, 50, 49, 50, 50, 44, 49, 45, 78, 47, 41, 35, 35, 40, 33, 34, 37, 37, 38, 37, 37, 37};

    for (int i = 0; i < (POPSIZE); i++) begin
      for (int j = 0; j < 4; j++) begin
        @(posedge clk);
        if (j == 0) begin
          data_in = edge_nums[i];
          data_rdy_REG = 1'b1;
        end else begin
          data_rdy_REG = 1'b0;
          repeat(12) @(posedge clk);
        end
      end
    end

    // Wait for a few clock cycles
    #20;

    // Assert opp_rdy to start the generation state

    // Wait for calc_done signal
    wait(calc_done);

    // Assert rd_rqst to read the bins
    for (int i = 0; i < 6; i++) begin
      @(posedge clk);
      rd_rqst = 1'b1;
      @(posedge clk);
      rd_rqst = 1'b0;
      $display("Bin[%0d] = %0d", i, bin_out);
    end

    // Finish simulation
    #20;
    $finish;
  end


endmodule