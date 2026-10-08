module ai_anomaly_accelerator #(
    parameter DATA_WIDTH    = 16,
    parameter FEATURE_WIDTH = 32,
    parameter DIST_WIDTH    = 64,
    parameter SCORE_WIDTH   = 32,
    parameter THRESHOLD     = 100
)(
    input wire clk,
    input wire reset,
    input wire start,

    input wire signed [DATA_WIDTH-1:0] sensor0,
    input wire signed [DATA_WIDTH-1:0] sensor1,
    input wire signed [DATA_WIDTH-1:0] sensor2,
    input wire signed [DATA_WIDTH-1:0] sensor3,

    input wire signed [FEATURE_WIDTH-1:0] reference0,
    input wire signed [FEATURE_WIDTH-1:0] reference1,
    input wire signed [FEATURE_WIDTH-1:0] reference2,
    input wire signed [FEATURE_WIDTH-1:0] reference3,

    output wire signed [DIST_WIDTH-1:0] distance,
    output wire signed [SCORE_WIDTH-1:0] anomaly_score,

    output wire normal,
    output wire anomaly,

    output wire busy,
    output wire done
);


    // ------------------------------------------------
    // Control signals
    // ------------------------------------------------

    wire feature_enable;
    wire distance_enable;
    wire score_enable;
    wire classifier_enable;

    wire feature_valid;
    wire distance_valid;
    wire score_valid;
    wire classifier_valid;


    // ------------------------------------------------
    // Feature signals
    // ------------------------------------------------

    wire signed [FEATURE_WIDTH-1:0] feature0;
    wire signed [FEATURE_WIDTH-1:0] feature1;
    wire signed [FEATURE_WIDTH-1:0] feature2;
    wire signed [FEATURE_WIDTH-1:0] feature3;


    // ------------------------------------------------
    // Feature Extractor
    // ------------------------------------------------

    feature_extractor #(
        .DATA_WIDTH(DATA_WIDTH),
        .FEATURE_WIDTH(FEATURE_WIDTH)
    ) feature_unit (

        .clk(clk),
        .reset(reset),
        .enable(feature_enable),

        .sensor0(sensor0),
        .sensor1(sensor1),
        .sensor2(sensor2),
        .sensor3(sensor3),

        .feature0(feature0),
        .feature1(feature1),
        .feature2(feature2),
        .feature3(feature3),

        .valid(feature_valid)
    );


    // ------------------------------------------------
    // Distance Engine
    // ------------------------------------------------

    distance_engine #(
        .FEATURE_WIDTH(FEATURE_WIDTH),
        .DIST_WIDTH(DIST_WIDTH)
    ) distance_unit (

        .clk(clk),
        .reset(reset),
        .enable(distance_enable),

        .feature0(feature0),
        .feature1(feature1),
        .feature2(feature2),
        .feature3(feature3),

        .reference0(reference0),
        .reference1(reference1),
        .reference2(reference2),
        .reference3(reference3),

        .distance(distance),
        .valid(distance_valid)
    );


    // ------------------------------------------------
    // Anomaly Score
    // ------------------------------------------------

    anomaly_score #(
        .DIST_WIDTH(DIST_WIDTH),
        .SCORE_WIDTH(SCORE_WIDTH)
    ) score_unit (

        .clk(clk),
        .reset(reset),
        .enable(score_enable),

        .distance(distance),

        .score(anomaly_score),
        .valid(score_valid)
    );


    // ------------------------------------------------
    // Threshold Classifier
    // ------------------------------------------------

    threshold_classifier #(
        .SCORE_WIDTH(SCORE_WIDTH),
        .THRESHOLD(THRESHOLD)
    ) classifier (

        .clk(clk),
        .reset(reset),
        .enable(classifier_enable),

        .score(anomaly_score),

        .anomaly(anomaly),
        .normal(normal),
        .valid(classifier_valid)
    );


    // ------------------------------------------------
    // AI Controller
    // ------------------------------------------------

    anomaly_controller controller (

        .clk(clk),
        .reset(reset),

        .start(start),

        .feature_valid(feature_valid),
        .distance_valid(distance_valid),
        .score_valid(score_valid),
        .classifier_valid(classifier_valid),

        .feature_enable(feature_enable),
        .distance_enable(distance_enable),
        .score_enable(score_enable),
        .classifier_enable(classifier_enable),

        .busy(busy),
        .done(done)
    );


endmodule
