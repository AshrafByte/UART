# UART Verification Project

![UART](https://img.shields.io/badge/Interface-UART-blue)
![SystemVerilog](https://img.shields.io/badge/Language-SystemVerilog-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

A SystemVerilog-based Universal Asynchronous Receiver/Transmitter (UART) implementation with a complete verification environment. This project demonstrates a modular design of UART transmitter and receiver modules with parity checking and a complete testbench environment.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Modules Description](#modules-description)
- [Interface Structure](#interface-structure)
- [Testbench](#testbench)
- [Getting Started](#getting-started)
- [Simulation](#simulation)
- [Results](#results)
- [License](#license)

## 🔍 Overview

This project implements a complete UART communication system with transmitter and receiver modules along with a verification environment. UART is a widely used serial communication protocol that allows full-duplex communication between devices.

## 🏛️ Architecture

The project follows a modular design approach with separate transmitter and receiver modules connected via interfaces:

```
          ┌─────────────┐               ┌─────────────┐
 ┌─────┐  │             │  Serial Line  │             │  ┌─────┐
 │     │  │   UartTx    │──────────────▶│   UartRx    │  │     │
 │     │──┤             │               │             │──┤     │
 │     │  └─────────────┘               └─────────────┘  │     │
 └─────┘                                                 └─────┘
 Sender                                                 Receiver
```

## ✨ Features

- Configurable data width (default: 8 bits)
- Parity checking (even/odd) for error detection
- Configurable stop bits
- FSM-based implementation
- Modular design with interfaces
- Complete verification environment

## 📦 Modules Description

### UartTx

The transmitter module responsible for sending data serially. It implements:
- Start bit generation
- Data serialization
- Optional parity bit generation
- Stop bit handling

### UartRx

The receiver module responsible for receiving serial data. It implements:
- Start bit detection
- Data deserialization
- Parity checking
- Stop bit verification
- Error detection

## 🔌 Interface Structure

### uart_tx_if

The transmitter interface with the following signals:
- `clk`: Clock signal
- `rst_n`: Active-low reset
- `tx`: Serial output line
- `tick`: Baud rate tick
- `tx_start`: Signal to start transmission
- `tx_data`: Parallel data to transmit
- `tx_done`: Indicates completion of transmission

### uart_rx_if

The receiver interface with the following signals:
- `clk`: Clock signal
- `rst_n`: Active-low reset
- `rx`: Serial input line
- `tick`: Baud rate tick
- `rx_data`: Received parallel data
- `rx_done`: Indicates reception completion
- `rx_error`: Signals error in reception

## 🧪 Testbench

The testbench (`uart_tb.sv`) verifies the functionality of the UART modules by:
1. Connecting the transmitter to the receiver
2. Generating various test patterns
3. Comparing sent and received data
4. Reporting test results

Test cases include:
- Simple data transfer (0x55)
- All ones pattern (0xFF)
- All zeros pattern (0x00)
- Alternating pattern (0xA5)

## 🚀 Getting Started

### Prerequisites

- SystemVerilog compatible simulator (e.g., ModelSim, VCS, Questa, Xcelium)
- Basic knowledge of UART protocol

### Directory Structure

```
├── README.md              # Project documentation
├── uart_tx_if.sv          # Transmitter interface
├── uart_rx_if.sv          # Receiver interface
├── UartTx.sv              # Transmitter implementation
├── UartRx.sv              # Receiver implementation
└── uart_tb.sv             # Verification testbench
```

## 💻 Simulation

To run the simulation:

```bash
# Compile the design files
vlog uart_tx_if.sv uart_rx_if.sv UartTx.sv UartRx.sv uart_tb.sv

# Run the simulation
vsim -c uart_tb -do "run -all; quit"
```

## 📊 Results

The testbench outputs will show:
- Pass/fail status for each test case
- Sent and received data for verification
- Any errors detected during transmission

Expected output:
```
Test 1: Sending 8'h55
PASS: Received correct data: 55

Test 2: Sending 8'hFF
PASS: Received correct data: ff

Test 3: Sending 8'h00
PASS: Received correct data: 00

Test 4: Sending 8'hA5
PASS: Received correct data: a5

Simulation completed successfully!
```

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

© 2025 UART Verification Project. All rights reserved.