//bin to 7seg
module bcd2seg0_9(sin, sout);
input wire [3:0] sin;
output wire [6:0] sout;
reg [6:0] SEG_buf;

  always @ (sin)
  begin
    case(sin)
      4'h0: SEG_buf <= 7'b0111111;
      4'h1: SEG_buf <= 7'b0000110;
      4'h2: SEG_buf <= 7'b1011011;
      4'h3: SEG_buf <= 7'b1001111;
      4'h4: SEG_buf <= 7'b1100110;
      4'h5: SEG_buf <= 7'b1101101;
      4'h6: SEG_buf <= 7'b1111101;
      4'h7: SEG_buf <= 7'b0000111;
      4'h8: SEG_buf <= 7'b1111111;
      4'h9: SEG_buf <= 7'b1101111;
      default: SEG_buf <= 7'b0000000;
    endcase
  end 
  
  assign sout = SEG_buf;

endmodule

