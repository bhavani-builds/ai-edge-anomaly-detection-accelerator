module threshold_classifier #(
    parameter SCORE_WIDTH = 32,
    parameter THRESHOLD   = 100
)(
    input wire clk,
    input wire reset,
    input wire enable,

    input wire signed [SCORE_WIDTH-1:0] score,

    output reg anomaly,
    output reg normal,
    output reg valid
);

    always @(posedge clk) begin

        if (reset) begin

            anomaly <= 1'b0;
            normal  <= 1'b0;
            valid   <= 1'b0;

        end

        else if (enable) begin

            if (score >= THRESHOLD) begin
                anomaly <= 1'b1;
                normal  <= 1'b0;
            end

            else begin
                anomaly <= 1'b0;
                normal  <= 1'b1;
            end

            valid <= 1'b1;

        end

        else begin

            anomaly <= 1'b0;
            normal  <= 1'b0;
            valid   <= 1'b0;

        end

    end

endmodule
