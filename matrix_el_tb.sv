`timescale 1ns / 1ps

module matrix_el_tb;

  parameter WINSIZE = 200;
  parameter POPSIZE = 100;
  parameter ID_WIDTH = 11;

  logic clk;
  logic rst;
  logic [ID_WIDTH-1:0] edge_in;
  logic data_rdy_in;
  logic edge_rdy;
  logic [$clog2(WINSIZE)-1:0] edge_addr;
  logic [ID_WIDTH-1:0] data_out;
  logic is_equal;
  logic has_edge;

  // Instantiate the module under test
  matrix_el #(
    .WINSIZE(WINSIZE),
    .POPSIZE(POPSIZE),
    .ID_WIDTH(ID_WIDTH)
  ) dut (
    .clk(clk),
    .rst(rst),
    .edge_in(edge_in),
    .data_rdy_in(data_rdy_in),
    .edge_rdy(edge_rdy),
    .edge_addr(edge_addr),
    .data_out(data_out),
    .is_equal(is_equal),
    .has_edge(has_edge)
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
    edge_in = 11'b0;
    data_rdy_in = 1'b0;
    edge_rdy = 1'b0;
    edge_addr = 'b1;

    // Reset the module
    #10;
    rst = 1'b0;
    #10

    // Test case 1: Provide data and check equality
    @(posedge clk);
    edge_in = 11'h123;
    edge_rdy = 1'b1;
    @(posedge clk);
    edge_rdy = 1'b0;
    @(posedge clk);
    assert(is_equal === 1'b1) else $error("Test case 1 failed: is_equal should be 1");

    // Test case 2: Provide different data and check inequality
    @(posedge clk);
    edge_in = 11'h456;
    edge_addr = 'h0a;
    data_rdy_in = 1'b1;
    @(posedge clk);
    data_rdy_in = 1'b0;
    @(posedge clk);
    assert(is_equal === 1'b0) else $error("Test case 2 failed: is_equal should be 0");

    // Test case 3: Set edge_rdy and check has_edge
   // @(posedge clk);
   // edge_addr = 10;
   // edge_rdy = 1'b1;
   // @(posedge clk);
   // edge_rdy = 1'b0;
   // @(posedge clk);
   // assert(has_edge === 1'b1) else $error("Test case 3 failed: has_edge should be 1");

    // Add more test cases as needed

    // Finish the simulation
    #10;
    $finish;
  end

endmodule