// State machine that counts up when button is pressed

module fsm_moore(

    // Inputs
    input        clk,
    input        rst_btn,
    input        go_btn,

    // Outputs
    output reg [3:0] led,
    output reg       done_sig
);

    // State definitions
    localparam STATE_IDLE      = 2'd0;
    localparam STATE_COUNTING  = 2'd1;
    localparam STATE_DONE      = 2'd2;

    // Constants
    localparam MAX_CLK_COUNT   = 24'd1500000;
    localparam MAX_LED_COUNT   = 4'hF;

    // Internal signals
    wire rst;
    wire go;

    // Internal registers
    reg        div_clk = 1'b0;
    reg [23:0] clk_count = 24'd0;
    reg [1:0]  state = STATE_IDLE;

    // Buttons are active-low
    assign rst = ~rst_btn;
    assign go  = ~go_btn;

    // Clock Divider
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_count <= 24'd0;
            div_clk <= 1'b0;
        end else if (clk_count == MAX_CLK_COUNT) begin
            clk_count <= 24'd0;
            div_clk <= ~div_clk;
        end else begin
            clk_count <= clk_count + 1'b1;
        end
    end

    // State Machine
    always @(posedge div_clk or posedge rst) begin
        if (rst) begin
            state <= STATE_IDLE;
        end else begin
            case (state)

                STATE_IDLE: begin
                    if (go)
                        state <= STATE_COUNTING;
                end

                STATE_COUNTING: begin
                    if (led == MAX_LED_COUNT)
                        state <= STATE_DONE;
                end

                STATE_DONE: begin
                    state <= STATE_IDLE;
                end

                default: state <= STATE_IDLE;

            endcase
        end
    end

    // LED Counter
    always @(posedge div_clk or posedge rst) begin
        if (rst) begin
            led <= 4'd0;
        end else if (state == STATE_COUNTING) begin
            led <= led + 1'b1;
        end else begin
            led <= 4'd0;
        end
    end

    // Done Signal (Moore Output)
    always @(*) begin
        done_sig = (state == STATE_DONE);
    end

endmodule