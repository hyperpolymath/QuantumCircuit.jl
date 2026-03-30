# TEST-NEEDS: QuantumCircuit.jl

## Current State

| Category | Count | Details |
|----------|-------|---------|
| **Source modules** | 2 | 372 lines |
| **Test files** | 1 | 417 lines, 128 @test/@testset |
| **Benchmarks** | 0 | None |

## What's Missing

- [ ] **Performance**: Quantum simulation with 0 benchmarks -- qubit scaling is critical
- [ ] **Error handling**: No tests for invalid quantum states, gate errors

### Benchmarks Needed
- [ ] Simulation time scaling with qubit count
- [ ] Gate operation throughput

## FLAGGED ISSUES
- **128 tests for 2 modules = 64 tests/module** -- excellent
- **Test lines > source lines** (417 > 372) -- rare and commendable
- **0 benchmarks** for quantum simulation -- qubit scaling is the key metric

## Priority: P3 (LOW) -- well tested, needs benchmarks

## FAKE-FUZZ ALERT

- `tests/fuzz/placeholder.txt` is a scorecard placeholder inherited from rsr-template-repo — it does NOT provide real fuzz testing
- Replace with an actual fuzz harness (see rsr-template-repo/tests/fuzz/README.adoc) or remove the file
- Priority: P2 — creates false impression of fuzz coverage
