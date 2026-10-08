module feature_extractor #(
    parameter DATA_WIDTH = 16,
    parameter FEATURE_WIDTH = 32
)(
    input wire clk,
    input wire reset,
    input wire enable,

    input wire signed [DATA_WIDTH-1:0] sensor0,
    input wire signed [DATA_WIDTH-1:0] sensor1,
    input wire signed [DATA_WIDTH-1:0] sensor2,
    input wire signed [DATA_WIDTH-1:0] sensor3,

    output reg signed [FEATURE_WIDTH-1:0] feature0,
    output reg signed [FEATURE_WIDTH-1:0] feature1,
    output reg signed [FEATURE_WIDTH-1:0] feature2,
    output reg signed [FEATURE_WIDTH-1:0] feature3,

    output reg valid
);

    always @(posedge clk) begin

        if (reset) begin

            feature0 <= 0;
            feature1 <= 0;
            feature2 <= 0;
            feature3 <= 0;

            valid <= 1'b0;

        end

        else if (enable) begin

            /*
             * Convert sensor samples into
             * wider internal features.
             */

            feature0 <= sensor0;
            feature1 <= sensor1;
            feature2 <= sensor2;
            feature3 <= sensor3;

            valid <= 1'b1;

        end

        else begin

            valid <= 1'b0;

        end

    end

endmodule
