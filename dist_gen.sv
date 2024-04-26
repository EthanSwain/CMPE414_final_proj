module dist_gen #(parameter K1 = 318E, K2 = 25F2, k3 = 37EC,K4 = 2034,K5 = 3D8B,K6=1A25,POPSIZE = 100,WINSIZE = 200)(
    input logic clk,
    input logic rst,
    input logic [$clog2(WINSIZE):0] num_edges,
    input logic data_rdy

    output logic [7:0] rd_addr
    output logic wr_en;
    output logic [$clog2(WINSIZE):0] bin_out,
    output logic data_vld;
);

logic [7:0] K_bins_q [5:0];
logic [7:0] K_bins_d [5:0];
logic [$clog2(WINSIZE):0]num_edges_d;
logic [$clog2(WINSIZE):0]num_edges_q;
logic [7:0]rd_addr_d;
logic [7:0]rd_addr_q;
logic [$clog2(WINSIZE):0]bin_out_d;
logic [$clog2(WINSIZE):0]bin_out_q;
logic data_vld_d;
logic data_vld_q
logic [3:0]counter_d;
logic [3:0]counter_q;
logic wr_en_d;
logic wr_en_q;

assign num_edges_d = num_edges;
assign data_vld = data_vld_q;
assign rd_addr = rd_addr_q;
assing wr_en = wr_en_q;
assign data_vld = data_vld_q;

enum {idle_state,calc_state,send_state} curr_state next_state;
always_ff@(posedge clk or posedge rst)begin
    if(rst)begin
        curr_state <= idle_state;
        K_bins_q[0] <= 'b0;
        K_bins_q[1] <= 'b0;
        K_bins_q[2] <= 'b0;
        K_bins_q[3] <= 'b0;
        K_bins_q[4] <= 'b0;
        K_bins_q[5] <= 'b0;
        num_edges_q <= 'b0;
        rd_addr_q <= 'b0;
        bin_out_q <= 'b0;
        data_vld_q <= 'b0;
        counter_q <='b0;
        wr_en_q <= 'b0;
    end else begin
        curr_state <= next_state;
        K_bins_q[0] <= K_bins_d[0]
        K_bins_q[1] <= K_bins_d[1]
        K_bins_q[2] <= K_bins_d[2]
        K_bins_q[3] <= K_bins_d[3]
        K_bins_q[4] <= K_bins_d[4]
        K_bins_q[5] <= K_bins_d[5]
        num_edges_q <=num_edges_d;
        rd_addr_q <= rd_addr_d;
        bin_out_q <=  bin_out_d;
        data_vld_q <= data_vld_d;
        counter_q <= counter_d;
        wr_en_q <= wr_en_d;
    end
end


always_comb begin
        next_state =  curr_state;
        K_bins_d[0] = K_bins_q[0]
        K_bins_d[1] = K_bins_q[1]
        K_bins_d[2] = K_bins_q[2]
        K_bins_d[3] = K_bins_q[3]
        K_bins_d[4] = K_bins_q[4]
        K_bins_d[5] = K_bins_q[5]
        rd_addr_d = rd_addr_q;
        bin_out_d =  bin_out_q;
        data_vld_d = data_vld_q;
        counter_d = counter_q;
        wr_en_d = wr_en_q;


        case(curr_state) 
            idle_state: begin
                if(data_rdy){
                    next_state = calc_state;
                }
            end 
            calc_state: begin
                if(addra_out_q >= POPSIZE)begin
                    counter_d = 'b0;
                    addra_out_d = 'b0;
                    next_state = send_state;
                end else if(counter_q = 0) begin
                    counter_d = counter_q +1;
                    if(num_edges_q)
                end
            end
            send_state: begin
            end
        endcase



end

endmodule