module matrix_el#(parameter WINSIZE = 200, POPSIZE = 100, ID_WIDTH = 11)(
    input logic clk,
    input logic rst,
    input logic [ID_WIDTH-1:0]edge_in,
    input logic data_rdy_in,
    input logic edge_rdy,
    input logic [$clog2(WINSIZE)-1:0] edge_addr,
    output logic is_equal,
    output logic has_edge
);

logic [ID_WIDTH-1:0] data_out_q;
logic [ID_WIDTH-1:0] data_out_d;
logic is_equal_d;
logic is_equal_q;
logic [WINSIZE-1:0] rows_d;
logic [WINSIZE-1:0] rows_q;
logic has_edge_d;
logic has_edge_q;
logic is_init_q;
logic is_init_d;

assign is_equal = is_equal_q;
assign has_edge = has_edge_q;


always_ff @(negedge clk or posedge rst) begin
    if(rst)begin
        is_equal_q <= 'b0;
        data_out_q <= 'b0;
        rows_q <= 'b0;
        has_edge_q <= 'b0;
        is_init_q <= 'b0;
    end else begin
        is_equal_q <= is_equal_d;
        data_out_q <= data_out_d;
        rows_q <= rows_d;
        has_edge_q <= has_edge_d;
        is_init_q <= is_init_d;
    end
end

always_comb begin
    is_equal_d = 'b0;
    data_out_d = data_out_q;
    rows_d = rows_q;
    has_edge_d = 'b0;
    is_init_d = is_init_q;
    if(edge_in == data_out_q && is_init_q)begin
        is_equal_d =  'b1;
    end
    if(data_rdy_in && !is_init_q) begin
        data_out_d = edge_in;
        is_init_d = 'b1;
        
    end
    if(edge_rdy && is_equal_q && is_init_q) begin
        rows_d[edge_addr] = 'b1;
    end
    if(rows_q[edge_addr] && is_equal_q) begin
        has_edge_d = 'b1;
    end
end

endmodule