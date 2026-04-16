# Single-Cycle CPU (Verilog)

## Overview

This project implements a single-cycle processor in Verilog.
The design follows a classical single-cycle datapath architecture with a dedicated control unit, register file, ALU, and memory modules.

## Architecture

The processor is organized into the following main components:

* Arithmetic Logic Unit (ALU)
* Control Unit
* Register File (GPR)
* Immediate Decoder
* Instruction Memory
* Data Memory
* Multiplexers for datapath control

The top-level module (`processor.v`) integrates all components into a complete single-cycle datapath.

## Supported Functionality

The processor supports a subset of instructions including:

* R-type operations (arithmetic and logical)
* Immediate operations
* Memory access (load/store)
* Conditional branching
* Jump instructions (`jal`, `jalr`)

The ALU also includes extended operations for byte-wise (SIMD-like) processing.

## Project Structure

```text
module_alu.v           - Arithmetic Logic Unit
module_controlunit.v   - Control signal generation
module_gprset.v        - Register file
module_immdecode.v     - Immediate value generation
module_datamem.v       - Data memory
module_instrmem.v      - Instruction memory
module_multiplexor.v   - Multiplexer components
processor.v            - Core processor datapath
top.v                  - Top-level integration module
```

## Verification

The design was tested in a university verification system as part of a computer architecture course.

## Notes

This project was developed for educational purposes.
The implementation prioritizes clarity and modularity of the architecture over optimization.
