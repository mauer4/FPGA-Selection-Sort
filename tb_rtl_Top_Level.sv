`timescale 1 ps / 1 ps

module tb_rtl_Final_prcatice();

  logic tb_clk, tb_start;
  logic [6:0] tb_HEX0, tb_HEX1, tb_HEX2, tb_HEX3, tb_HEX4, tb_HEX5;
  logic [9:0] tb_LEDR, tb_SW;
  logic [3:0] tb_KEY;

  Final_practice DUT(tb_clk, tb_KEY, tb_SW, tb_LEDR, tb_HEX0, tb_HEX1, tb_HEX2, tb_HEX3, tb_HEX4, tb_HEX5);

  initial begin
      tb_clk = 0; #5;
      forever begin
        tb_clk = 1; #5; tb_clk = 0; #5;
      end
  end

  initial begin
    tb_KEY[3] = 1;
    @(posedge tb_clk) #5;
    @(posedge tb_clk) #5;
    tb_KEY[3] = 0;
    @(posedge tb_clk)
    tb_KEY[3] = 1;
  end

endmodule: tb_rtl_Final_prcatice
