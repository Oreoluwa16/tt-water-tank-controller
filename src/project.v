// src/project.v  — TT wrapper
module tt_um_water_tank_controller (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // Bidirectional (input side)
    output wire [7:0] uio_out,  // Bidirectional (output side)
    output wire [7:0] uio_oe,   // Bidirectional (output enable)
    input  wire       ena,      // Always 1 when project selected
    input  wire       clk,      // System clock
    input  wire       rst_n     // Active-low reset
);
    // Pin mapping
    // ui_in[0] = s1_high (high-level sensor)
    // ui_in[1] = s0_low  (low-level sensor)
    // uo_out[0] = pump_out
    // uo_out[1] = error_flag

    wire pump_out;
    wire error_flag;

    WaterLevelController ctrl (
        .clk       (clk),
        .reset_n   (rst_n),
        .s1_high   (ui_in[0]),
        .s0_low    (ui_in[1]),
        .pump_out  (pump_out),
        .error_flag(error_flag)
    );

    assign uo_out  = {6'b0, error_flag, pump_out};
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;   // All bidirectionals as inputs

    // Suppress unused signal warnings
    wire _unused = &{ena, uio_in, ui_in[7:2]};

endmodule
