module reg_file #(parameter POPSIZE =100, FRAME_SIZE =20, DATA_WIDTH = 8)(
    input logic clk,
    input logic rst,
    input logic [$clog2(POPSIZE)-1:0] read_addr,
    input logic [DATA_WIDTH-1:0] data_in,
    input logic data_rdy,
    input logic rd_rqst,

    output logic new_data,
    output logic data_vld,
    output logic [DATA_WIDTH-1:0] data_out

);

logic [DATA_WIDTH-1:0] regs [0:(POPSIZE+FRAME_SIZE)-1];
logic [$clog2(FRAME_SIZE)-1:0]rd_offest_d;
logic [$clog2(FRAME_SIZE)-1:0]rd_offest_q;
logic [$clog2(POPSIZE+FRAME_SIZE)-1:0]wr_offset_q;
logic [$clog2(POPSIZE+FRAME_SIZE)-1:0]wr_offset_d;
logic init_q;
logic init_d;
logic [$clog2(POPSIZE)-1:0] counter_d;
logic [$clog2(POPSIZE)-1:0] counter_q;
logic new_data_q;
logic new_data_d;
logic data_vld_d;
logic data_vld_q;
logic [DATA_WIDTH-1:0] data_out_d;
logic [DATA_WIDTH-1:0] data_out_q;

assign data_out_d = regs[read_addr +rd_offest_q];
assign new_data = new_data_q;
assign data_out = data_out_q;
assign data_vld = data_vld_q;

always_ff@(posedge clk or posedge rst)begin
    if(rst)begin
        wr_offset_q <='b0;
        rd_offest_q <='b0;
        init_q <='b0;
        counter_q <= 'b0;
        data_vld_q <='b0;
        data_out_q <='b0;
        new_data_q <= 'b0;

    end else begin
        wr_offset_q <= wr_offset_d;
        rd_offest_q <= rd_offest_d;
        init_q <= init_d;
        counter_q <= counter_d;
        data_vld_q <= data_vld_d;
        data_out_q <= data_out_d;
        new_data_q <= new_data_d;
        
    end
end

always_comb begin
    new_data_d = 'b0;
    wr_offset_d = wr_offset_q;
    counter_d = counter_q;
    rd_offest_d = rd_offest_q;
    data_vld_d = 'b0;
    init_d = init_q;

    if(data_rdy)begin
        if(rd_rqst)begin
            data_vld_d = 'b1;
        end
        regs[wr_offset_q] = data_in;
        if(wr_offset_q == (POPSIZE + FRAME_SIZE -1))begin
            counter_d = 'b0;
            wr_offset_d = 'b0;
        end else begin
            wr_offset_d = wr_offset_q +1;
            counter_d = counter_q +1;
        end


        if(!init_q) begin
            if(wr_offset_q == POPSIZE -1 ) begin
                init_d = 'b1;
                rd_offest_d = FRAME_SIZE;
                new_data_d = 'b1;
            end
        end else begin
            if(counter_q == FRAME_SIZE-1)begin
                new_data_d = 'b1;
                counter_d = 'b0;
                if(rd_offest_q == FRAME_SIZE) begin
                    rd_offest_d = 'b0;
                end else begin
                    rd_offest_d = FRAME_SIZE;
                end
            end else begin
            end 
            
        end

    end
end


endmodule