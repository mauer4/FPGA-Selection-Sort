`timescale 1 ps / 1 ps

module Selection_sort(input logic clk, input logic rst, input logic start, output logic rdy, output logic done,
    input logic [7:0] rddata, output logic [7:0] wrdata,
    output logic [7:0] addr, output logic wren);

    enum {WAIT_sort, READ_SIZE, INC_i, INC_j, SWAP1, SWAP2} state, next_state;

    logic [7:0] i, j, data_j, size, temp_min, temp_addr;
    logic [7:0] next_i, next_j, next_data_j, next_size, next_temp_min, next_temp_addr;

    always_ff @(posedge clk) begin
        {i, j, data_j, size, temp_min, temp_addr, state} <=
        {next_i, next_j, next_data_j, next_size, next_temp_min, next_temp_addr, next_state};
    end

    always_comb begin
      next_state = state;
      case(state)
        WAIT_sort: next_state = (~rst && start) ? READ_SIZE : WAIT_sort;
        READ_SIZE: next_state = INC_j;
        INC_j:     next_state = (j <= size) ? INC_i : WAIT_sort;
        INC_i:     if(i <= size) next_state = INC_i;
                   else if(temp_addr == j) next_state = INC_j;
                   else next_state = SWAP1;
        SWAP1:     next_state = SWAP2;
        SWAP2:     next_state = INC_j;
      endcase
    end

    always_comb begin
      // registers
      next_j = j; next_i = i; next_size = size;
      next_data_j = data_j; next_temp_min = temp_min; next_temp_addr = temp_addr;
      // control
      rdy = 0; done = 0; wrdata = 0; wren = 0; addr = addr;
      case({state, next_state})
        {WAIT_sort,WAIT_sort}: begin
          rdy = 1'b1; done = 0; wrdata = 0; wren = 0; addr = 0;
          next_j = 1'b1; next_i = 2'd2; next_size = rddata;
          next_data_j = rddata; next_temp_min = rddata; next_temp_addr = 0;
        end
        {WAIT_sort, READ_SIZE}: {next_size, addr, next_j, next_i} = {rddata, 8'b1, 8'b0, 8'd1};
        {READ_SIZE, INC_j}: {next_j, next_temp_addr, addr} =
                            {j+1'b1,              j + 1'b1,    j + 1'b1};
        {INC_j, INC_i}:     {next_data_j, next_i, next_temp_min, addr} =
                            {rddata, j + 1'b1, rddata, j + 1'b1};
        {INC_i, INC_i}:     {next_i, next_temp_min, next_temp_addr, addr} =  rddata < temp_min ?
                            {i + 1'b1,      rddata,              i, i + 1'b1}  : {i + 1'b1, temp_min, temp_addr, i + 1'b1};
        {INC_i, INC_j}:     {next_j, next_temp_addr, addr} = {{3{j + 1'b1}}};
        {INC_i, SWAP1}:     {wren, wrdata, addr} = {1'b1, data_j, temp_addr};
        {SWAP1, SWAP2}:     {wren, wrdata, addr} = {1'b1, temp_min, j};
        {SWAP2, INC_j}:     {next_j, next_temp_addr, addr} =
                            {{3{j + 1'b1}}};
        {SWAP2, WAIT_sort}: done = 1'b1;
      endcase

    end

endmodule: Selection_sort
