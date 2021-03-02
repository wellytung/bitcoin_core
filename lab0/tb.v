 module tb;

 reg clk = 1'b1;
 reg rst_n = 1'b1;
 reg seq_in = 1'b0;
 wire seq_out;

 integer i;
 reg [2:0] random_dly;

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

 // seq_in
 initial begin

  @(after_rst);

  // direct input test 
  @(posedge clk) seq_in <= 1'b0; 
  @(posedge clk) seq_in <= 1'b0; 
  @(posedge clk) seq_in <= 1'b1; 
  @(posedge clk) seq_in <= 1'b1; 
  @(posedge clk) seq_in <= 1'b1; 
  @(posedge clk) seq_in <= 1'b0; 
  @(posedge clk) seq_in <= 1'b0; 
  @(posedge clk) seq_in <= 1'b1; 
  @(posedge clk) seq_in <= 1'b1; 
  @(posedge clk) seq_in <= 1'b0; 
  @(posedge clk) seq_in <= 1'b1; 
  @(posedge clk) seq_in <= 1'b1; 
  @(posedge clk) seq_in <= 1'b0; 
  @(posedge clk) seq_in <= 1'b1; 
  @(posedge clk) seq_in <= 1'b1; 
  @(posedge clk) seq_in <= 1'b1; 

  // random input testing
  for ( i = 0 ; i < 50 ; i ++ ) begin
    random_dly = $random;
    repeat(random_dly) @(posedge clk);
    seq_in <= $random;
  end

  repeat(10)@(posedge clk); 
  $display("total detection count: %d", det_cnt);
  $finish;

end

reg [31:0] clk_cnt;

initial begin
  clk_cnt = 0;
  forever begin
    repeat(10)@(posedge clk); 
    $display("clk count : %d", clk_cnt);
  end
end

always @(posedge clk) begin

  clk_cnt <= clk_cnt + 1;

end

initial begin
  $dumpfile("seq.vcd");
  $dumpvars;
end

// initial begin
//   repeat(500)@(posedge clk);
//   $finish;
// end


reg [9:0] det_cnt = 0;

always @(posedge clk) begin
  if (seq_out == 1'b1) begin 
    det_cnt = det_cnt + 1;
    $display("detect seq: %d at clk_cnt: %d", det_cnt, clk_cnt);
  end
end

seq u_seq(
  .clk (clk),
  .rst_n (rst_n),
  .seq_in (seq_in),
  .seq_out (seq_out)
);

endmodule