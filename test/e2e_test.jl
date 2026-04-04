# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# E2E pipeline tests for QuantumCircuit.jl

using Test
using QuantumCircuit
using LinearAlgebra

@testset "E2E Pipeline Tests" begin

    @testset "Full circuit execution pipeline" begin
        # Build a multi-gate, multi-qubit circuit; run it; verify final state
        circ = QuantumCircuitObj(2, [
            QuantumGate("H", HADAMARD, [Qubit(1)]),
            QuantumGate("X", PAULI_X, [Qubit(2)]),
            QuantumGate("Z", PAULI_Z, [Qubit(1)]),
        ])
        state = QuantumState(ComplexF64[1.0, 0.0, 0.0, 0.0])
        for gate in circ.gates
            state = apply_gate(state, gate)
        end
        @test sum(abs2.(state.amplitudes)) ≈ 1.0 atol=1e-12
        @test num_qubits(state) == 2
    end

    @testset "Tensor-then-evolve-then-measure pipeline" begin
        # Prepare a 2-qubit superposition, evolve one subsystem, measure
        s0 = QuantumState(ComplexF64[1.0, 0.0])
        h = QuantumGate("H", HADAMARD, [Qubit(1)])
        s_sup = apply_gate(s0, h)   # (|0⟩+|1⟩)/√2

        two = tensor_product(s_sup, s0)
        @test num_qubits(two) == 2
        @test sum(abs2.(two.amplitudes)) ≈ 1.0 atol=1e-12

        # Evolve the two-qubit state under a diagonal Hamiltonian
        H = diagm(ComplexF64[1.0, -1.0, -1.0, 1.0])
        evolved = state_evolve(two, H, 0.2)
        @test sum(abs2.(evolved.amplitudes)) ≈ 1.0 atol=1e-12
    end

    @testset "Repeated Hadamard recovers initial state" begin
        state = QuantumState(ComplexF64[1.0, 0.0])
        h = QuantumGate("H", HADAMARD, [Qubit(1)])
        for _ in 1:4   # even number of applications
            state = apply_gate(state, h)
        end
        @test state.amplitudes[1] ≈ 1.0 atol=1e-12
        @test abs(state.amplitudes[2]) < 1e-12
    end

    @testset "Error handling: invalid circuit inputs" begin
        # Gate target qubit out of range
        state = QuantumState(ComplexF64[1.0, 0.0])
        bad_gate = QuantumGate("X", PAULI_X, [Qubit(5)])
        @test_throws BoundsError apply_gate(state, bad_gate)

        # Dimension mismatch for Hamiltonian evolution
        H_big = Matrix{ComplexF64}(I, 4, 4)
        @test_throws DimensionMismatch state_evolve(state, H_big, 0.1)
    end

end
