module IDS#(parameter THRESHOLD = 'h06A9,POPSIZE = 100, WINSIZE = 200, FRAME_SIZE = 20,DATA_WIDTH = 8,scale_factor ='h017C,DoF = 5,ID_WIDTH = 11)(
    input logic clk,
    input logic rst,
    input logic data_rdy,
    input logic [ID_WIDTH-1:0] ID_in,
    
    output logic is_attacked

);

logic new_data;
logic rd_from_chi;

logic rd_rqst;
logic [$clog2(POPSIZE)-1:0] addr_out;
logic data_vld;
logic [$clog2(POPSIZE):0] bin_out;
logic calc_done;
 logic [DATA_WIDTH-1:0] data_out;
    logic data_rdy_REG;
  logic data_vld_REG;
  logic [31:0]chi_out;
      logic data_vld_chi;
    logic is_attacked_d;
    logic is_attacked_q;
    logic data_vld_graph;
    logic [DATA_WIDTH-1:0] num_edges;
    
    assign is_attacked = is_attacked_q;
  
 graph #(.POPSIZE(POPSIZE),.WINSIZE(WINSIZE),.DATA_WIDTH(DATA_WIDTH),.ID_WIDTH(ID_WIDTH)) graph_0 
 (
 .clk(clk),
 .rst(rst),
 .data_rdy(data_rdy),
 .ID_in(ID_in),
 .data_vld(data_vld_graph),
 .num_edges(num_edges)
 );
calc_total #(.WINSIZE(WINSIZE),.scale_factor(scale_factor),.POPSIZE(POPSIZE),.DATA_WIDTH(DATA_WIDTH))
dut_0(
    .clk(clk),
    .rst(rst),
    .data_rdy(data_vld_REG),
    .data_in(data_out),
    .new_data(new_data),
    .rd_from_chi(rd_from_chi),
    .rd_rqst(rd_rqst),
    .addr_out(addr_out),
    .data_vld(data_vld),
    .bin_out(bin_out),
    .calc_done(calc_done)
);


reg_file #(
    .POPSIZE(POPSIZE),
    .FRAME_SIZE(FRAME_SIZE),
    .DATA_WIDTH(DATA_WIDTH)
  ) reg_file_inst (
    .clk(clk),
    .rst(rst),
    .read_addr(addr_out),
    .data_in(num_edges),
    .data_rdy(data_vld_graph),
    .rd_rqst(rd_rqst),
    .new_data(new_data),
    .data_vld(data_vld_REG),
    .data_out(data_out)
  );

chi_squared #(
    .DoF(DoF),
    .POPSIZE(POPSIZE)
  ) dut_chi (
    .clk(clk),
    .rst(rst),
    .O_in({bin_out,8'b0}),
    .data_rdy(data_vld),
    .calc_done(calc_done),
    .rd_rqst(rd_from_chi),
    .chi_out(chi_out),
    .data_vld(data_vld_chi)
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
    if(data_vld_chi) begin
        if(chi_out >= THRESHOLD)begin
            is_attacked_d = 'b1;
        end else begin
            is_attacked_d = 'b0;
        end
    end
end

endmodule