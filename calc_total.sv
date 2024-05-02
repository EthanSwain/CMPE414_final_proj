module calc_total #(parameter WINSIZE=200,scale_factor = 'h017C,POPSIZE = 100, DATA_WIDTH = 8)(
    input logic clk,
    input logic rst,
    input logic data_rdy,
    input logic [DATA_WIDTH -1:0] data_in,
    input logic new_data,
    input logic rd_from_chi,

    output logic rd_rqst,
    output logic [$clog2(POPSIZE)-1:0] addr_out,
    output logic data_vld,
    output logic [$clog2(POPSIZE):0] bin_out,
    output logic calc_done

);



logic data_vld_MAD;
logic data_rdy_MAD;
logic rd_rqst_MAD;
logic rd_rqst_DIST;
logic [15:0] local_median;
logic [15:0] MAD;
logic [$clog2(POPSIZE)-1:0] addr_out_MAD;
logic [$clog2(POPSIZE)-1:0] counttillmean;
logic data_rdy_dist;
logic [$clog2(POPSIZE)-1:0]rd_addr_dist;
logic [7:0] counttillmean;

enum {MAD_state,dist_state} curr_state, next_state;



dist_gen #(.POPSIZE(POPSIZE),.WINSIZE(WINSIZE))
dist_gen_inst(
    .clk(clk),
    .rst(rst),
    .num_edges(data_in),
    .opp_rdy(data_vld_MAD),
    .data_rdy(data_rdy_dist),
    .median(local_median[15:8]),
    .MAD(MAD),
    .counttillmean(counttillmean),
    .rd_rqst(rd_from_chi),
    .rd_addr(rd_addr_dist),
    .bin_out(bin_out),
    .calc_done(calc_done),
    .data_vld(data_vld),
    .rd_en(rd_rqst_DIST)
);


MADcalc #(.scale_factor(scale_factor),.POPSIZE(POPSIZE),.DATA_WIDTH(DATA_WIDTH)) 
MADclac_inst(
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .data_rdy(data_rdy_MAD),
    .new_data(new_data),
    .data_vld(data_vld_MAD),
    .rd_rqst(rd_rqst_MAD),
    .local_median(local_median),
    .MAD(MAD),
    .addr_out(addr_out_MAD),
    .counttillmean(counttillmean)
);


always_ff@(posedge clk or posedge rst) begin
    if(rst)begin
        curr_state = MAD_state;
    end else begin
        curr_state = next_state;
    end
end


always_comb begin
    data_rdy_dist = 'b0;
    data_rdy_MAD = 'b0;
    next_state = curr_state;
    case(curr_state)
        MAD_state: begin
        if(data_vld_MAD)begin
            next_state = dist_state;
        end
            addr_out = addr_out_MAD;
            rd_rqst = rd_rqst_MAD;
            data_rdy_MAD = data_rdy;
        end
        dist_state: begin
        if(calc_done)begin
            next_state = MAD_state;
        end
            addr_out = rd_addr_dist;
            rd_rqst = rd_rqst_DIST;
            data_rdy_dist = data_rdy;
        end
    endcase


end

endmodule