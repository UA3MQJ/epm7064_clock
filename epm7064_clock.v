module epm7064_clock(clk, dig_sel, segs, btn_HH, btn_MM, btn_SS, btn_SAFE, led_second_tick);
input wire clk;
output wire [3:0] dig_sel;
output wire [6:0] segs;
output wire led_second_tick;
input wire btn_HH, btn_MM, btn_SS, btn_SAFE;


wire SAFE_MODE = ~btn_SAFE;

//clk - general clock 32768
reg [13:0] clk_div; initial clk_div <= 14'd0;
always @(posedge clk) clk_div <= clk_div + 1'b1;

reg [6:0] sec;// 0..119 - 7bit
reg [3:0] m  ;// 0..9   - 4bit
reg [2:0] mm ;// 0..5   - 3bit
reg [3:0] h  ;// 0..9   - 4bit
reg [1:0] hh ;// 0..2   - 2bit

wire       sec_cy    = (sec  == 7'd119);
wire [6:0] next_sec  = (sec_cy) ? 7'd0 : (sec + 1'b1);

wire       m_cy    = (m  == 4'd9);// && sec_cy;
wire [3:0] next_m  = (m_cy) ? 4'd0 : (m + 1'b1);//(m_cy) ? 4'd0 : (m + ss_cy);

wire       mm_cy   = ((mm == 3'd5) &&(m  == 4'd9));
wire [2:0] next_mm =  (mm_cy) ? 3'd0 : (mm + 1'b1);

wire       h_cy    = (h  == 4'd9)||((hh == 4'd2) && (h  == 4'd3));
wire [3:0] next_h  = (h_cy) ? 4'd0 : (h + 1'b1);

wire       hh_cy   = ((hh == 2'd2) && (h  == 4'd3));
wire [1:0] next_hh = (hh_cy) ? 2'd0 : (hh + 1'b1);


wire timer_clk = clk_div[13]; 
always @(posedge timer_clk) begin
    sec <=                             (btn_SS)       ? 7'd0    : next_sec; //reset seconds
    m   <= (                  sec_cy)||(btn_MM)       ? next_m  : m;
    mm  <= (            m_cy&&sec_cy)||(btn_MM&&m_cy) ? next_mm : mm;
    h   <= (     mm_cy&&m_cy&&sec_cy)||(btn_HH)       ? next_h  : h;
    hh  <= (h_cy&mm_cy&&m_cy&&sec_cy)||(btn_HH&&h_cy) ? next_hh : hh;
end


wire [3:0] top_bits = clk_div[6:3]; //

//hide hour zero
wire h_show = !(hh==0);

wire [4:0] t_dig_sel = (top_bits == 4'b0000 && h_show &&(!SAFE_MODE)) ? 4'b0001 :
					   (top_bits == 4'b0100 &&(!SAFE_MODE)) ? 4'b0010 :
					   (top_bits == 4'b1000 &&(!SAFE_MODE)) ? 4'b0100 :
					   (top_bits == 4'b1100 &&(!SAFE_MODE)) ? 4'b1000 : 4'b0000;
                
assign dig_sel = t_dig_sel;

wire [6:0] s_m1;
wire [6:0] s_m2;
wire [6:0] s_m3;
wire [6:0] s_m4;

bcd2seg0_2 sseg_1( .sin(hh),  .sout(s_m1));
bcd2seg0_9 sseg_2( .sin(h),  .sout(s_m2));
bcd2seg0_5 sseg_3( .sin(mm),  .sout(s_m3));
bcd2seg0_9 sseg_4( .sin(m),  .sout(s_m4));

wire [6:0] t_segs = (top_bits == 4'b0000) ? ~s_m1 :
                    (top_bits == 4'b0100) ? ~s_m2 :
                    (top_bits == 4'b1000) ? ~s_m3 :
                    (top_bits == 4'b1100) ? ~s_m4 : 7'b0000000;
              
assign segs = t_segs;

//one second tick indicator
assign led_second_tick = (sec[0]&&(!SAFE_MODE))||(sec[0]&&(clk_div[13:6]==10'd0)&&(SAFE_MODE)); //!!
					  
endmodule
