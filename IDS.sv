module IDS#(parameter THRESHOLD = 'h06A9)(
    input logic clk,
    input logic rst,
    input logic [15:0]E_in,
    input logic [15:0]O_in,
    input logic data_rdy,
    
    output logic [7:0]addra_out,
    output logic [7:0]addrb_out,
    output logic is_attacked
    );
    logic [31:0]chi_out;
    logic data_vld;
    logic is_attacked_d;
    logic is_attacked_q;
    
    assign is_attacked = is_attacked_q;
    
    chi_squared chi_0(
        .clk(clk),
        .rst(rst),
        .E_in(E_in),
        .O_in(O_in),
        .data_rdy(data_rdy),
        .addra_out(addra_out),
        .addrb_out(addrb_out),
        .chi_out(chi_out),
        .data_vld(data_vld)
    );
    
always_ff@(posedge clk or posedge rst)begin
    if(rst)begin
        is_attacked_q <= 'b0;
    end else begin
        is_attacked_q <= is_attacked_d;
    end
end

always_comb begin
    is_attacked_d = is_attacked_q;
    if(data_rdy) begin
        if(chi_out <= THRESHOLD)begin
            is_attacked_d = 'b1;
        end else begin
            is_attacked_d = 'b0;
        end
    end
end

endmodule