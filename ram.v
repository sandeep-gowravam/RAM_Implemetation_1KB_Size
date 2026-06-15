`timescale 1ns / 1ps
module RAM #(parameter data_width = 8 , adder_width = 10)(
    input clk,
    input reset,
    input write_en,
    input [ adder_width -1 :0] adder,
    input [data_width-1:0] din,
    output reg [data_width-1:0] dout
);
reg [data_width-1:0] memory [(2**adder_width)-1:0];
always @ (posedge clk or posedge reset)
    begin
    if(reset)
        begin
            dout <= 0;
        end
    else if (write_en)
        begin
        memory[adder]<= din;
        end
    else
        begin
        dout <= memory[adder];
        end
    end
endmodule
