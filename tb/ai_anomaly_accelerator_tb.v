`timescale 1ns/1ps

module ai_anomaly_accelerator_tb;

    parameter DATA_WIDTH    = 16;
    parameter FEATURE_WIDTH = 32;
    parameter DIST_WIDTH    = 64;
    parameter SCORE_WIDTH   = 32;
    parameter THRESHOLD     = 100;

    reg clk;
    reg reset;
    reg start;

    reg signed [DATA_WIDTH-1:0] sensor0;
    reg signed [DATA_WIDTH-1:0] sensor1;
    reg signed [DATA_WIDTH-1:0] sensor2;
    reg signed [DATA_WIDTH-1:0] sensor3;

    reg signed [FEATURE_WIDTH-1:0] reference0;
    reg signed [FEATURE_WIDTH-1:0] reference1;
    reg signed [FEATURE_WIDTH-1:0] reference2;
    reg signed [FEATURE_WIDTH-1:0] reference3;

    wire signed [DIST_WIDTH-1:0] distance;
    wire signed [SCORE_WIDTH-1:0] anomaly_score;

    wire normal;
    wire anomaly;

    wire busy;
    wire done;


    // ------------------------------------------------
    // Clock
    // ------------------------------------------------

    always #5 clk = ~clk;


    // ------------------------------------------------
    // DUT
    // ------------------------------------------------

    ai_anomaly_accelerator #(
        .DATA_WIDTH(DATA_WIDTH),
        .FEATURE_WIDTH(FEATURE_WIDTH),
        .DIST_WIDTH(DIST_WIDTH),
        .SCORE_WIDTH(SCORE_WIDTH),
        .THRESHOLD(THRESHOLD)
    ) dut (

        .clk(clk),
        .reset(reset),
        .start(start),

        .sensor0(sensor0),
        .sensor1(sensor1),
        .sensor2(sensor2),
        .sensor3(sensor3),

        .reference0(reference0),
        .reference1(reference1),
        .reference2(reference2),
        .reference3(reference3),

        .distance(distance),
        .anomaly_score(anomaly_score),

        .normal(normal),
        .anomaly(anomaly),

        .busy(busy),
        .done(done)
    );


    // ------------------------------------------------
    // Start inference
    // ------------------------------------------------

    task start_inference;

        begin

            @(negedge clk);

            start = 1'b1;

            @(negedge clk);

            start = 1'b0;

        end

    endtask


    // ------------------------------------------------
    // Wait for completion
    // ------------------------------------------------

    task wait_for_done;

        begin

            wait(done == 1'b1);

            #2;

        end

    endtask


    // ------------------------------------------------
    // Test
    // ------------------------------------------------

    initial begin

        $dumpfile("ai_anomaly_accelerator.vcd");
        $dumpvars(0, ai_anomaly_accelerator_tb);


        clk = 0;
        reset = 1;
        start = 0;


        sensor0 = 0;
        sensor1 = 0;
        sensor2 = 0;
        sensor3 = 0;


        // ------------------------------------------------
        // Normal reference pattern
        // ------------------------------------------------

        reference0 = 100;
        reference1 = 200;
        reference2 = 300;
        reference3 = 400;


        #20;

        reset = 0;


        // =================================================
        // TEST 1 — NORMAL
        // =================================================

        sensor0 = 102;
        sensor1 = 201;
        sensor2 = 299;
        sensor3 = 405;

        $display("");
        $display("======================================");
        $display("TEST 1: NORMAL SENSOR DATA");
        $display("======================================");

        start_inference();

        wait_for_done();

        $display("Distance      = %0d", distance);
        $display("Anomaly Score = %0d", anomaly_score);
        $display("Normal        = %b", normal);
        $display("Anomaly       = %b", anomaly);


        if (normal !== 1'b1) begin
            $display("ERROR: Normal test failed");
            $fatal(1);
        end

        $display("NORMAL TEST PASSED");


        // =================================================
        // TEST 2 — ANOMALY
        // =================================================

        sensor0 = 500;
        sensor1 = 20;
        sensor2 = 800;
        sensor3 = 100;

        $display("");
        $display("======================================");
        $display("TEST 2: ANOMALOUS SENSOR DATA");
        $display("======================================");

        start_inference();

        wait_for_done();

        $display("Distance      = %0d", distance);
        $display("Anomaly Score = %0d", anomaly_score);
        $display("Normal        = %b", normal);
        $display("Anomaly       = %b", anomaly);


        if (anomaly !== 1'b1) begin
            $display("ERROR: Anomaly test failed");
            $fatal(1);
        end

        $display("ANOMALY TEST PASSED");


        // ------------------------------------------------
        // Complete
        // ------------------------------------------------

        $display("");
        $display("======================================");
        $display("AI ACCELERATOR VERIFICATION PASSED");
        $display("======================================");

        $finish;

    end

endmodule
