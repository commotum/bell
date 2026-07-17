# 5-SINGLET

## Current Facts

- Stages 1-4 are complete. The final Stage 4 record remains an existing
  uncommitted workspace change and will be preserved while this stage proceeds.
- Bell's equation (3) asserts that the singlet expectation of
  `(sigma_1 dot a)(sigma_2 dot b)` is `-(a dot b)` for physical unit
  directions. The paper states the formula but does not supply the finite
  matrix calculation.
- The pinned Stage 2 probes still compile for complex basis-indexed kets,
  `Matrix.mulVec`, conjugated `dotProduct`, Hermitian matrices, matrix
  Kronecker products, `EuclideanSpace Real (Fin 3)`, and real inner products.
- The selected basis representation is one-qubit index `Fin 2` and two-qubit
  index `Fin 2 × Fin 2`. Kronecker indices therefore order the first subsystem
  before the second.
- The public root currently exports only the hidden-variable and abstract Bell
  layers. No quantum module is present, and no current quantum probe is a
  public dependency.
- The worktree and baseline focused build were inspected before implementation;
  `Bell.Audit.QuantumApi`, `Bell.Audit.GeometryApi`, and `Bell` all build under
  the pinned revisions.

## Updated Assumptions

- Use complex functions for kets and complex matrices for finite operators.
  Define the ket inner product as `dotProduct (star psi) phi`, so it is
  conjugate-linear in the first argument, and define pure-state expectation by
  applying the matrix before taking that inner product.
- Define the Pauli matrices independently and define the directional spin
  observable from real Euclidean coordinates. Do not define an observable by
  stipulating its desired singlet expectation.
- Use the computational basis ordering `|00>, |01>, |10>, |11>` induced by
  `Fin 2 × Fin 2`. Define the singlet ket with amplitudes
  `0, 1/sqrt(2), -1/sqrt(2), 0` in that order and prove its normalization.
- The identity `-(a dot b)` is algebraic and holds for arbitrary real
  three-vectors. Unit-norm assumptions are physical restrictions on
  measurement directions, not requirements of the matrix identity itself.
  Stage 6 will prove the concrete violating vectors are unit.
- Prove Hermiticity for Pauli and directional observables. Any stronger
  spectrum or square-to-identity result will be added only if it has a concrete
  consumer or is needed to justify the binary measurement convention.
- Keep all hidden-variable and Bell-inequality modules out of the quantum
  implementation. The independent layers will first meet only in Stage 6.

## Big Picture Objective

Define explicit finite-dimensional quantum objects for two spin-one-half
systems and derive Bell's singlet correlation

```text
pureExpectation singletState
  (spinObservable a tensor spinObservable b) = -(inner Real a b)
```

without assuming the correlation formula, importing the abstract Bell
inequality, or choosing the later violating directions.

## Detailed Implementation Plan

- Add `Bell.Quantum.Basic` with reusable finite ket/operator aliases, the
  conjugated ket inner product, pure-state expectation, and normalization
  predicate.
- Add `Bell.Quantum.Pauli` with real three-space directions, explicit Pauli
  matrices, the directional spin observable, Hermiticity proofs, and coordinate
  axis checks.
- Add `Bell.Quantum.Singlet` with the inverse-square-root amplitude, explicit
  singlet ket, normalization theorem, two-subsystem Kronecker observable,
  coordinate expectation calculation, and inner-product form of equation (3).
- Add `Bell.Audit.Singlet` as a private consumer of the public `Bell` root. It
  will check singlet coordinates, x/y/z basis correlations (including the
  imaginary Pauli-y convention), arbitrary-vector theorem use, and headline
  axiom output.
- Re-export only the stable singlet leaf from `Bell.lean` after all quantum
  leaves compile. Update README, the paper/declaration map, dependency notes,
  correction log if needed, and stage status.

Expected files:

- `formal/Bell/Quantum/Basic.lean`
- `formal/Bell/Quantum/Pauli.lean`
- `formal/Bell/Quantum/Singlet.lean`
- `formal/Bell/Audit/Singlet.lean`
- `formal/Bell.lean`
- `README.md`
- `goal-1/0-plan.md`
- `goal-1/5-SINGLET.md`

## Build Structure

- `Bell.Quantum.Basic` is the lowest quantum dependency layer. It owns only
  finite-dimensional types and generic expectation vocabulary and imports no
  Pauli, singlet, geometry-violation, hidden-variable, or inequality module.
- `Bell.Quantum.Pauli` imports `Basic` and the narrow Euclidean/Hermitian matrix
  APIs. It owns one-qubit physical observables but no two-qubit state.
- `Bell.Quantum.Singlet` is the heavier theorem leaf. It imports `Pauli` and the
  matrix Kronecker API, owns the two-qubit state and calculation, and imports no
  project hidden-variable or inequality leaf.
- `Bell.Audit.Singlet` is a non-exported diagnostic consumer. Basis checks,
  convention probes, and `#print axioms` stay there rather than increasing the
  public proof surface.
- `Bell.lean` remains a thin re-export surface and will be touched only after
  the new leaf builds.

Focused build sequence:

```text
cd formal
lake build Bell.Quantum.Basic
lake build Bell.Quantum.Pauli
lake build Bell.Quantum.Singlet
lake build Bell.Audit.Singlet
lake build Bell
lake build
```

## No-Cheating Checks

- Inspect definitions to confirm the singlet correlation is calculated through
  matrix application and the conjugated inner product, not stored as a field,
  installed as a definition, or assumed as a theorem hypothesis.
- Confirm the singlet state is explicitly normalized and its two nonzero signs
  agree with the antisymmetric `(|01> - |10>)/sqrt(2)` convention.
- Check all three equal-axis correlations. The y-axis case must exercise complex
  conjugation and imaginary matrix entries rather than being inferred from the
  target theorem alone.
- Inspect the Kronecker definition/use and basis checks to confirm the first
  matrix acts on the first index and the second on the second index.
- Confirm the headline theorem has arbitrary vector parameters and no unit,
  hidden-variable, locality, probability, perfect-anticorrelation, Bell-bound,
  or quantum-reproduction premise.
- Scan quantum implementation imports for `Bell.HiddenVariable`,
  `Bell.Inequality`, `Bell.Geometry`, and the public `Bell` umbrella.
- Scan all Lean sources for `sorry`, `admit`, project `axiom`, `opaque`,
  `unsafe`, and `native_decide`.

## Completion Requirements

- [ ] Explicit Pauli matrices and directional spin observables compile and are
  proved Hermitian under the documented complex convention.
- [ ] The explicit two-qubit singlet ket has the documented computational-basis
  coordinates and is proved normalized.
- [ ] The tensor subsystem ordering and pure-expectation convention are explicit
  in declarations and verified by basis checks.
- [ ] A public coordinate theorem derives the full complex expectation for
  arbitrary real three-vectors from the definitions.
- [ ] A public `singlet_spin_correlation` theorem rewrites that calculation as
  the negative real Euclidean inner product, without assuming unit norms.
- [ ] Independent x/y/z and cross-axis audit examples validate signs,
  conjugation, and basis order.
- [ ] The quantum implementation imports no hidden-variable inequality or
  future geometric-violation module, and the abstract layer remains unchanged.
- [ ] `#print axioms` for all headline normalization, Hermiticity, and correlation
  results reports only understood Lean/mathlib foundations.
- [ ] Focused quantum/audit builds and the full public build pass.
- [ ] Proof-hole, target-as-premise, import-boundary, convention, and diff scans
  pass.
- [ ] Exact failures, corrections, declaration mapping, and evidence are
  recorded here and folded into `goal-1/0-plan.md`.

## Stage Results

- In progress.
