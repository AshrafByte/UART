module uart_baud_gen #(
  parameter CLK_FREQ = 50000000,  // Default 50MHz clock
  parameter BAUD_RATE = 115200,   // Default 115200 baud rate
  parameter TICKS_PER_BIT = 16    // Standard oversampling for UART
) (
  input  logic clk,
  input  logic rst_n,
  output logic tick
);
  
  // Calculate the counter limit based on parameters
  localparam DIV_VAL = CLK_FREQ / (BAUD_RATE * TICKS_PER_BIT);
  localparam COUNTER_WIDTH = $clog2(DIV_VAL);
  
  // Baud counter
  logic [COUNTER_WIDTH-1:0] counter;
  
  // Main counter logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      counter <= '0;
      tick <= 1'b0;
    end else begin
      if (counter >= DIV_VAL - 1) begin
        counter <= '0;
        tick <= 1'b1;
      end else begin
        counter <= counter + 1'b1;
        tick <= 1'b0;
      end
    end
  end
  
endmodule
