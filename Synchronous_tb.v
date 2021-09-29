{\rtf1\ansi\ansicpg936\cocoartf2580
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 module fifo_tb(); \
            parameter DATA_WIDTH = 8;\
            parameter FIFO_DEPTH = 8;\
            parameter AFULL_DEPTH = FIFO_DEPTH - 1;\
            parameter AEMPTY_DEPTH =1;\
            parameter ADDR_WIDTH =3;  \
            parameter RDATA_MODE =1;\
        \
             reg                                            clk    ;\
             reg                                            rst_n  ;\
             reg                                            wr_en  ;\
             reg        [DATA_WIDTH-1:0]                    wr_data;\
             reg                                            rd_en  ;    \
             wire       [DATA_WIDTH-1:0]                    rd_data;       \
             wire                                           full   ;\
             wire                                           almost_full;\
             wire                                           empty;\
             wire                                           almost_empty;\
             wire                                           overflow;\
             wire                                           underflow;\
             \
             integer II;\
             \
             fifo #(\
            .DATA_WIDTH (DATA_WIDTH),\
            .FIFO_DEPTH (FIFO_DEPTH),\
            .ADDR_WIDTH (ADDR_WIDTH),   \
            .RDATA_MODE (RDATA_MODE)\
             )inst_fifo(\
             .clk                 (clk) ,\
             .rst_n              (rst_n),\
             .wr_en            (wr_en),\
             .wr_data         (wr_data),\
             .rd_en             (rd_en),     \
             .rd_data          (rd_data),       \
             .full                  (full),\
             .almost_full      (almost_full),\
             .empty              (empty),\
             .almost_empty (almost_empty),\
             .overflow          (overflow),\
             .underflow        (underflow)\
             );\
\
initial begin\
    #0;\
    clk=0;\
    rst_n=0;\
    wr_en=0;\
    wr_data=0;\
    rd_en=0;\
    #200;\
    rst_n=1;\
end\
\
always #5 clk=~clk;\
\
initial begin\
    #500;\
    send_wr;\
    send_rd;\
    #50;\
    $finish;\
end\
\
task send_wr;\
begin\
    for(II=0;II<8;II=II+1)begin\
        @(posedge clk)begin\
            wr_en    <= 1'b1;\
            wr_data <=II+1;\
        end\
    end\
        @(posedge clk)begin\
            wr_en <= 1'b0;\
            wr_data <= 8'h0;\
        end\
     repeat(10) @(posedge clk);\
     end\
endtask\
\
task send_rd;\
begin\
     for(II=0;II<8;II=II+1)begin\
     @(posedge clk)begin\
            rd_en <= 1'b1;\
    end\
    @(posedge clk)begin\
            rd_en <= 1'b0;\
        end\
end\
endtask\
\
initial begin\
$fsdbDumpfile("soc.fsdb");\
$fsdbDumpvars;\
end\
\
endmodule}