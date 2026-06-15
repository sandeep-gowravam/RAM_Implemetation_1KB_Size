`timescale 1ns / 1ps
module RAM_tb;
    parameter DATA_WIDTH = 8;
    parameter ADDER_WIDTH = 10;
    reg clk;
    reg reset;
    reg write_en;
    reg [ADDER_WIDTH-1:0] adder;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    RAM #(.data_width(DATA_WIDTH),.adder_width(ADDER_WIDTH)) 
    uut(
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .adder(adder),
        .din(din),
        .dout(dout)
    );
    always #10 clk = ~clk;
    initial 
    begin
        clk = 0;
        reset = 0;
        write_en = 0;
        adder = 0;
        din = 0;
 // TEST CASE 1: Verify Reset Logic 
        $display(" Starting RAM Verification ");
        reset = 1;#25;
        reset = 0;#5;
        if (dout !== 0) 
            begin 
                $display("ERROR : Reset failed ! dout is %h instead of 0", dout);
                $stop;
            end 
        else 
            begin
            $display("SUCCESS: Reset initialized dout to 0");
            end
 // TEST CASE 2: Write Operations 

        write_mem(10'h001, 8'h90);  
        write_mem(10'h002, 8'h67);  
        write_mem(10'h003, 8'h89);  
        #20;


// TEST CASE 3: Read & Verify Operations 

        check_mem(10'h001, 8'h90);
        check_mem(10'h002, 8'h67);
        check_mem(10'h003, 8'h89);
        $display(" All Tests Passed Successfully! ");
        $finish;
    end
    task write_mem(input [ADDER_WIDTH-1:0] t_adder, input [DATA_WIDTH-1:0] t_din);
        begin
            @(posedge clk);
            write_en = 1;
            adder = t_adder;
            din = t_din;
            @(posedge clk) ; #1;
            write_en = 0;
        end
    endtask
    task check_mem(input [ADDER_WIDTH-1:0] t_adder, input [DATA_WIDTH-1:0] expected_dout);
        begin
            @(posedge clk);
            write_en = 0;
            adder = t_adder;  
            @(posedge clk); #2;          
            if (dout !== expected_dout) 
            begin
                $display("ERROR at Address %h! Expected: %h, Got: %h", t_adder, expected_dout, dout);
                $stop;
            end else begin
                $display("SUCCESS: Address %h verified with data %h", t_adder, dout);
            end
        end
    endtask

endmodule