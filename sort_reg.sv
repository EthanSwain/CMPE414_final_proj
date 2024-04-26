module sort_reg #(parameter DATA_WIDTH =8)(
    input logic clk,
    input logic rst,
    input logic GT_in,
    input logic [DATA_WIDTH-1:0] data_in,
    input logic [DATA_WIDTH-1:0] prev_data,
    input logic data_rdy,
    
    output logic [DATA_WIDTH-1:0] data_out,
    output logic GT
);

logic [DATA_WIDTH-1:0] data_out_d;
logic [DATA_WIDTH-1:0] data_out_q;

assign GT = (data_in >data_out_q);

assign data_out = data_out_q;

always_ff@(negedge clk or posedge rst)begin
    if(rst)begin
        data_out_q <= 'b0;
    end else begin
        data_out_q <= data_out_d;
    end
end

always_comb begin
    if(data_rdy) begin
        if(GT && GT_in)begin
            data_out_d = prev_data;
        end else if(GT && !GT_in) begin
            data_out_d = data_in;
        end else begin
            data_out_d = data_out_q;
        end
    end else begin
        data_out_d = data_out_q;
    end
end


endmodule