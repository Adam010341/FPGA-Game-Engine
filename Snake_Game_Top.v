module Snake_Game_Top (
    input       MAX10_CLK1_50,  // FPGA 50MHz 時鐘
    input [9:0] SW,             // 開關 (Reset, Pause, Speed Mode)
    input [1:0] KEY,            // 板載按鈕 (可作輔助)
    
    // 16 鍵按鈕矩陣介面 (假設為 4x4 掃描式)
    output [3:0] keypad_row,
    input  [3:0] keypad_col,
    
    // 16 * 8 點矩陣介面 (外接板)
    output [7:0] matrix_row_sel, // 行選擇
    output [15:0] matrix_col_data, // 兩個 8x8 的列數據
    
    // DE-10-Lite 七段顯示器 (6 位)
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
    
    // 板載 LED (顯示狀態或速度)
    output [9:0] LEDR
);

    // 內部連線訊號
    wire clk_scan;           // 顯示掃描時鐘
    wire clk_game;           // 遊戲移動時鐘
	 wire clk_1hz;
    wire [3:0] move_dir;     // 上下左右指令
    wire [127:0] game_map;   // 16x8 的畫面資料
    wire [7:0] current_score;
    wire [15:0] game_time;   // BCD 格式 mm:ss
    wire [1:0] current_state; // 00-IDLE, 01-PLAY, 10-PAUSE, 11-DEAD

    // 1. 時鐘分頻模組
    Clock_Divider clk_gen (
        .clk_50m(MAX10_CLK1_50),
        .reset(SW[0]),
        .speed_level(current_score / 2), // 根據分數自動提速
        .clk_scan(clk_scan),
        .clk_game(clk_game),
		  .clk_1hz(clk_1hz)
    );

    // 2. 16 鍵按鈕掃描與去彈跳
    Keypad_Scanner input_unit (
        .clk_scan(clk_scan),
        .reset(SW[0]),          //Edited by Coen
        .key_row(keypad_row),
        .key_col(keypad_col),
        .move_dir(move_dir)   // 輸出上下左右指令
    );

    // 3. 遊戲核心邏輯 (FSM + Snake Logic)
    Game_Engine logic_unit (
        .clk_game(clk_game),
		  .clk_1hz(clk_1hz),
        .reset(SW[0]),
        .pause(SW[1]),
        .move_dir(move_dir),
        .game_map(game_map),      // 輸出點矩陣地圖
        .score(current_score),
        .time_bcd(game_time),
        .state(current_state)
    );

    // 4. 點矩陣驅動模組 (16x8)
    Dot_Matrix_Driver display_unit (
        .clk_scan(clk_scan),
		  .reset(SW[0]),
        .game_map(game_map),
        .row_sel(matrix_row_sel),
        .col_data(matrix_col_data)
    );

    // 5. 七段顯示器 BCD 驅動 (Time & Score)
    Seven_Seg_Controller hex_unit (
        .score(current_score),
        .time_bcd(game_time),
        .hex0(HEX0), .hex1(HEX1), .hex2(HEX2), 
        .hex3(HEX3), .hex4(HEX4), .hex5(HEX5)
    );

    // 6. LED 狀態顯示
    assign LEDR = 10'b1 << ((current_score / 2) > 4 ? 4 : (current_score / 2));

endmodule


module Clock_Divider (
    input clk_50m,
    input reset, // 正緣觸發
    input [3:0] speed_level,
    output reg clk_scan,  // ~1kHz
    output reg clk_game,   // 1Hz 遞減至 0.1Hz
	 output reg clk_1hz
);
    // TODO: 實作計數器與動態分頻邏輯
	 
	 wire [31:0] game_limit;
    wire [31:0] reduction = speed_level * 32'd5000000; // 每級減少的量
    
    // 保護邏輯：如果 (起始 22.5M - 減少量) 還大於 (底限 2.5M)，就相減
    // 否則鎖定在 2.5M (最快速度)
    assign game_limit = (32'd22500000 > reduction + 32'd2500000) ? 
                        (32'd22500000 - reduction) : 
                        32'd2500000;

	 reg [31:0] count_scan;
	 reg [31:0] count_game;
	 reg [31:0] count_1hz;
	 
	 always @(posedge clk_50m or posedge reset) begin
		if(reset) begin
			count_scan <= 32'd0;
			count_game <= 32'd0;
			count_1hz <= 32'd0;
			clk_scan <= 0;
			clk_game <= 0;
			clk_1hz <= 0;
		end
		else begin
			if(count_1hz == 32'd25000000 - 32'd1) begin
				count_1hz <= 32'd0;
				clk_1hz <= ~clk_1hz;
			end
			else begin
				count_1hz <= count_1hz + 32'd1;
			end
			
			
			if(count_scan == 32'd25000 - 32'd1) begin
				count_scan <= 32'd0;
				clk_scan <= ~clk_scan;
			end
			else begin
				count_scan <= count_scan + 32'd1;
			end
			
			if(count_game >= game_limit - 32'd1) begin
                count_game <= 32'd0;
                clk_game <= ~clk_game;
         end
			else begin
				count_game <= count_game + 32'd1;
			end
		
		end
	end


endmodule

module Keypad_Scanner (
    input clk_scan,
    input reset,
    output reg [3:0] key_row,
    input [3:0] key_col,
    output reg [3:0] move_dir
);
    // TODO: 4x4 矩陣掃描邏輯與 Debounce
	
	initial begin
		move_dir <= 4'd8;
		key_row <= 4'b1110;
	end

	always @(posedge clk_scan or posedge reset) begin
	        if (reset) begin
                move_dir <= 4'd0; 
                key_row <= 4'b1110;
        end else begin
			case({key_row, key_col})
				8'b1110_1101 : move_dir <= 4'd4;
				8'b1101_1110 : move_dir <= 4'd8;
				8'b1101_1011 : move_dir <= 4'd2;
				8'b1011_1101 : move_dir <= 4'd6;
				default : move_dir <= move_dir;
			endcase
			case(key_row)
				4'b1110 : key_row <= 4'b1101;
				4'b1101 : key_row <= 4'b1011;
				4'b1011 : key_row <= 4'b0111;
				4'b0111 : key_row <= 4'b1110;
				default : key_row <= 4'b1110;
			endcase
		end
	end


endmodule


module Game_Engine (
    input clk_game,
	 input clk_1hz,
	 input clk_50m,
    input reset,
    input pause,
    input [3:0] move_dir,
    output reg [127:0] game_map, // 16x8 bit map
    output reg [7:0] score,
    output reg [15:0] time_bcd,  // [15:12]m, [11:8]m, [7:4]s, [3:0]s
    output reg [1:0] state       // 00: IDLE, 01: PLAY, 10: PAUSE, 11:DEAD
);
    parameter S_IDLE  = 2'b00;
    parameter S_PLAY  = 2'b01;
    parameter S_PAUSE = 2'b10;
    parameter S_DEAD  = 2'b11;
    
    parameter KEY_UP    = 4'd6;
    parameter KEY_DOWN  = 4'd4;
    parameter KEY_LEFT  = 4'd2;
    parameter KEY_RIGHT = 4'd8;
    
    reg [3:0] snake_x [0:31]; 
    reg [2:0] snake_y [0:31];
    reg [4:0] head_ptr; 
    reg [4:0] tail_ptr; 
    
    reg [3:0] current_dir; // 目前實際移動方向 (儲存最後有效的按鍵值)
    reg [3:0] head_x, next_x;
    reg [2:0] head_y, next_y;
    reg [3:0] food_x;
    reg [2:0] food_y;
    
    reg [15:0] lfsr;
	 
	 always @(posedge clk_1hz or posedge reset) begin
        if (reset) begin
            time_bcd <= 0;
        end else if (state == S_PLAY) begin // 只有在遊戲進行中才計時
            if (time_bcd[3:0] == 9) begin
                time_bcd[3:0] <= 0;
                if (time_bcd[7:4] == 5) begin
                    time_bcd[7:4] <= 0;
                    if (time_bcd[11:8] == 9) begin
                        time_bcd[11:8] <= 0;
                        time_bcd[15:12] <= time_bcd[15:12] + 1;
                    end else begin
                        time_bcd[11:8] <= time_bcd[11:8] + 1;
                    end
                end else begin
                    time_bcd[7:4] <= time_bcd[7:4] + 1;
                end
            end else begin
                time_bcd[3:0] <= time_bcd[3:0] + 1;
            end
        end
    end
    
    always @(posedge clk_game or posedge reset) begin
        if (reset) begin
            state <= S_IDLE;
            score <= 0;
            // 初始化蛇
            head_ptr <= 2;
            tail_ptr <= 0;
            snake_x[0] <= 0; snake_y[0] <= 0;
            snake_x[1] <= 1; snake_y[1] <= 0;
            snake_x[2] <= 2; snake_y[2] <= 0;
            current_dir <= KEY_RIGHT; // 預設向右
            // 初始化 LFSR
            lfsr <= 16'hACE1; 
            food_x <= 5; food_y <= 5;
        end else begin
            case (state)
                S_IDLE: begin
                    if (move_dir == KEY_UP || move_dir == KEY_DOWN || 
                        move_dir == KEY_LEFT || move_dir == KEY_RIGHT) 
                        state <= S_PLAY;
                end

                S_PLAY: begin
                    if (pause) begin
                        state <= S_PAUSE;
                    end else begin
								if (move_dir == KEY_UP && current_dir != KEY_DOWN) current_dir <= KEY_UP;
                        else if (move_dir == KEY_DOWN && current_dir != KEY_UP) current_dir <= KEY_DOWN;
                        else if (move_dir == KEY_LEFT && current_dir != KEY_RIGHT) current_dir <= KEY_LEFT;
                        else if (move_dir == KEY_RIGHT && current_dir != KEY_LEFT) current_dir <= KEY_RIGHT; 
                        
                        //計算下一步座標
                        head_x = snake_x[head_ptr];
                        head_y = snake_y[head_ptr];
                        
                        case (current_dir)
                            KEY_UP:    begin next_x = head_x; next_y = head_y - 1; end
                            KEY_DOWN:  begin next_x = head_x; next_y = head_y + 1; end
                            KEY_LEFT:  begin next_x = head_x - 1; next_y = head_y; end
                            KEY_RIGHT: begin next_x = head_x + 1; next_y = head_y; end
                            default:   begin next_x = head_x + 1; next_y = head_y; end
                        endcase

                       // --- C. 死亡判定 (撞牆) ---
                        // 檢查邊界 [0,15] 和 [0,7]
                        if ((current_dir == KEY_RIGHT && head_x == 15) ||
                            (current_dir == KEY_LEFT  && head_x == 0)  ||
                            (current_dir == KEY_DOWN  && head_y == 7)  ||
                            (current_dir == KEY_UP    && head_y == 0)) begin
                            state <= S_DEAD;
                        end
                        // --- D. 死亡判定 (自撞) ---
                        // 檢查下一個位置是否已有蛇身
								
          
                        else if (game_map[(7 - next_y) * 16 + (15 - next_x)] == 1 && 
                                !(next_x == snake_x[tail_ptr] && next_y == snake_y[tail_ptr])&& // 不是尾巴
										  !(next_x == food_x && next_y == food_y)) begin
                            state <= S_DEAD;
                        end
                        else begin
                            // --- E. 移動有效 ---
                            head_ptr <= head_ptr + 1;
                            snake_x[(head_ptr + 1) & 5'd31] <= next_x;
                            snake_y[(head_ptr + 1) & 5'd31] <= next_y;

                            // --- F. 吃食物判定  ---
                            if (next_x == food_x && next_y == food_y) begin
                                if (score < 99) score <= score + 1;
                                
                                lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
                                
                                // 2. 暫存新座標 (用 blocking assignment 立即生效)
                                food_x <= lfsr[3:0];
                                food_y <= lfsr[6:4];
                                if (lfsr[6:4] > 7) food_y <= lfsr[6:4] & 3'b111; // 防止Y出界

                                // 3. 直接檢查地圖有沒有亮！
                                if (game_map[(7 - (lfsr[6:4] & 3'b111)) * 16 + (15 - lfsr[3:0])] == 1) begin
                                    // 4. 如果亮了(有蛇)，就強制移開 往右移 3 格，再往下移 1 格 (確保不會原地打轉)
                                    food_x <= (lfsr[3:0] + 3) & 4'b1111; 
                                    food_y <= (lfsr[6:4] + 1) & 3'b0111;
                                end

                            end else begin
                                tail_ptr <= tail_ptr + 1; 
                            end
                            
                        end
                    end
                end

                S_PAUSE: begin
                    if (!pause) state <= S_PLAY;
                end

                S_DEAD: begin
                    // 遊戲結束
                end
            endcase
        end
    end

    // --- 2. 畫面生成邏輯 ---
    integer i;
    
    always @(*) begin
        // 清空地圖
        game_map = 128'd0;
        if (reset) begin
            game_map = 128'd0; 
        end
        else if (state == S_DEAD) begin
            // 死亡全亮
            game_map = {128{1'b1}}; 
        end 
        else begin 
            // 只有在 PLAY 或 PAUSE 時才畫蛇，IDLE 時不畫
            // 1. 繪製蛇身
            for (i = 0; i < 32; i = i + 1) begin
                if ((tail_ptr <= head_ptr && i >= tail_ptr && i <= head_ptr) ||
                    (tail_ptr > head_ptr && (i >= tail_ptr || i <= head_ptr))) begin
                    // 維持你的座標公式
                    game_map[(7-snake_y[i]) * 16 + (15 - snake_x[i])] = 1'b1;
                end
				end

            // 2. 繪製食物
            game_map[(7-food_y) * 16 + (15 - food_x)] = 1'b1;
            
        end 
    end
    
endmodule


module Dot_Matrix_Driver (
    input clk_scan,
	 input reset,
    input [127:0] game_map,
    output reg [7:0] row_sel,
    output reg [15:0] col_data
);
	reg [2:0] row_count;
	initial row_count = 3'd0;
	
	always @(posedge clk_scan) begin
		if (reset) begin
            // Reset 時強制關閉所有輸出
            row_sel <= 8'b11111111; // 假設低電位觸發，全1為關 (看你硬體極性)
            col_data <= 16'd0;      // 資料清空
            row_count <= 3'd0;
		end else begin 
			if(row_count == 3'd7) row_count <= 3'd0;
			else row_count <= row_count + 3'd1;
		
			row_sel <= ~(8'b00000001 << row_count);
			col_data <= game_map[row_count * 16 +: 16];
	 end
	 end
endmodule

module Seven_Seg_Controller (
    input [7:0] score,
    input [15:0] time_bcd,
    output reg [6:0] hex0, hex1, hex2, hex3, hex4, hex5
);

	function [6:0] seg7;
		input [3:0] d;
		begin
			case(d)
				4'd0: seg7 = 7'b1000000;
				4'd1: seg7 = 7'b1111001;
				4'd2: seg7 = 7'b0100100;
				4'd3: seg7 = 7'b0110000;
				4'd4: seg7 = 7'b0011001;
				4'd5: seg7 = 7'b0010010;
				4'd6: seg7 = 7'b0000010;
				4'd7: seg7 = 7'b1111000;
				4'd8: seg7 = 7'b0000000;
				4'd9: seg7 = 7'b0010000;
				default: seg7 = 7'b1111111;
			endcase
		end
	endfunction
	
	wire [3:0] tens = score / 10;
	wire [3:0] ones = score % 10;
	
	always @(*) begin
		hex0 = 7'b1111111;
		hex1 = 7'b1111111;
		hex2 = 7'b1111111;
		hex3 = 7'b1111111;
		hex4 = 7'b1111111;
		hex5 = 7'b1111111;
		
		hex0 = seg7(time_bcd[3:0]);
		hex1 = seg7(time_bcd[7:4]);
		hex2 = seg7(time_bcd[11:8]);
		hex3 = seg7(time_bcd[15:12]);
		
		hex4 = seg7(ones);
		if(tens == 0) hex5 = 7'b1000000;
		else hex5 = seg7(tens);
	end
endmodule

