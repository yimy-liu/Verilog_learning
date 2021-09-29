{\rtf1\ansi\ansicpg936\cocoartf2580
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset134 PingFangSC-Regular;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 `timescale 1ns / 1ps\
\
module dualport_ram_async ();\
		parameter	DATA_WIDTH = 8,\
		parameter	ADDR_WIDTH = 4 \
		\
		reg wr_clk;\
		reg wr_rst_n;\
		reg wr_en;\
		reg [ADDR_WIDTH-1:0] wr_addr;\
		reg [DATA_WIDTH-1:0] wr_data;\
		reg rd_clk;\
		reg rd_rst_n;\
		reg rd_en;\
		reg [ADDR_WIDTH-1:0] rd_addr;\
		wire [DATA_WIDTH-1:0] rd_data;\
		wire full;\
		wire afull;\
		wire aempty;\
		wire empty;\
    );\
\
async_fifo #(\
		.DATA_WIDTH(DATA_WIDTH),\
		.ADDR_WIDTH(ADDR_WIDTH)\
	) inst_async_fifo(\
		.wr_clk  (wr_clk  ),\
		.wr_rst_n(wr_rst_n),\
		.wr_en   (wr_vld  ),\
		.wr_data (wr_data ),\
		.rd_clk  (rd_clk  ),\
		.rd_rst_n(rd_rst_n),\
		.rd_en   (rd_vld  ),\
		.rd_data (rd_data ),\
		.full    (full),\
		.afull   (afull),\
		.aempty  (aempty),\
		.empty   (empty)\
	);\
	\
localparam 	RAM_DEPTH = 1<<ADDR_WIDTH;\
integer II;\
reg [DATA_WIDTH-1:0] mem [RAM_DEPTH-1:0];\
\
initial begin\
    wr_clk=0;\
    wr_rst_n=0;\
    wr_en=0;\
    wr_addr=0;\
    wr_data=0;\
    rd_clk=0;\
    rd_rst_n=0;\
    rd_en=0;\
    #50;\
    wr_rst_n=1;\
    rd_rst_n=1;\
end\
\
always #5 wr_clk=~wr_clk;\
always #10 rd_clk=~rd_clk;\
\
initial begin\
    #50;\
    send_wr;\
    send_rd;\
    #50;\
    $finish;\
end\
\
task send_wr;\
begin\
    for(II=0;II<8;II=II+1)begin\
        @(posedge wr_clk)begin\
            wr_en <= 1'b1;\
            wr_data <=II+1;\
        end\
    end\
        @(posedge wr_clk)begin/\
            wr_en <= 1'b0;\
            wr_data <= 8'h0;\
        end\
     repeat(10) @(posedge wr_clk);\
     end\
endtask\
\
task send_rd;\
begin\
     for(II=0;II<8;II=II+1)begin\
     @(posedge rd_clk)begin\
            rd_en <= 1'b1;\
    end\
    @(posedge rd_clk)begin\
            rd_en <= 1'b0;\
        end\
end\
endtask\
\
\
generate\
genvar i;\
	for(i=0;i<RAM_DEPTH;i=i+1)\
         begin
\f1 \'a3\'ba
\f0 mempry\
		always @ (posedge wr_clk or negedge wr_rst_n)\
		begin\
			if(!wr_rst_n)\
				mem[i] <= \{DATA_WIDTH\{1'b0\}\};\
			else if(wr_en & (wr_addr==i))\
				mem[i] <= wr_data;\
		end \
	end \
endgenerate\
	\
assign rd_data = mem[rd_addr];\
 \
initial begin\
$fsdbDumpfile("soc.fsdb");\
$fsdbDumpvars;\
end\
	\
endmodule}