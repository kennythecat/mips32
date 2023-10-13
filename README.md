# MIPS-32bits CPU

## Table of Contents
- [MIPS-32bits CPU](#mips-32bits-cpu)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Checklist](#checklist)
  - [File Structure](#file-structure)
  - [Rivision history : initial](#rivision-history--initial)

***

## Description

Implement MIPS-32bits CPU by Verilog.

## Checklist
- [x] Single-Cycle 
    - [x] Component
      - [x] PC
      - [x] Instruction Mem
      - [x] Control Ubnit
      - [x] Register File
      - [x] ALU
      - [x] Data Mem
      - [x] Sign Extend
    - [x] R-Type
    - [x] I-Type
    - [x] J-type
- [ ] Implement in Real-World structure   
    - [x] Control Unit
    - [x] ALU Control Unit
    - [x] 32-bit Adder
    - [ ] 32-bit Register
    - [ ] Decoder
    - [ ] 32-bit ALU
    
- [ ] 5-stage Pipeline
  - [ ] Forwarding Unit
  - [ ] Stall Control
  - [ ] Flush Block


## File Structure

```
mips32/
│
├── README.md
│
├── pipeline/
│   ├── sim_1/
│   │   └── new/
│   │       ├── tb_alu.v
│   │       ├── tb_aluctrl_jrctrl.v
│   │       ├── tb_controlUnit.v
│   │       ├── tb_data_memory.v
│   │       ├── tb_instr_mem.v
│   │       ├── tb_mips32.v
│   │       └── tb_registerfile.v
│   │
│   └── sources_1/
│       └── new/
│           ├── alu.v
│           ├── alucontrol.v
│           ├── control.v
│           ├── data_memory.v
│           ├── inst_memory.v
│           ├── mips_32.v
│           └── register_file.v
│
└── single_cycle/
│   ├── sim_1/
│   │   └── new/
│   │       ├── tb_alu.v
│   │       ├── tb_aluctrl_jrctrl.v
│   │       ├── tb_controlUnit.v
│   │       ├── tb_data_memory.v
│   │       ├── tb_instr_mem.v
│   │       ├── tb_mips32.v
│   │       └── tb_registerfile.v
│   │
│   └── sources_1/
│       └── new/
│           ├── alu.v
│           ├── alucontrol.v
│           ├── control.v
│           ├── data_memory.v
│           ├── inst_memory.v
│           ├── mips_32.v
│           └── register_file.v

```

## Rivision history : initial
