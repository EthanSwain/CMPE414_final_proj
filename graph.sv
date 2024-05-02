module graph #(parameter POPSIZE = 100,WINSIZE = 200,DATA_WIDTH = 8,ID_WIDTH =11)(
    input logic clk,
    input logic rst,
    input logic [ID_WIDTH-1:0] ID_in,
    input logic data_rdy,

    output logic data_vld,
    output logic [DATA_WIDTH-1:0] num_edges 

);


logic [WINSIZE-1:0] has_edge_arr;
logic [WINSIZE-1:0] is_equal_arr;

logic [$clog2(WINSIZE):0] edge_addr_d;
logic [$clog2(WINSIZE):0] edge_addr_q;
logic data_vld_d;
logic data_vld_q;
logic [DATA_WIDTH-1:0] num_edges_d;
logic [DATA_WIDTH-1:0] num_edges_q;
logic [$clog2(WINSIZE):0] msg_counter_d;
logic [$clog2(WINSIZE):0] msg_counter_q;
logic [ID_WIDTH-1:0] prev_msg_d;
logic [ID_WIDTH-1:0] prev_msg_q;
logic [ID_WIDTH-1:0] curr_msg_q;
logic [ID_WIDTH-1:0] curr_msg_d;
logic data_rdy_d;
logic data_rdy_q;
logic edge_rdy_q;
logic edge_rdy_d;
logic [ID_WIDTH-1:0] ID_in_d;
logic [ID_WIDTH-1:0] ID_in_q;
logic [WINSIZE-1:0] data_rdy_in_d;
logic [WINSIZE-1:0] data_rdy_in_q;
logic [$clog2(WINSIZE)-1:0] encode_out_d;
logic [$clog2(WINSIZE)-1:0] encode_out_q;
logic [7:0] counter_d;
logic [7:0] counter_q;
assign data_rdy_d = data_rdy;
assign num_edges = num_edges_q;
assign data_vld = data_vld_q;

enum {idle_state,insert_state,Connect_state,send_state,reset_state} curr_state, next_state;

genvar i;

generate
    for(i =0; i<WINSIZE;i++) begin
        matrix_el #(.POPSIZE(POPSIZE),.WINSIZE(WINSIZE),.ID_WIDTH(ID_WIDTH))
        instance_i(.clk(clk),.rst(rst),.edge_in(ID_in_q),.edge_rdy(edge_rdy_q),.data_rdy_in(data_rdy_in_q[i]),.edge_addr(edge_addr_q),.has_edge(has_edge_arr[i]),.is_equal(is_equal_arr[i]));
    end

endgenerate

encoder200 #(.WINSIZE(WINSIZE))encode(
    .in(is_equal_arr),
    .out(encode_out_d)
);

always_ff @(posedge clk or posedge rst) begin
    if(rst)begin
        data_vld_q <= 'b0;
        num_edges_q <= 'b0;
        edge_addr_q <= 'b0;
        data_rdy_q <= 'b0;
        edge_rdy_q <= 'b0;
        curr_state <= idle_state;
        msg_counter_q <= 'b0;
        prev_msg_q <= 'b0;
        curr_msg_q <= 'b0;
        ID_in_q <= 'b0;
        data_rdy_in_q <= 'b0;
        encode_out_q <= 'b0;
        counter_q <= 'b0;
    end else begin
        data_vld_q <= data_vld_d;
        num_edges_q <= num_edges_d;
        edge_addr_q <= edge_addr_d;
        data_rdy_q <= data_rdy_d;
        edge_rdy_q <= edge_rdy_d;
        curr_state <= next_state;
        msg_counter_q <= msg_counter_d;
        prev_msg_q <=  prev_msg_d;
        curr_msg_q <= curr_msg_d;
        ID_in_q <= ID_in_d;
        data_rdy_in_q <= data_rdy_in_d;
        encode_out_q <= encode_out_d;
        counter_q <= counter_d;
    end
end

always_comb begin
    data_vld_d = 'b0;
    num_edges_d = num_edges_q;
    edge_addr_d = edge_addr_q;
    edge_rdy_d = 'b0;
    next_state = curr_state;
    msg_counter_d = msg_counter_q;
    prev_msg_d = prev_msg_q;
    curr_msg_d = curr_msg_q;
    data_rdy_in_d = data_rdy_in_q;
    counter_d = counter_q;
    ID_in_d = ID_in_q;
    case(curr_state)
        idle_state : begin
            if(data_rdy_q)begin
                next_state = insert_state;
                edge_addr_d = 'b0;
                curr_msg_d = ID_in;
                data_rdy_in_d = 'b0;
                ID_in_d = ID_in;
            end
        end
        insert_state: begin
            if(is_equal_arr == 'b0) begin
                data_rdy_in_d[msg_counter_q] = 'b1;
                if(msg_counter_q == 0)begin
                    next_state = idle_state;
                end else begin
                    if(prev_msg_q != curr_msg_q) begin
                        next_state = Connect_state;
                    end else begin
                        next_state = idle_state;
                    end
                end
                edge_addr_d = msg_counter_q;
            end else begin
                next_state = Connect_state;
                edge_addr_d = encode_out_q;
            end
            if(counter_d != 0) begin 
                prev_msg_d = ID_in_q;
                ID_in_d = prev_msg_q;
                msg_counter_d = msg_counter_q +1;
                counter_d = 'b0;
                data_rdy_in_d = 'b0;
            end else begin
                next_state = insert_state;
                counter_d = counter_q +1;
            end
            

        end
        Connect_state: begin
            edge_rdy_d = 'b1;
            if(has_edge_arr == 'b0) begin
                num_edges_d = num_edges_q +1;
            end
            if(msg_counter_q == WINSIZE -1) begin
                next_state = send_state;
            end else begin
                next_state = idle_state;
            end
            
        end
        send_state: begin
            data_vld_d = 'b1;
            next_state = reset_state;
        end
        
        reset_state: begin
            num_edges_d = 'b0;
            msg_counter_d = 'b0;
            next_state = idle_state;
        end
    endcase
end

endmodule