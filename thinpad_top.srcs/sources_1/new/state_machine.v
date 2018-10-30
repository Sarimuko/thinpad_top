`default_nettype wire
module state_machine(
	input clk_50M,
	input clk,
	input rst,

	output [15:0] leds,
	inout [31:0] data,
	output [19:0] address,
	input [31:0] push_buttons,

	output oe, 
	output we,

	input rxd,
	output txd
	);

reg [3:0] state = 0;//状态机总状态
reg [31:0] data_received;// 接受到的所有数据
reg [19:0] address_buffer;// 存储的地址
reg received_done = 0; // 是否32位数据已经接受完毕
reg send_begin = 0;// 是否开始发送数据

reg oe_r = 1;
reg we_r = 1;// 默认不使能

wire [7:0] ext_uart_rx; // 接收到的并行数据
reg  [7:0] ext_uart_buffer, ext_uart_tx; // 接收到的数据的缓冲区，待发送的数据缓冲区
wire ext_uart_ready, ext_uart_busy; // 是否已经接收到一帧完整的数据，是否正在发送器忙
reg ext_uart_start, ext_uart_avai; // 是否开始发送缓冲区中的信号，是否数据已经可用

always @(posedge clk or posedge rst) begin
	if (rst) begin
		// reset
		state <= 0;
	end
	else if (clk) begin
		case(state)
			4'b0000: if (received_done) begin
			data <= data_received;
			leds <= data_received[15:0];
			state <= 4'b0001;	
			end
			else begin
				state <= 0;
			end
			4'b0001: 
			address <= push_buttons;
			state <= 4'b0010;
			4'b0010:
			we <= 0;//写数据
			state <= 4'b0011;
			4'b0011:
			we <= 1;
			address <= push_buttons;
			state <= 4'b0100;
			4'b0100:
			oe <= 0;
			state <= 4'b0101;
			4'b0101:
			data_received <= data;//将读到的数据放到缓冲区
			leds <= data[15:0];
			oe <= 1;
			state <= 0;
			default: state <= 0;
		endcase
	end
end

//直连串口接收发送演示，从直连串口收到的数据再发送出去

async_receiver #(.ClkFrequency(50000000),.Baud(9600)) //接收模块，9600无检验位
    ext_uart_r(
        .clk(clk_50M),                       //外部时钟信号
        .RxD(rxd),                           //外部串行信号输入
        .RxD_data_ready(ext_uart_ready),  //数据接收到标志
        .RxD_clear(ext_uart_ready),       //清除接收标志
        .RxD_data(ext_uart_rx)             //接收到的一字节数据
    );
    
// 接受数据状态机
reg [3:0]rec_state = 0;
always @(posedge clk_50M) begin
	received_done <= 0;//默认是0
	if(ext_uart_ready)begin // 如果接收到一帧数据，把它依次放在缓冲区里
		case (rec_state)
			4'b0000: data[31:24] <= ext_uart_rx; rec_state <= 4'b0001;
			4'b0001: data[23:16] <= ext_uart_rx; rec_state <= 4'b0010;
			4'b0010: data[15:8] <= ext_uart_rx; rec_state <= 4'b0011;
			4'b0100: data[7:0] <= ext_uart_rx; received_done <= 1; rec_state <= 4'b0000;
			default: rec_state <= 0;
		endcase
	end
end

/*always @(posedge clk_50M) begin //接收到缓冲区ext_uart_buffer
    if(ext_uart_ready)begin
        ext_uart_buffer <= ext_uart_rx;
        ext_uart_avai <= 1;
    end else if(!ext_uart_busy && ext_uart_avai)begin 
        ext_uart_avai <= 0;
    end
end*/

reg tra_state = 0;
always @(posedge clk_50M) begin
		case(tra_state)
			4'b0000: if (send_begin && !ext_uart_busy) begin // 如果不忙并且开始发送
				ext_uart_tx <= data[31:24];
				ext_uart_start <= 1;
				send_begin <= 0;//将开始发送信号置为零
				tra_state <= 1;
			end
			else begin
				tra_state <= 0;
			end
			4'b0001: if (ext_uart_busy) begin
				tra_state <= 1;
			end
			else begin
				ext_uart_tx <= data[23:16];
				ext_uart_start <= 1;
				tra_state <= 2;
			end
			4'b0010:
			if (ext_uart_busy) begin
				tra_state <= 4'b0010;
			end
			else begin
				ext_uart_tx <= data[15:8];
				ext_uart_start <= 1;
				tra_state <= 3;
			end
			4'b0011:
			if (ext_uart_busy) begin
				tra_state <= 4'b0011;
			end
			else begin
				ext_uart_tx <= data[7:0];
				ext_uart_start <= 1;
				tra_state <= 0;
			end
			default: tra_state <= 0;

		endcase
	end
end

async_transmitter #(.ClkFrequency(50000000),.Baud(9600)) //发送模块，9600无检验位
    ext_uart_t(
        .clk(clk_50M),                  //外部时钟信号
        .TxD(txd),                      //串行信号输出
        .TxD_busy(ext_uart_busy),       //发送器忙状态指示
        .TxD_start(ext_uart_start),    //开始发送信号
        .TxD_data(ext_uart_tx)        //待发送的数据
    );
endmodule