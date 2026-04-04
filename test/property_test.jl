# SPDX-License-Identifier: MPL-2.0
# (PMPL-1.0-or-later preferred; MPL-2.0 required for Julia ecosystem)
# Property-based invariant tests for QuantumCircuit.jl

using Test
using QuantumCircuit
using LinearAlgebra

@testset "Property-Based Tests" begin

    @testset "Invariant: applying any Pauli gate preserves normalisation" begin
        for gate_mat in [PAULI_X, PAULI_Y, PAULI_Z]
            for _ in 1:50
                theta = rand() * 2π
                amp = ComplexF64[cos(theta), sin(theta)]
                state = QuantumState(amp)
                gate = QuantumGate("P", gate_mat, [Qubit(1)])
                result = apply_gate(state, gate)
                @test sum(abs2.(result.amplitudes)) ≈ 1.0 atol=1e-12
            end
        end
    end

    @testset "Invariant: Hadamard is self-inverse" begin
        for _ in 1:50
            theta = rand() * 2π
            amp = ComplexF64[cos(theta), sin(theta)]
            state = QuantumState(amp)
            h = QuantumGate("H", HADAMARD, [Qubit(1)])
            after_hh = apply_gate(apply_gate(state, h), h)
            @test after_hh.amplitudes ≈ state.amplitudes atol=1e-12
        end
    end

    @testset "Invariant: tensor_product doubles qubit count" begin
        for _ in 1:50
            n1 = rand(1:4)
            n2 = rand(1:4)
            dim1 = 2^n1
            dim2 = 2^n2
            v1 = normalize(rand(ComplexF64, dim1))
            v2 = normalize(rand(ComplexF64, dim2))
            s1 = QuantumState(v1)
            s2 = QuantumState(v2)
            result = tensor_product(s1, s2)
            @test num_qubits(result) == n1 + n2
            @test sum(abs2.(result.amplitudes)) ≈ 1.0 atol=1e-12
        end
    end

    @testset "Invariant: state_evolve preserves normalisation" begin
        for _ in 1:50
            n = rand(1:3)
            dim = 2^n
            v = normalize(rand(ComplexF64, dim))
            state = QuantumState(v)
            H = Hermitian(randn(ComplexF64, dim, dim))
            t = rand() * 2.0
            evolved = state_evolve(state, Matrix{ComplexF64}(H), t)
            @test sum(abs2.(evolved.amplitudes)) ≈ 1.0 atol=1e-12
        end
    end

    @testset "Invariant: measure returns valid outcome and normalised collapsed state" begin
        for _ in 1:50
            theta = rand() * 2π
            state = QuantumState(ComplexF64[cos(theta), sin(theta)])
            outcome, collapsed = measure(state)
            @test outcome in [0, 1]
            @test sum(abs2.(collapsed.amplitudes)) ≈ 1.0 atol=1e-12
        end
    end

end
