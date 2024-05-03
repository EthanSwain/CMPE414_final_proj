module dist_gen #(POPSIZE = 100,WINSIZE = 200)(
    input logic clk,
    input logic rst,
    input logic [$clog2(WINSIZE)-1:0] num_edges,
    input logic opp_rdy,
    input logic data_rdy,
    input logic [7:0]  median,
    input logic [15:0] MAD,
    input logic [$clog2(POPSIZE)-1:0] counttillmean,
    input logic rd_rqst,

    output logic [$clog2(POPSIZE)-1:0] rd_addr,
    output logic [$clog2(POPSIZE)-1:0] bin_out,
    output logic calc_done,
    output logic data_vld,
    output logic rd_en
);



logic [$clog2(POPSIZE)-1:0] bins_k [0:5];

logic data_vld_d;
logic data_vld_q;
logic calc_done_d;
logic calc_done_q;
logic [$clog2(POPSIZE)-1:0]bin_out_q;
logic [$clog2(POPSIZE)-1:0]bin_out_d;
logic [$clog2(POPSIZE)-1:0]rd_addr_q;
logic [$clog2(POPSIZE)-1:0]rd_addr_d;
logic [15:0]median_intr_d;
logic [15:0]median_intr_q;
logic [15:0]MAD_intr_d;
logic [15:0]MAD_intr_q;
logic [$clog2(POPSIZE)-1:0] counttillmean_intr_d;
logic [$clog2(POPSIZE)-1:0] counttillmean_intr_q;
logic [2:0]rd_counter_d;
logic [2:0]rd_counter_q;
logic rd_en_d;
logic rd_en_q;
logic [15:0] num_edge_intr;



 logic [15:0] bin0;
  logic [15:0] bin1;
  logic [15:0] bin2;
  logic [15:0] bin3;
  logic [15:0] bin4;
  logic [15:0] bin5;

  
  
  assign bin0 = (median_intr_q + ('h0001 * MAD_intr_q));
  assign bin1 = (median_intr_q - ('h0001 * MAD_intr_q));
  assign bin2 = (median_intr_q + ('h0002 * MAD_intr_q));
  assign bin3 = (median_intr_q - ('h0002 * MAD_intr_q));
  assign bin4 = (median_intr_q + ('h0003 * MAD_intr_q));
  assign bin5 = (median_intr_q - ('h0003 * MAD_intr_q));




assign num_edge_intr[7:0] = 'b0;
assign num_edge_intr[15:8] = num_edges;
assign data_vld = data_vld_q;
assign bin_out = bin_out_q;
assign rd_addr = rd_addr_q;
assign calc_done = calc_done_q;
assign rd_en = rd_en_q;

enum {idle_state,gen_state,send_state} curr_state,next_state;

always_ff@(posedge clk or posedge rst)begin
    if(rst)begin
        curr_state <= idle_state;
        data_vld_q <= 'b0;
        bin_out_q <= 'b0;
        rd_addr_q <='b0;
        median_intr_q <= 'b0;
        MAD_intr_q <='b0;
        counttillmean_intr_q <= 'b0;
        calc_done_q <= 'b0;
        rd_counter_q <= 'b0;
        bins_k[0] <= 'b0;
        bins_k[1] <= 'b0;
        bins_k[2] <= 'b0;
        bins_k[3] <= 'b0;
        bins_k[4] <= 'b0;
        bins_k[5] <= 'b0;
        rd_en_q <= 'b0;
    end else begin
        curr_state <= next_state;
        data_vld_q <= data_vld_d;
        bin_out_q <= bin_out_d;
        rd_addr_q <= rd_addr_d;
        median_intr_q <=  median_intr_d;
        MAD_intr_q <= MAD_intr_d;
        counttillmean_intr_q <= counttillmean_intr_d;
        calc_done_q <= calc_done_d;
        rd_counter_q <= rd_counter_d;
        rd_en_q <= rd_en_d;
    end
end

always_comb begin
    bin_out_d = bin_out_q;
    rd_addr_d = rd_addr_q;
    median_intr_d = median_intr_q;
    MAD_intr_d = MAD_intr_q;
    next_state = curr_state;
    data_vld_d = 'b0;
    calc_done_d = 'b0;
    rd_counter_d = rd_counter_q;
    rd_en_d = 'b0;
    counttillmean_intr_d = counttillmean_intr_q;
    case(curr_state)
        idle_state: begin
            bins_k[0] = 'b0;
            bins_k[1] = 'b0;
            bins_k[2] = 'b0;
            bins_k[3] = 'b0;
            bins_k[4] = 'b0;
            bins_k[5] = 'b0;
            rd_counter_d = 'b0;
            if(opp_rdy) begin
                rd_addr_d = 'b0;
                next_state = gen_state;
                median_intr_d[15:8] = median;
                MAD_intr_d = MAD;
                counttillmean_intr_d  = counttillmean;
            end
        end
        gen_state: begin
            rd_en_d = 'b1;
            if(data_rdy)begin
                rd_addr_d = rd_addr_q +1;
                if(num_edges < bin0[15:8]) begin
                    bins_k[0] = bins_k[0] +1;
                end

                if(num_edge_intr < (median_intr_q - MAD_intr_q)) begin
                    bins_k[1] = bins_k[1] +1;
                end
                if(num_edge_intr < (median_intr_q + ('h0002 * MAD_intr_q))) begin
                    bins_k[2] = bins_k[2] +1;
                end 
                if(num_edge_intr < (median_intr_q - ('h0002 * MAD_intr_q))) begin
                    bins_k[3] = bins_k[3] + 1;
                end
                if(num_edge_intr <(median_intr_q + ('h0003 * MAD_intr_q))) begin
                    bins_k[4] = bins_k[4] + 1;
                end

                if(num_edge_intr < (median_intr_q - ('h0003 * MAD_intr_q))) begin
                    bins_k[5] = bins_k[5] +1;
                end
            end
            if(rd_addr_q == POPSIZE -1) begin
                next_state = send_state;
                rd_addr_d = 'b0;
                calc_done_d = 'b1;
            end
        end 
        send_state: begin
            if(rd_rqst) begin
                data_vld_d = 'b1;
                rd_counter_d = rd_counter_q +1;
                if(bins_k[rd_counter_q] >= counttillmean_intr_q) begin
                    bin_out_d = bins_k[rd_counter_q] - counttillmean_intr_q;
                end else begin
                    bin_out_d = counttillmean_intr_q - bins_k[rd_counter_q];
                end
            end
            if(rd_counter_q == 'd6) begin
                next_state = idle_state;
            end

        end
    endcase
end

endmodule