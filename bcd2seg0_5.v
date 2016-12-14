//bin to 7seg
module bcd2seg0_5(sin, sout);
input wire [2:0] sin;
output wire [6:0] sout;
reg [6:0] SEG_buf;

  always @ (sin)
  begin
    case(sin)
      3'h0: SEG_buf <= 7'b0111111;
      3'h1: SEG_buf <= 7'b0000110;
      3'h2: SEG_buf <= 7'b1011011;
      3'h3: SEG_buf <= 7'b1001111;
      3'h4: SEG_buf <= 7'b1100110;
      3'h5: SEG_buf <= 7'b1101101;
      default: SEG_buf <= 7'b0000000;
    endcase
  end 
  
  assign sout = SEG_buf;

endmodule

