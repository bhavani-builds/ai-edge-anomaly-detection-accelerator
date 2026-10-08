module anomaly_score #(
    parameter DIST_WIDTH  = 64,
    parameter SCORE_WIDTH = 32,
    parameter SCALE       = 1024
)(
    input wire clk,
    input wire reset,
    input wire enable,

    input wire signed [DIST_WIDTH-1:0] distance,

    output reg signed [SCORE_WIDTH-1:0] score,
    output reg valid
);

    reg signed [DIST_WIDTH-1:0] scaled_distance;

    always @(posedge clk) begin

        if (reset) begin

            score <= 0;
            valid <= 1'b0;

        end

        else if (enable) begin

            /*
             * Scale the distance into a
             * hardware-friendly anomaly score.
             */

            scaled_distance = distance / SCALE;

            if (scaled_distance > 32'h7FFFFFFF)
                score <= 32'h7FFFFFFF;

            else if (scaled_distance < 0)
                score <= 0;

            else
                score <= scaled_distance[SCORE_WIDTH-1:0];

            valid <= 1'b1;

        end

        else begin

            valid <= 1'b0;

        end

    end

endmodule
