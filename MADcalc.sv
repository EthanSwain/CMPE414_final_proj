module MADcalc #(parameter scale_factor = 'h017C, POPSIZE =100,DATA_WIDTH = 8)(
    input logic clk,
    input logic rst,
    input logic[DATA_WIDTH -1:0] data_in,
    input logic data_rdy,
    input logic new_data,

    output logic data_vld,
    output logic rd_rqst,
    output logic [15:0]local_median,
    output logic [15:0]MAD
    output logic [$clog2(POPSIZE)-1:0]addr_out;


);

logic [DATA_WIDTH-1:0]data_intr;
logic [15:0]local_median_d;
logic [15:0]local_median_q;
logic [15:0]MAD_d;
logic [15:0]MAD_q;
logic data_vld_calc;
logic data_vld_d;
logic data_vld_q;
logic [DATA_WIDTH-1:0]median;
logic curr_op_d;
logic curr_op_q;
logic [$clog2(POPSIZE)-1:0]addr_out_d;
logic [$clog2(POPSIZE)-1:0]addr_out_q;
logic rd_rqst_d;
logic rd_rqst_q;

assign data_vld = data_out_q;
assign MAD = MAD_q;
assign local_median = local_median_q;
assign addr_out = addr_out_q;

enum {idle_state,calc_median_state,calc_dev_state,calc_MAD_state} curr_state, next_state;
   median_calc #(
       .POPSIZE(POPSIZE),
       .DATA_WIDTH(DATA_WIDTH)
    )
    median_calc(
        .clk(clk),
        .rst(rst),
        .data_in(data_intr),
        .data_rdy(data_rdy),
        .median(median),
        .data_vld(data_vld_calc)
    );


always_ff@(posedge clk or posedge rst) begin 
    if(rst)begin
        curr_state <= idle_state;
        local_median_q <='b0;
        MAD_q <= 'b0;
        curr_op_q <='b1;
        addr_out_q <= 'b0;
        data_vld_q <='b0;
        rd_rqst_q <='b0;
    end else begin
        
        local_median_q <= local_median_d;
        MAD_q <= MAD_d;
        curr_op_q <= curr_op_d;
        addr_out_q <=addr_out_d;
        data_vld_q <= data_vld_d
        rd_rqst_q <= rd_rqst_d;
    end
end

always_comb begin
    local_median_d = local_median_q;
    MAD_d = MAD_q;
    curr_op_d = curr_op_q;
    addr_out_d = addr_out_q;
    data_vld_d = data_vld_q;
    rd_rqst_d = rd_rqst_q;

    if(data_vld_calc) begin
        curr_op_d = !curr_op_q;
        addr_out_d = 'b0;
    end

    else begin 
        if(new_data_q)begin 
            addr_out_d = 'b0;
        end else if(addr_out_q == POPSIZE-1) begin
            add
        end

        if(data_rdy)begin
            if(curr_op_q ==0) begin
                

            end else begin
            end
            addr_out_d = addr_out_q +1;
        end
    end
end
endmodule