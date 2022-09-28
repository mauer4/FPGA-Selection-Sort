`timescale 1 ps / 1 ps
`include "./memory/data.v"

module Final_practice(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5);

    enum {WAIT, SORT} state, next_state;

    // memory SIGNALS
    logic [7:0] addr, wrdata, rddata;
    logic wren;

    data data_mem(addr, CLOCK_50, wrdata, wren, rddata);

    // sort SIGNALS
    logic rdy, start, done;

    Selection_sort sort(CLOCK_50, KEY[3], start, rdy, done, rddata, wrdata, addr, wren);

    always_ff @(posedge CLOCK_50) begin
        state <= next_state;
    end

    always_comb begin
        case(state)
            WAIT: next_state = (~KEY[3]) ? SORT : WAIT;
            SORT: next_state = done ? WAIT : SORT;
        endcase
    end

    always_comb begin
      case({state,next_state})
        {WAIT,WAIT}: start = 0;
        {WAIT, SORT}: start = 1'b1;
        {SORT,SORT}:  start = 0;
        {SORT,WAIT}: start = 0;
      endcase
    end

endmodule: Final_practice
