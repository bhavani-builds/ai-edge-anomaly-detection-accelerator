module distance_engine #(
    parameter FEATURE_WIDTH = 32,
    parameter DIST_WIDTH    = 64
)(
    input wire clk,
    input wire reset,
    input wire enable,

    input wire signed [FEATURE_WIDTH-1:0] feature0,
    input wire signed [FEATURE_WIDTH-1:0] feature1,
    input wire signed [FEATURE_WIDTH-1:0] feature2,
    input wire signed [FEATURE_WIDTH-1:0] feature3,

    input wire signed [FEATURE_WIDTH-1:0] reference0,
    input wire signed [FEATURE_WIDTH-1:0] reference1,
    input wire signed [FEATURE_WIDTH-1:0] reference2,
    input wire signed [FEATURE_WIDTH-1:0] reference3,

    output reg signed [DIST_WIDTH-1:0] distance,
    output reg valid
);

    reg signed [FEATURE_WIDTH-1:0] diff0;
    reg signed [FEATURE_WIDTH-1:0] diff1;
    reg signed [FEATURE_WIDTH-1:0] diff2;
    reg signed [FEATURE_WIDTH-1:0] diff3;

    reg signed [DIST_WIDTH-1:0] square0;
    reg signed [DIST_WIDTH-1:0] square1;
    reg signed [DIST_WIDTH-1:0] square2;
    reg signed [DIST_WIDTH-1:0] square3;

    always @(posedge clk) begin

        if (reset) begin

            distance <= 0;
            valid <= 1'b0;

        end

        else if (enable) begin

            // Difference between input and reference
            diff0 = feature0 - reference0;
            diff1 = feature1 - reference1;
            diff2 = feature2 - reference2;
            diff3 = feature3 - reference3;

            // Squared differences
            square0 = diff0 * diff0;
            square1 = diff1 * diff1;
            square2 = diff2 * diff2;
            square3 = diff3 * diff3;

            // Squared Euclidean distance
            distance <= square0 +
                        square1 +
                        square2 +
                        square3;

            valid <= 1'b1;

        end

        else begin

            valid <= 1'b0;

        end

    end

endmodule
