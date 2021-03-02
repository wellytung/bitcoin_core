 module simple_fsm_tb;

 reg clk = 1'b1;
 reg rst_n = 1'b1;
 reg w_i = 1'b0;
 wire z_o;

 // clk
 always #10 clk = ~clk;

 event after_rst;

 // rst_n
 initial begin
  #6; // 6ns
  rst_n = 1'b0;
  #30; // 36ns
  rst_n = 1'b1;
  ->after_rst;
 end

 // w_i
 initial begin
  @(after_rst);
  repeat(2)@(posedge clk); // 60ns
  w_i <= 1'b1;
  @(posedge clk); // 80 ns
  w_i <= 1'b0;
  @(posedge clk); // 100 ns
  w_i <= 1'b1;
  repeat(2)@(posedge clk); // 140 ns
  w_i <= 1'b0;
  @(posedge clk); // 160 ns
  w_i <= 1'b1;
  repeat(3)@(posedge clk); // 220 ns
  w_i <= 1'b0;
end

reg [31:0] clk_cnt;

initial begin
  clk_cnt = 0;
  forever begin
    repeat(10)@(posedge clk); 
    clk_cnt = clk_cnt + 10;
    $display("clk count : %d", clk_cnt);
  end
end

initial begin
  $dumpfile("seq.vcd");
  $dumpvars;
end

initial begin
  repeat(500)@(posedge clk);
  $finish;
end

seq u_seq(
  .clk (clk),
  .rst_n (rst_n),
  .w_i (w_i),
  .z_o (z_o)
);

endmodule