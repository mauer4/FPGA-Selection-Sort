`timescale 1 ps / 1 ps

module tb_rtl_Selection_sort();

  // general inputs
  logic tb_clk, tb_rst, tb_start;
  // general outputs
  logic tb_rdy, tb_done;

  // memory signals
  logic [7:0] tb_wrdata, tb_rddata, tb_addr;
  logic wren;

  // error signals
  logic err_gen = 0;

  Selection_sort DUT(tb_clk, tb_rst, tb_start, tb_rdy, tb_done, tb_rddata, tb_wrdata, tb_addr, tb_wren);

  logic [7:0] data [0:10];
  logic [7:0] sorted [0:10];


  always_comb begin
    data = {8'd10, 8'd6, 8'd0, 8'd4, 8'd3, 8'd5, 8'd2, 8'd7, 8'd1, 8'd9, 8'd8 };
    if(tb_wren)
      data[tb_addr] = tb_wrdata;
  end


  always_ff @(posedge tb_clk) begin
    tb_rddata <= data[tb_addr];
  end


  initial begin
      tb_clk = 0; #5;
      forever begin
        tb_clk = 1; #5; tb_clk = 0; #5;
      end
  end

  initial begin
    tb_rst = 1; tb_start = 0;
    @(posedge tb_clk)
    @(posedge tb_clk) #5;
    tb_rst = 0; tb_start = 1;
    @(posedge tb_clk)
    #10; {tb_rst, tb_start} = 2'b10;
    #100;
  end

endmodule: tb_rtl_Selection_sort
