`timescale 1ns / 1ps
module chi_squared #(parameter DoF = 5, single_edge_len = 100)(
    input logic clk,
    input logic rst,
    input logic [15:0]E_in,
    input logic [15:0]O_in,
    input logic data_rdy,
    
    output logic [7:0]addra_out,
    output logic [7:0]addrb_out,
    output logic [31:0]chi_out,
    output logic data_vld
);

logic [15:0] E_in_q;
logic [15:0] E_in_d;
logic [15:0] O_in_q;
logic [15:0] O_in_d;
logic [31:0] chi_out_d;
logic [31:0] chi_out_q;
logic [7:0] addra_out_d;
logic [7:0] addra_out_q;
logic [7:0] addrb_out_d;
logic [7:0] addrb_out_q;
logic [7:0] counter_d;
logic [7:0] counter_q;
logic [7:0] sum_counter_d;
logic [7:0] sum_counter_q;
logic [31:0] tmp_sum_d;
logic [31:0] tmp_sum_q;
logic [15:0] E_d;
logic [15:0] E_q;
logic data_vld_q;
logic data_vld_d;

assign E_in_d = E_in;
assign O_in_d = O_in;
assign chi_out = chi_out_q;
assign addra_out =addra_out_q;
assign addrb_out = addrb_out_q;
assign chi_out = chi_out_q;
assign data_vld = data_vld_q;

enum{idle_state, run_state} curr_state, next_state;
 
always_ff@(posedge clk or posedge rst)begin
    if(rst)begin
        chi_out_q <='b0;
        curr_state = idle_state;
        addra_out_q <='b0;
        addrb_out_q <='d6;
        E_in_q <='b0;
        O_in_q <='b0;
        counter_q <= 'b0;
        sum_counter_q <= 'b0;
        tmp_sum_q <= 'b0;
        E_q <= 'b0;
        data_vld_q <= 'b0;
    end else begin
        curr_state = next_state;
        chi_out_q <= chi_out_d;
        E_in_q <= E_in_d;
        E_q <= E_d;
        O_in_q <= O_in_d;
        addra_out_q <=addra_out_d;
        addrb_out_q <=addrb_out_d;
        counter_q <= counter_d;
        sum_counter_q <=sum_counter_d;
        tmp_sum_q <= tmp_sum_d;
        data_vld_q <= data_vld_d;
    end
 end
 
 always_comb begin
    next_state = curr_state;
    chi_out_d = chi_out_q;
    E_d = E_q;
    counter_d = counter_q;
    sum_counter_d =sum_counter_q;
    addra_out_d =addra_out_q;
    addrb_out_d = addrb_out_q;
    tmp_sum_d = tmp_sum_q;
    data_vld_d = data_vld_q;
    
    case(curr_state)
        idle_state: begin
            if(data_rdy)begin
                next_state = run_state;
                data_vld_d = 0;
                tmp_sum_d = 'b0;
            end
        end
        run_state: begin
            if(sum_counter_q > DoF)begin
                chi_out_d = tmp_sum_q;
                data_vld_d = 1;
                addra_out_d = 'b0;
                addrb_out_d = 'b0;
                next_state = idle_state;
                sum_counter_d = 'b0;
            end else begin
                if(counter_q == 'd2)begin
                    E_d = E_in_q * single_edge_len;
                    counter_d = counter_q +1;
                end else if(counter_q == 'd3) begin
                    if(E_q > O_in_q) begin
                        tmp_sum_d = E_q - O_in_q;
                    end else begin
                        tmp_sum_d = (O_in_q - E_q);
                    end
                    counter_d = counter_q +1;
                end else if(counter_q == 'd5) begin
                    tmp_sum_d = tmp_sum_q * tmp_sum_q;
                    counter_d = counter_q +1;
                end else if(counter_q == 'd6) begin
                    tmp_sum_d = tmp_sum_q / E_q;
                    counter_d = counter_q +1;
                end else if(counter_q == 'd7) begin
                    counter_d = counter_q +1;
                    addra_out_d = addra_out_q + 1;
                    addrb_out_d = addrb_out_q + 1;
                    sum_counter_d = sum_counter_q +1;
                    counter_d = 'b0;
                end else begin
                    counter_d = counter_q +1;
                    tmp_sum_d = tmp_sum_q;
                end
                
            end
        end
        default: begin
            next_state = idle_state;
        end
    
    endcase
 
 end



endmodule