module median_calc #(parameter POPSIZE = 100,DATA_WIDTH = 8)(
    input logic clk,
    input logic rst,
    input logic [DATA_WIDTH-1:0] data_in,
    input logic data_rdy,

    output [DATA_WIDTH-1:0] median,
    output data_vld

);

logic [DATA_WIDTH-1:0] data_out_array[POPSIZE:0];
logic GT_array[POPSIZE:0];
logic [$clog2(POPSIZE):0] counter_d;
logic [$clog2(POPSIZE):0] counter_q;
logic [DATA_WIDTH-1:0] median_d;
logic [DATA_WIDTH-1:0] median_q;
logic data_vld_q;
logic data_vld_d;
logic reg_rst;
logic [DATA_WIDTH-1:0] data_in_d;
logic [DATA_WIDTH-1:0] data_in_q;
logic data_rdy_d;
logic data_rdy_q;
logic reg_rst_d;
logic reg_rst_q;

assign reg_rst = reg_rst_q;

assign data_rdy_d = data_rdy;
assign data_in_d = data_in;
assign GT_array[POPSIZE] = 0;
assign data_vld = data_vld_q;
assign median = median_q;


genvar i;

generate
  for (i = 0; i < POPSIZE; i++) begin : instance_gen
    if (i == 0) begin
      sort_reg #(
        .DATA_WIDTH(DATA_WIDTH)
      ) instance_0 (
        .clk(clk),
        .rst(rst || reg_rst),
        .GT_in(1'b0),
        .data_in(data_in),
        .prev_data('b0),
        .data_out(data_out_array[0]),
        .GT(GT_array[0]),
        .data_rdy(data_rdy)
      );
    end else begin
      // Subsequent instances
      sort_reg #(
        .DATA_WIDTH(DATA_WIDTH)
      ) instance_i (
        .clk(clk),
        .rst(rst || reg_rst),
        .GT_in(GT_array[i-1]), // Connect GT_in to the previous instance's GT output
        .data_in(data_in),
        .prev_data(data_out_array[i-1]), // Connect prev_data to the previous instance's data_out
        .data_out(data_out_array[i]),
        .GT(GT_array[i]),
        .data_rdy(data_rdy)
      );
    end
  end
endgenerate

always_ff@(negedge clk or posedge rst)begin
    if(rst)begin
        counter_q <= 'b0;
        median_q <= 'b0;
        data_vld_q <= 'b0;
        data_in_q <= 'b0;
        data_rdy_q <='b0;
        reg_rst_q <= 'b0;
    
    end else begin
        data_in_q <=data_in_d;
        data_rdy_q <=data_rdy_d;
        counter_q <= counter_d;
        median_q <= median_d;
        data_vld_q <= data_vld_d;
        reg_rst_q <= reg_rst_d;
    end
end

always_comb begin
    reg_rst_d = 'b0;
        data_vld_d = 'b0;
        counter_d = counter_q;
        median_d = median_q;

        if (counter_q == POPSIZE) begin
            median_d = (POPSIZE % 2 == 0) ? data_out_array[POPSIZE/2 - 1] : data_out_array[POPSIZE/2];
            reg_rst_d = 'b1;
            data_vld_d = 'b1;
            counter_d = 'b0;
        end else if(counter_q == 0) begin
            reg_rst_d ='b0;
        end
        
        if (data_rdy) begin
            counter_d = counter_q + 1;
        end
    end


endmodule