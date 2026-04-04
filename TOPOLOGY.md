<!-- SPDX-License-Identifier: PMPL-1.0-or-later -->
<!-- Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk> -->

# TOPOLOGY.md — QuantumCircuit.jl

## Purpose

QuantumCircuit.jl is a Julia package for simulating and manipulating quantum circuits with focus on clarity and extensibility. Provides framework for building, optimizing, and analyzing quantum algorithms with custom backend support (GPU-accelerated) and integration with hyperpolymath ecosystem for formal verification.

## Module Map

```
QuantumCircuit.jl/
├── src/                 # Julia package source
│   ├── gates/          # Quantum gate definitions
│   ├── circuits/       # Circuit representation and manipulation
│   ├── simulation/     # Simulation engines and backends
│   └── analysis/       # Algorithm analysis tools
├── test/               # Test suite (specs, fixtures)
├── examples/           # Usage examples
├── docs/               # Documenter.jl documentation
└── Project.toml        # Julia package manifest
```

## Data Flow

```
[Quantum State] ──► [Gate Application] ──► [Measurement] ──► [Outcome Probability]
                            ↓
                    [Backend Selection] ──► [GPU/CPU Compute]
```

## Features

- Define and manipulate quantum states and gates
- Apply gates to states and measure outcomes
- Support for custom backends (GPU-accelerated)
- Integration with hyperpolymath ecosystem for formal verification
