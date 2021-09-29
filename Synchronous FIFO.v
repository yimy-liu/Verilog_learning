{\rtf1\ansi\ansicpg936\cocoartf2580
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset134 PingFangSC-Regular;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 module fifo #(\
            parameter DATA_WIDTH = 8,\
            parameter FIFO_DEPTH = 8,\
            parameter AFULL_DEPTH = FIFO_DEPTH - 1,\
            parameter AEMPTY_DEPTH =1,          \
            parameter RDATA_MODE =0\
             )(\
             input                                              clk    ,\
             input                                              rst_n  ,\
             input                                              wr_en  ,\
             input        [DATA_WIDTH-1:0]       wr_data,\
             input                                               rd_en  ,     \
             output reg   [DATA_WIDTH-1:0]    rd_data,       \
             output                                             full   ,\
             output                                             almost_full,\
             output                                             empty,\
             output                                             almost_empty,\
             output reg                                       overflow,\
             output reg                                       underflow\
             );\
localparam ADDR_WIDTH = $clog2(FIFO_DEPTH); \
\
reg [ADDR_WIDTH-1:0]   wr_ptr;         //locate the write addr\
reg [ADDR_WIDTH-1:0]   rd_ptr;         //locate the read addr\
reg [ADDR_WIDTH:0]     fifo_cnt;        //count the used spaces\
reg [DATA_WIDTH-1:0]   buf_mem[0:FIFO_DEPTH -1];    //buffer memory\
\
\
integer II;\
\
always @ (posedge clk or negedge rst_n)\
begin\
    if(!rst_n)\
         fifo_cnt <= \{\{ADDR_WIDTH+1\}\{1'b0\}\};\
        else  if(wr_en && ~full && rd_en && ~empty)\
               fifo_cnt <= fifo_cnt;\
        else if (wr_en && ~full).   //
\f1 write is valid
\f0 \
               fifo_cnt <= fifo_cnt + 1'b1;\
        else if (rd_en && ~empty)//
\f1 read is valid
\f0 \
               fifo_cnt <= fifo_cnt - 1'b1;   \
end\
\
//
\f1 write 
\f0 \
always @ (posedge clk or negedge rst_n)\
begin\
    if(!rst_n)\
        wr_ptr <= \{ADDR_WIDTH\{1'b0\}\};\
    else begin\
        if (wr_ptr == FIFO_DEPTH-1)\
            wr_ptr <=  \{ADDR_WIDTH\{1'b0\}\};\
        else if(wr_en && ~full)\
            wr_ptr <= wr_ptr +1'b1;\
        end\
end\
\
//
\f1 read
\f0 \
always @ (posedge clk or negedge rst_n)\
begin\
    if(!rst_n)\
        rd_ptr <= \{ADDR_WIDTH\{1'b0\}\};\
    else begin\
        if (rd_ptr == FIFO_DEPTH-1)\
            rd_ptr <=  \{ADDR_WIDTH\{1'b0\}\};\
        else if(rd_en && ~empty)\
            rd_ptr <= rd_ptr +1'b1;\
        end\
end\
\
//
\f1 data memory
\f0 \
always @ (posedge clk or negedge rst_n)\
begin\
    if(!rst_n)\
        for(II=0;II<FIFO_DEPTH;II=II+1)\
            buf_mem[II] <= \{DATA_WIDTH\{1'b0\}\};\
    else if(wr_en && ~full)\
        buf_mem[wr_ptr] <= wr_data;\
    end\
\
\
generate\
    if(RDATA_MODE==1'b0)begin\
    always @ (*)\
         rd_data = buf_mem[rd_ptr];\
        end\
    else begin\
        always @ (posedge clk or negedge rst_n)\
        begin\
             if(!rst_n)\
                rd_data <= \{DATA_WIDTH\{1'b0\}\};\
             else if (rd_en && ~empty)\
                rd_data <= buf_mem[rd_ptr];\
        end\
    end\
endgenerate\
    \
always @ (posedge clk or negedge rst_n)//
\f1 overflow
\f0 \
begin\
    if(!rst_n)\
        overflow <= 1'b0;\
    else if (wr_en && full)\
        overflow <= 1'b1;\
end\
\
always @ (posedge clk or negedge rst_n)//
\f1 underflow
\f0 \
begin\
    if(!rst_n)\
        underflow <= 1'b0;\
    else if (rd_en && empty)\
        underflow <= 1'b1;\
end\
\
//
\f1 generate empty/full signal
\f0 \
assign  full = fifo_cnt==FIFO_DEPTH;\
assign empty=fifo_cnt== \{\{ADDR_WIDTH+1\}\{1'b0\}\};\
assign almost_full = fifo_cnt >= AFULL_DEPTH;\
assign almost_empty = fifo_cnt <= AEMPTY_DEPTH;\
\
endmodule}