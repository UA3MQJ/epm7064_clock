//bin to 7seg
module bcd2seg0_2(sin, sout);
input wire [1:0] sin;
output wire [6:0] sout;
reg [6:0] SEG_buf;

  always @ (sin)
  begin
    case(sin)
      2'h0: SEG_buf <= 7'b0111111;
      2'h1: SEG_buf <= 7'b0000110;
      2'h2: SEG_buf <= 7'b1011011;
      default: SEG_buf <= 7'b0000000;
    endcase
  end 
  
  assign sout = SEG_buf;

endmodule

