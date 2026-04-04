# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# BenchmarkTools benchmarks for QuantumCircuit.jl

using BenchmarkTools
using QuantumCircuit
using LinearAlgebra

const SUITE = BenchmarkGroup()

SUITE["gates"] = BenchmarkGroup()

SUITE["gates"]["hadamard_1qubit"] = let
    state = QuantumState(ComplexF64[1.0, 0.0])
    h = QuantumGate("H", HADAMARD, [Qubit(1)])
    @benchmarkable apply_gate($state, $h)
end

SUITE["gates"]["pauli_x_1qubit"] = let
    state = QuantumState(ComplexF64[1.0, 0.0])
    x = QuantumGate("X", PAULI_X, [Qubit(1)])
    @benchmarkable apply_gate($state, $x)
end

SUITE["gates"]["hadamard_4qubit_system"] = let
    state = QuantumState(vcat(ComplexF64[1.0], zeros(ComplexF64, 15)))
    h = QuantumGate("H", HADAMARD, [Qubit(2)])
    @benchmarkable apply_gate($state, $h)
end

SUITE["tensor"] = BenchmarkGroup()

SUITE["tensor"]["tensor_product_1x1"] = let
    s = QuantumState(ComplexF64[1.0, 0.0])
    @benchmarkable tensor_product($s, $s)
end

SUITE["tensor"]["build_8qubit_register"] = let
    s = QuantumState(ComplexF64[1.0, 0.0])
    @benchmarkable begin
        state = $s
        for _ in 1:7
            state = tensor_product(state, $s)
        end
        state
    end
end

SUITE["measurement"] = BenchmarkGroup()

SUITE["measurement"]["measure_superposition"] = let
    plus = QuantumState(ComplexF64[1/sqrt(2), 1/sqrt(2)])
    @benchmarkable measure($plus)
end

SUITE["evolution"] = BenchmarkGroup()

SUITE["evolution"]["evolve_4qubit"] = let
    n = 4; dim = 2^n
    state = QuantumState(vcat(ComplexF64[1.0], zeros(ComplexF64, dim - 1)))
    H = Matrix{ComplexF64}(Hermitian(randn(ComplexF64, dim, dim)))
    @benchmarkable state_evolve($state, $H, 0.01)
end

if abspath(PROGRAM_FILE) == @__FILE__
    tune!(SUITE)
    results = run(SUITE, verbose=true)
    BenchmarkTools.save("benchmarks_results.json", results)
end
