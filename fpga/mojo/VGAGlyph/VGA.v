`timescale 1ns / 1ps
module VGA(
	input wire clk,
	input wire rst,
	output wire[2:0] pixel,
	output hsync_out,
   output vsync_out
);

wire inDisplayArea;
wire [9:0] CounterX;
wire [8:0] CounterY;
wire [6:0] column;
wire [5:0] row;
wire [2:0] idx;
reg  [2:0] r_pixel;
wire [2:0] framebuffer_pixel;
wire clk_25;

reg hsync_delayed1;
reg hsync_delayed2;
reg hsync_delayed3;

reg vsync_delayed1;
reg vsync_delayed2;
reg vsync_delayed3;

// Here we delay the hsync and vsync to align with the
// value of the pixels
always@(posedge clk) begin
	hsync_delayed1 <= hsync_out_original;
	hsync_delayed2 <= hsync_delayed1;
	hsync_delayed3 <= hsync_delayed2;
	
	vsync_delayed1 <= vsync_out_original;
	vsync_delayed2 <= vsync_delayed1;
	vsync_delayed3 <= vsync_delayed2;
end

assign hsync_out = hsync_delayed2;
assign vsync_out = vsync_delayed2;

hvsync_generator hvsync(
  .clk(clk),
  .vga_h_sync(hsync_out_original),
  .vga_v_sync(vsync_out_original),
  .CounterX(CounterX),
  .CounterY(CounterY),
  .inDisplayArea(inDisplayArea)
);

framebuffer fb(
	.clk(clk),
	.x(CounterX),
	.y(CounterY),
	.pixel(framebuffer_pixel)
);


always @(posedge clk)
begin
	  if (inDisplayArea)
		 r_pixel <= framebuffer_pixel;
	  else // if it's not to display, go dark
		 r_pixel <= 3'b000;
end

assign pixel = r_pixel;

endmodule
