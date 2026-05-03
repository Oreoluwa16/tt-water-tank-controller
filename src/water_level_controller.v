module WaterLevelController (
    input  wire clk,
    input  wire reset_n,
    input  wire s1_high,
    input  wire s0_low,
    output reg  pump_out,
    output reg  error_flag
);

    parameter EMPTY    = 2'b00;
    parameter FILLING  = 2'b01;
    parameter FULL     = 2'b10;
    parameter DRAINING = 2'b11;

    reg [1:0] current_state, next_state;

    wire [1:0] sensor_bus = {s1_high, s0_low};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= EMPTY;
        else
            current_state <= next_state;
    end

    always @(*) begin
        next_state = current_state;
        pump_out   = 1'b0;
        error_flag = 1'b0;

        case (current_state)
            EMPTY: begin
                pump_out = 1'b1;
                if      (sensor_bus == 2'b01) next_state = FILLING;
                else if (sensor_bus == 2'b11) next_state = FULL;
            end
            FILLING: begin
                pump_out = 1'b1;
                if      (sensor_bus == 2'b11) next_state = FULL;
                else if (sensor_bus == 2'b00) next_state = EMPTY;
            end
            FULL: begin
                pump_out = 1'b0;
                if      (sensor_bus == 2'b01) next_state = DRAINING;
                else if (sensor_bus == 2'b00) next_state = EMPTY;
            end
            DRAINING: begin
                pump_out = 1'b0;
                if      (sensor_bus == 2'b00) next_state = EMPTY;
                else if (sensor_bus == 2'b11) next_state = FULL;
            end
            default: next_state = EMPTY;
        endcase

        if (sensor_bus == 2'b10) begin
            error_flag = 1'b1;
            pump_out   = 1'b0;
        end
    end

endmodule
