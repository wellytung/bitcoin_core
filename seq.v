 module seq(
   clk,
   rst_n,
   w_i,
   z_o
 );
 
 input  clk;
 input  rst_n;
 input  w_i;
 output z_o;
 
 parameter IDLE = 2'b00;
 parameter S0   = 2'b01;
 parameter S1   = 2'b10;
 
 reg [1:0] curr_state;
 reg [1:0] next_state;
 reg z_o;
 
 // state reg
 always@(posedge clk or negedge rst_n)
   if (~rst_n) curr_state <= IDLE;
   else        curr_state <= next_state;
     
 // next state logic    
 always@(*)
   case (curr_state)
     IDLE    : if (w_i) next_state = S0;
               else     next_state = IDLE;
     S0      : if (w_i) next_state = S1;
               else     next_state = IDLE;
     S1      : if (w_i) next_state = S1;
               else     next_state = IDLE;
     default :          next_state = IDLE;
   endcase    
 
 // output logic
 always@(*)
   case (curr_state)
     IDLE    : z_o = 1'b0;
     S0      : z_o = 1'b0;
     S1      : z_o = 1'b1;
     default : z_o = 1'b0;
   endcase
   
 endmodule