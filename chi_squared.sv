`timescale 1ns / 1ps
module chi_squared #(parameter DoF = 5, POPSIZE = 100)(
    input logic clk,
    input logic rst,
    input logic [15:0]O_in,
    input logic data_rdy,
    input logic calc_done,
    
    output logic rd_rqst,
    output logic [31:0]chi_out,
    output logic data_vld
);

logic [15:0] O_in_q;
logic [15:0] O_in_d;
logic rd_rqst_d;
logic rd_rqst_q;
logic [31:0] chi_out_d;
logic [31:0] chi_out_q;
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
logic [15:0] k_values[0:5];

assign O_in_d = O_in;
assign chi_out = chi_out_q;
assign chi_out = chi_out_q;
assign data_vld = data_vld_q;
assign rd_rqst = rd_rqst_q;

enum{idle_state, run_state,calc_state} curr_state, next_state;
always_ff@(posedge clk or posedge rst)begin
    if(rst)begin
        chi_out_q <='b0;
        curr_state = idle_state;
        O_in_q <='b0;
        counter_q <= 'b0;
        sum_counter_q <= 'b0;
        tmp_sum_q <= 'b0;
        E_q <= 'b0;
        data_vld_q <= 'b0;
        rd_rqst_q <= 'b0;
        k_values[0] <= 'h004B;
        k_values[1] <= 'h0057;
        k_values[2] <= 'h007C;
        k_values[3] <= 'h0072;
        k_values[4] <= 'h008A;
        k_values[5] <= 'h0072;
    end else begin
        rd_rqst_q <= rd_rqst_d;
        curr_state = next_state;
        chi_out_q <= chi_out_d;
        E_q <= E_d;
        O_in_q <= O_in_d;
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
    tmp_sum_d = tmp_sum_q;
    data_vld_d = 'b0;
    rd_rqst_d = 'b0;
    
    case(curr_state)
        idle_state: begin
            if(calc_done)begin
                next_state = run_state;
                data_vld_d = 0;
                tmp_sum_d = 'b0;
                rd_rqst_d = 'b1;
            end
        end
        run_state: begin
            if(sum_counter_q > DoF) begin
                sum_counter_d = 'b0;
                data_vld_d = 'b1;
                next_state = idle_state;
            end else if(data_rdy) begin
                E_d = k_values[sum_counter_q] * POPSIZE;
                sum_counter_d = sum_counter_q +1;
                next_state = calc_state;
            end
            
            
        end
        calc_state: begin
             if(counter_q == 'd3) begin
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
                 counter_d = 'b0;
                 next_state = run_state;
                 chi_out_d = chi_out_q + tmp_sum_q;
                 rd_rqst_d = 'b1;
             end else begin
                counter_d = counter_q +1;
             end
             
        end
        default: begin
            next_state = idle_state;
        end
    
    endcase
 
 end



endmodule