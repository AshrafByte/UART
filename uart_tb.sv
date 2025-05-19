module uart_tb;
  // Parameters
  parameter DATA_BITS = 8;
  parameter PAR_TYP = 0;  // 0=even, 1=odd
  
  // Clock and reset
  logic clk = 0;
  logic rst_n;
    // Interfaces
  uart_tx_if #(DATA_BITS) tx_if();
  uart_rx_if #(DATA_BITS) rx_if();
  
  // Connect clock and reset to interfaces
  assign tx_if.clk = clk;
  assign tx_if.rst_n = rst_n;
  assign rx_if.clk = clk;
  assign rx_if.rst_n = rst_n;
  
  // Connect TX to RX
  assign rx_if.rx = tx_if.tx;
    // DUT Instantiation
  UartTx #(
    .DATA_BITS(DATA_BITS),
    .PAR_TYP(PAR_TYP)
  ) uart_tx_inst (
    .uart_if(tx_if.DUT)
  );
  
  UartRx #(
    .DATA_BITS(DATA_BITS),
    .PAR_TYP(PAR_TYP)
  ) uart_rx_inst (
    .uart_if(rx_if.DUT)
  );
  
  // Clock generation
  always #5 clk = ~clk;
  // Task to send data
  task automatic send_data(input logic [DATA_BITS-1:0] data);
    @(posedge clk);
    tx_if.tx_start = 1'b1;
    tx_if.tx_data = data;
    
    @(posedge clk);
    tx_if.tx_start = 1'b0;
    
    // Wait for transmission to complete
    while (!tx_if.tx_done) @(posedge clk);
    @(posedge clk); // Add one more cycle after tx_done
    
    // Wait additional cycles to ensure reception is complete
    repeat(5) @(posedge clk);
  endtask
  
  // Simple checker
  task automatic check_received_data(input logic [DATA_BITS-1:0] expected);
    @(posedge clk);
    while (!rx_if.rx_done) @(posedge clk);
    
    if (rx_if.rx_data === expected)
      $display("PASS: Received correct data: %h", rx_if.rx_data);
    else
      $error("FAIL: Expected %h, Got %h", expected, rx_if.rx_data);
      
    // Wait a few cycles after receiving data
    repeat(5) @(posedge clk);
  endtask

  // Dump waves - Standard SystemVerilog wave dumping
  initial begin
    $dumpfile("dump.vcd");    // Create VCD file named dump.vcd
    $dumpvars(0, uart_tb);    // Dump all variables from uart_tb and below
  end
  // Main test sequence
  initial begin
    // Initialize
    rst_n = 0;
    tx_if.tx_start = 0;
    tx_if.tx_data = 0;
    tx_if.tick = 1'b1; // Enable ticks for baud rate generation
    rx_if.tick = 1'b1; // Enable ticks for baud rate generation
    
    // Reset
    repeat(5) @(posedge clk);
    rst_n = 1;
    
    // Test case 1: Simple data transfer
    $display("\nTest 1: Sending 8'h55");
    send_data(8'h55);
    check_received_data(8'h55);
    
    // Test case 2: All ones
    $display("\nTest 2: Sending 8'hFF");
    send_data(8'hFF);
    check_received_data(8'hFF);
    
    // Test case 3: All zeros
    $display("\nTest 3: Sending 8'h00");
    send_data(8'h00);
    check_received_data(8'h00);
    
    // Test case 4: Alternating pattern
    $display("\nTest 4: Sending 8'hA5");
    send_data(8'hA5);
    check_received_data(8'hA5);

    // End simulation
    repeat(10) @(posedge clk);
    $display("\nSimulation completed successfully!");
    $finish;
  end

  // Simple timeout watchdog
  initial begin
    #10000;  // Shorter timeout for basic tests
    $error("Testbench timeout!");
    $finish;
  end
  
endmodule