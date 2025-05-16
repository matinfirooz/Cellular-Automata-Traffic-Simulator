# Cellular Automata Traffic Simulator

## Overview  
This project implements a Cellular Automata (CA) simulator designed to model traffic flow on a two-dimensional highway grid. The goal is to simulate vehicle movement based on simple but effective rules, implemented directly in hardware. By doing so, the project enables detailed analysis of traffic behavior and congestion patterns in real-time.

## Implementation Details  
Vehicles are modeled as identical units moving at discrete speeds of 1, 2, or 3 cells per simulation step. When a vehicle encounters a blocked path ahead, it must stop. To capture lane-changing behavior, vehicles can switch lanes with a given probability when conditions allow. The highway is represented as a 30 by 3 grid — three lanes of length 30 cells — where vehicles are initially distributed randomly.

The hardware model defines each cell as a segment of the highway, implementing the CA rules that govern vehicle motion and interactions. Each cell communicates with its neighbors to determine if movement or lane changes are possible. The simulation is started and stopped through control signals and runs for a specified number of generations.

Two methods are proposed for initializing the cell states. The first method assigns initial values through dedicated input lines for each cell, which is simple but not resource-efficient. The second method uses a bit-shift chain to sequentially load initial values into cells, reducing input overhead but increasing design complexity.

The entire design is written in a synthesizable hardware description language with a focus on modularity and efficiency, making it suitable for FPGA or ASIC implementation. The design is optimized for minimal resource use and timing delays to enable real-time operation.

## Optional Enhancements  
The project can be extended by synthesizing the design on FPGA or ASIC platforms to evaluate resource usage and performance delays. Additionally, a software simulation of the same traffic model can be developed in a high-level language such as Python or C++ to validate and compare results with the hardware implementation.

---

This project aims to provide a hardware-accelerated, scalable traffic simulation framework that captures realistic vehicle dynamics and lane-changing behavior through cellular automata.
