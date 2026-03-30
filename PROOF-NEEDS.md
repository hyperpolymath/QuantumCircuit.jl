# PROOF-NEEDS.md
<!-- SPDX-License-Identifier: PMPL-1.0-or-later -->

## Current State

- `src/QuantumCircuit.jl`: quantum state, gate, and circuit representations implemented in Julia; relies on dense complex vectors/matrices but lacks a mechanised proof of the typing invariants.
- No existing Idris2/Lean4/Agda artifacts inside the repo (Idris proofs currently live in parallel hubs like `00-quantum-typing` but have not been wired back).
- `tests` and `test` directories exercise the API, but there are no mechanised proofs that e.g. `apply_gate` preserves normalization or that gates are unitary.

## What Needs Proving

### Quantum state normalization
- Prove every `QuantumState` vector is normalized (sum of squares = 1) whenever created via the public constructors.
- Reference: `src/QuantumCircuit.jl:41-70` plus the state evolution helpers around line 214.
- Prover: Idris2/Lean4 with linear algebra libraries (use symbolic complex numbers and `%default total`).

### Gate unitarity and composition
- Prove that each gate matrix defined in `src/QuantumCircuit.jl:30-50` is unitary and that `apply_gate` (line ~114) preserves the inner product between states.
- This also covers the controlled/adjoint gate constructors in the `Gate` datatype.

### Type safety of measurement outcomes
- Prove that `measure` (line ~149) produces a classical bitstring distribution derived from the Born rule and that sampling is total (no `believe_me`).
- This may require a small Idris2 model of measurement or embedding the Julia data types into Lean4 definitions.

## Priority

**P1** – QuantumCircuit.jl is the principal quantum typing asset; the proofs above are needed to support any claim about normalized states, unitary transformations, or measurement correctness in publications (Quantum typing papers, HOL deposits, etc.).

## Next Actions

1. Import the key definitions into a proof assistant (grab the state/gate model from `src/QuantumCircuit.jl` and rewrite them in Idris2/Lean4).
2. Prove the invariants listed above, eliminating all `believe_me` and placeholder lemmas.
3. Add the proof logs to `proofs/` and reference them in the PPPPP audit (link to `PROOF-AUDIT-SUMMARY.md` once the specs compile).
