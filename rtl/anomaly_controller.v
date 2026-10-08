module anomaly_controller (
    input wire clk,
    input wire reset,

    input wire start,

    input wire feature_valid,
    input wire distance_valid,
    input wire score_valid,
    input wire classifier_valid,

    output reg feature_enable,
    output reg distance_enable,
    output reg score_enable,
    output reg classifier_enable,

    output reg busy,
    output reg done
);

    localparam IDLE       = 3'd0;
    localparam FEATURE    = 3'd1;
    localparam DISTANCE   = 3'd2;
    localparam SCORE      = 3'd3;
    localparam CLASSIFY   = 3'd4;
    localparam DONE       = 3'd5;

    reg [2:0] state;
    reg [2:0] next_state;


    // ------------------------------------------------
    // State register
    // ------------------------------------------------

    always @(posedge clk) begin

        if (reset)
            state <= IDLE;

        else
            state <= next_state;

    end


    // ------------------------------------------------
    // Next-state logic
    // ------------------------------------------------

    always @(*) begin

        next_state = state;

        case (state)

            IDLE: begin

                if (start)
                    next_state = FEATURE;

            end


            FEATURE: begin

                if (feature_valid)
                    next_state = DISTANCE;

            end


            DISTANCE: begin

                if (distance_valid)
                    next_state = SCORE;

            end


            SCORE: begin

                if (score_valid)
                    next_state = CLASSIFY;

            end


            CLASSIFY: begin

                if (classifier_valid)
                    next_state = DONE;

            end


            DONE: begin

                next_state = IDLE;

            end


            default: begin

                next_state = IDLE;

            end

        endcase

    end


    // ------------------------------------------------
    // Control outputs
    // ------------------------------------------------

    always @(*) begin

        feature_enable   = 1'b0;
        distance_enable  = 1'b0;
        score_enable     = 1'b0;
        classifier_enable = 1'b0;

        busy = 1'b0;
        done = 1'b0;


        case (state)

            IDLE: begin

                busy = 1'b0;

            end


            FEATURE: begin

                busy = 1'b1;
                feature_enable = 1'b1;

            end


            DISTANCE: begin

                busy = 1'b1;
                distance_enable = 1'b1;

            end


            SCORE: begin

                busy = 1'b1;
                score_enable = 1'b1;

            end


            CLASSIFY: begin

                busy = 1'b1;
                classifier_enable = 1'b1;

            end


            DONE: begin

                done = 1'b1;

            end


            default: begin

                busy = 1'b0;

            end

        endcase

    end

endmodule
