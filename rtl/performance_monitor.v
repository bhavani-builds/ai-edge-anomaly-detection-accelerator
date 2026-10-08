module performance_monitor #(
    parameter COUNTER_WIDTH = 32
)(
    input wire clk,
    input wire reset,

    input wire start,
    input wire done,

    output reg [COUNTER_WIDTH-1:0] cycle_count,
    output reg [COUNTER_WIDTH-1:0] latency,
    output reg valid
);

    reg measuring;

    always @(posedge clk) begin

        if (reset) begin

            cycle_count <= 0;
            latency     <= 0;
            measuring   <= 1'b0;
            valid       <= 1'b0;

        end

        else begin

            valid <= 1'b0;


            // Start measuring
            if (start && !measuring) begin

                cycle_count <= 0;
                measuring   <= 1'b1;

            end


            // Count active inference cycles
            else if (measuring && !done) begin

                cycle_count <= cycle_count + 1'b1;

            end


            // Inference completed
            if (done && measuring) begin

                latency   <= cycle_count + 1'b1;
                measuring <= 1'b0;
                valid     <= 1'b1;

            end

        end

    end

endmodule
