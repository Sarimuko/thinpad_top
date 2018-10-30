`default_nettype wire
module state_machine(
	input clk_50M,
	input clk,
	input rst,

	output reg[15:0] leds,
	inout [31:0] data,
	output reg[19:0] address,
	input [31:0] push_buttons,

	output wire oe, 
	output wire we,

	output txd,
	input rxd,

	    //CPLD串口控制器信号
    output uart_rdn,         //读串口信号，低有效
    output uart_wrn,         //写串口信号，低有效
    input wire uart_dataready,    //串口数据准备好
    input wire uart_tbre,         //发送数据标志
    input wire uart_tsre        //数据发送完毕标志
	);

reg [3:0] state = 0;//状态机总状态
reg [31:0] data_received;// 从串口接收到的数据的缓冲区
reg [31:0] data_ram; // 从存储读到的数据的缓冲区
reg [19:0] address_buffer;// 存储的地址
reg received_done = 0; // 是否32位数据已经接受完毕
reg send_begin = 0;// 是否开始发送数据

reg oe_r = 1, we_r = 1;

assign oe = oe_r;
assign we = we_r;//内存读写使能

reg rdn_r = 1, wrn_r = 1;
assign uart_rdn = rdn_r;
assign uart_wrn = wrn_r;//串口读写使能

reg [31:0] data_w; //写数据缓存
reg [31:0] data_r; //读数据缓存

wire [7:0] ext_uart_rx; // 接收到的并行数据
reg  [7:0] ext_uart_buffer, ext_uart_tx; // 接收到的数据的缓冲区，待发送的数据缓冲区
wire ext_uart_ready, ext_uart_busy; // 是否已经接收到一帧完整的数据，是否正在发送器忙
reg ext_uart_start, ext_uart_avai; // 是否开始发送缓冲区中的信号，是否数据已经可用

assign  data = (we_r == 0 || wrn_r == 0)? data_w: 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz; // 写的时候置成data_w,否则置成高阻态

always @(oe_r, rdn_r)
if(oe_r == 0 || rdn_r == 0)
data_r = data;// 读数据缓存



always @(posedge clk or posedge rst) begin
	if (rst) begin
		// reset
		state <= 0;
	end
	else if (clk) begin
		case(state)
			4'b0000:begin //状态1：开始从串口中接受数据
			 if (uart_dataready) begin
			// data <= data_received;
			// leds <= data_received[15:0];
			rdn_r <= 0;//开始读串口数据
			wrn_r <= 1;
			state <= 4'b0110;	
			end
			else begin
			    // leds <= data_received[15:0];
				state <= 0;
			end
			end
			4'b0110:begin//状态2：显示从串口中得到的数据
			data_w <= data_r[7:0];
			leds[7:0] <= data_r[7:0];
			rdn_r <= 1;//将读使能置为1
			state <= 4'b0001;
			end
			4'b0001: begin //3：接收并显示从拨码开关得到的数据地址
			address <= push_buttons[19:0];
			leds <= push_buttons[15:0];
			state <= 4'b0010;
			end
			4'b0010: begin//4：开始写数据
			rdn_r <= 1;
			wrn_r <= 1;
			we_r <= 0;//写数据
			oe_r <= 1;
			state <= 4'b0011;
			end
			4'b0011: begin//5：接收并显示从拨码开关获得的地址
			we_r <= 1;
			oe_r <= 1;
			address <= push_buttons;
			state <= 4'b0100;
			end
			4'b0100: begin//6：开始读
			rdn_r <= 1;
			wrn_r <= 1;
			oe_r <= 0; // 读数据
			we_r <= 1;
			state <= 4'b0101;
			end
			4'b0101: begin//7：显示读到的数据
			data_w <= data_r;//将读到的数据放到缓冲区
			leds <= data_r[15:0];//显示从内存中读到的数据
			// leds <= data_r[15:0];
			oe_r <= 1;
			we_r <= 1;
			state <= 4'b0111;
			end
			4'b0111:begin //8：将读到的数据发出去
			wrn_r <= 0; //开始发送串口
			rdn_r <= 1;
		    state <= 4'b1000;
			end
			4'b1000:begin
			wrn_r <= 1;
			rdn_r <= 1;
			state <= 4'b0000;
			end
			default: state <= 0;
		endcase
	end
end


    
// 接受数据状态机
/*reg [3:0]rec_state = 0;
always @(posedge clk_50M) begin
	received_done <= 0;//默认是0
	 // 如果接收到一帧数据，把它依次放在缓冲区里
	 //leds[3:0] <= rec_state;
	 rdn_r <= 0;
	 leds[4] <= uart_dataready;
		case (rec_state)
			4'b0000: if (uart_dataready) begin rdn_r <= 0; wrn_r <= 1; rec_state <= 4'b0001; end
			4'b0001: if (uart_dataready)begin rdn_r <= 0; wrn_r <= 1; data_received[31:24] <= data_r[7:0]; rec_state <= 4'b0010; end
			4'b0010: if (uart_dataready)begin rdn_r <= 0; wrn_r <= 1; data_received[23:16] <= data_r[7:0]; rec_state <= 4'b0011; end
			4'b0011: if (uart_dataready)begin rdn_r <= 0; wrn_r <= 1; data_received[15:8] <= data_r[7:0]; rec_state <= 4'b0100; end
			4'b0100: begin data_received[7:0] <= data_r[7:0]; received_done <= 1; rec_state <= 4'b0000; end
			default: rec_state <= 0;
		endcase

end*/

/*always @(posedge clk_50M) begin //接收到缓冲区ext_uart_buffer
    if(ext_uart_ready)begin
        ext_uart_buffer <= ext_uart_rx;
        ext_uart_avai <= 1;
    end else if(!ext_uart_busy && ext_uart_avai)begin 
        ext_uart_avai <= 0;
    end
end*/

/*reg tra_state = 0;
always @(posedge clk_50M) begin
		case(tra_state)
			4'b0000: if (send_begin && !uart_tbre) begin // 如果不忙并且有开始发送信号
				data_w[7:0] <= data_ram[31:24];
				rdn_r <= 1; wrn_r <= 0; 
				send_begin <= 0;//将开始发送信号置为零
				tra_state <= 1;
			end
			else begin
				tra_state <= 0;
			end
			4'b0001: if (!uart_tbre && uart_tsre) begin
				data_w[7:0] <= data_ram[23:16];
				rdn_r <= 1; wrn_r <= 0; 
				tra_state <= 2;
			end
			4'b0010:
			if (!uart_tbre && uart_tsre) begin
				data_w[7:0] <= data_ram[15:8];
				rdn_r <= 1; wrn_r <= 0; 
				tra_state <= 3;
			end
			4'b0011:
			if (!uart_tbre && uart_tsre)begin
				data_w[7:0] <= data_ram[7:0];
				rdn_r <= 1; wrn_r <= 0; 
				tra_state <= 0;
			end
			default: tra_state <= 0;

		endcase
	end*/
endmodule