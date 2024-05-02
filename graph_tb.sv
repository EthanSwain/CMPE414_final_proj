module graph_tb;

  parameter POPSIZE = 100;
  parameter WINSIZE = 6;
  parameter DATA_WIDTH = 8;
  parameter ID_WIDTH = 11;

  logic clk;
  logic rst;
  logic [ID_WIDTH-1:0] ID_in;
  logic data_rdy;
  logic data_vld;
  logic [DATA_WIDTH-1:0] num_edges;

  // Instantiate the graph module
  graph #(
    .POPSIZE(POPSIZE),
    .WINSIZE(WINSIZE),
    .DATA_WIDTH(DATA_WIDTH),
    .ID_WIDTH(ID_WIDTH)
  ) dut (
    .clk(clk),
    .rst(rst),
    .ID_in(ID_in),
    .data_rdy(data_rdy),
    .data_vld(data_vld),
    .num_edges(num_edges)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Stimulus
  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    ID_in = 0;
    data_rdy = 0;

    // Reset the module
    #10 rst = 0;

    // Test case 1: Insert edges
    @(posedge clk);
    ID_in = 11'h001;
    data_rdy = 1;
    @(posedge clk);
    data_rdy = 0;
    repeat(10)@(posedge clk);
    @(posedge clk);
    ID_in = 11'h002;
    data_rdy = 1;
    @(posedge clk);
    data_rdy = 0;
    repeat(10)@(posedge clk);
    @(posedge clk);
    ID_in = 11'h003;
    data_rdy = 1;
    @(posedge clk);
    data_rdy = 0;
    repeat(10)@(posedge clk);
    @(posedge clk);
    data_rdy = 0;
     repeat(10)@(posedge clk);
    @(posedge clk);
    repeat(10) @(posedge clk);
    ID_in = 11'h001;
    data_rdy = 1;
    @(posedge clk);
    data_rdy = 0;
    repeat(10)@(posedge clk);
    @(posedge clk);
    ID_in = 11'h002;
    data_rdy = 1;
    @(posedge clk);
    data_rdy = 0;
     repeat(10)@(posedge clk);
    @(posedge clk);
    ID_in = 11'h002;
    data_rdy = 1;
    @(posedge clk);
    data_rdy = 0;
    // Check the number of edges
    if (num_edges !== 3) begin
      $error("Test case 1 failed: Expected 3 edges, got %0d", num_edges);
    end else begin
      $display("Test case 1 passed");
    end

    // Add more test cases as needed

    // Finish the simulation
    $finish;
  end

  // Monitor the outputs
  always @(posedge clk) begin
    if (data_vld) begin
      $display("Number of edges: %0d", num_edges);
    end
  end

endmodule