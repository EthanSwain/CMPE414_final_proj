module MADcalc #(parameter scale_factor = 'h017C, POPSIZE =100,DATA_WIDTH = 8)(
    input logic clk,
    input logic rst,
    input logic[DATA_WIDTH -1:0] data_in,
    input logic data_rdy,
    input logic new_data,

    output logic data_vld,
    output logic rd_rqst,
    output logic [15:0]local_median,
    output logic [15:0]MAD,
    output logic [$clog2(POPSIZE)-1:0]addr_out,
    output logic [$clog2(POPSIZE)-1:0] counttillmean


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
logic [$clog2(POPSIZE)-1:0] counttillmean_d;
logic [$clog2(POPSIZE)-1:0] counttillmean_q;

assign data_vld = data_vld_q;
assign MAD = MAD_q;
assign local_median = local_median_q;
assign addr_out = addr_out_q;
assign rd_rqst = rd_rqst_q;
assign counttillmean = counttillmean_q;

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


always_ff@(negedge clk or posedge rst) begin 
    if(rst)begin
        curr_state <= idle_state;
        local_median_q <='b0;
        MAD_q <= 'b0;
        curr_op_q <='b1;
        addr_out_q <= 'b0;
        data_vld_q <='b0;
        rd_rqst_q <='b0;
        counttillmean_q <='b0;
    end else begin
        curr_state <= next_state;
        local_median_q <= local_median_d;
        MAD_q <= MAD_d;
        curr_op_q <= curr_op_d;
        addr_out_q <=addr_out_d;
        data_vld_q <= data_vld_d;
        rd_rqst_q <= rd_rqst_d;
        counttillmean_q <= counttillmean_d;
    end
end

always_comb begin
    local_median_d = local_median_q;
    MAD_d = MAD_q;
    curr_op_d = curr_op_q;
    addr_out_d = addr_out_q;
    data_vld_d = data_vld_q;
    rd_rqst_d = rd_rqst_q;
    next_state = curr_state;
    rd_rqst_d = 'b0;
    data_intr = 'b0;
    counttillmean_d = counttillmean_q;

    case(curr_state)
        idle_state: begin
            data_vld_d = 'b0;
            if(new_data)begin
                next_state = calc_median_state;
                addr_out_d = 'b0;
                counttillmean_d = 'b0;
            end
        end
        calc_median_state: begin

            data_intr = data_in;
            if(addr_out_q != POPSIZE) begin
                addr_out_d = addr_out_q +1;
                rd_rqst_d = 'b1;
            
            end else if(addr_out_q == POPSIZE) begin
                if(data_vld_calc)begin
                    addr_out_d = 'b0;
                    next_state = calc_dev_state;
                    local_median_d[15:8] = median;
                end
            end
        
        end
        calc_dev_state: begin 
        
            if(data_in >= local_median_q[15:8]) begin
                data_intr = data_in - local_median_q[15:8];
            end else begin
                data_intr = local_median_q[15:8] - data_in;
            end
            if(data_in < local_median_q[15:8]) begin
                counttillmean_d = counttillmean_q +1;
            end
            if(addr_out_q != POPSIZE) begin
                addr_out_d = addr_out_q +1;
                rd_rqst_d = 'b1;
            
            end else if(addr_out_q == POPSIZE ) begin
                if(data_vld_calc)begin
                    addr_out_d = 'b0;
                    next_state = calc_MAD_state;
                    //MAD_d[15:8] = median;
                    MAD_d[7:0] = median;
                end
            end

        end
        calc_MAD_state: begin
            MAD_d = MAD_q * scale_factor;
            data_vld_d = 'b1;
            next_state = idle_state;
        end
    
    endcase



end
endmodule