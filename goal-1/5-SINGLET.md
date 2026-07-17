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

- [x] Explicit Pauli matrices and directional spin observables compile and are
  proved Hermitian under the documented complex convention.
- [x] The explicit two-qubit singlet ket has the documented computational-basis
  coordinates and is proved normalized.
- [x] The tensor subsystem ordering and pure-expectation convention are explicit
  in declarations and verified by basis checks.
- [x] A public coordinate theorem derives the full complex expectation for
  arbitrary real three-vectors from the definitions.
- [x] A public `singlet_spin_correlation` theorem rewrites that calculation as
  the negative real Euclidean inner product, without assuming unit norms.
- [x] Independent x/y/z and cross-axis audit examples validate signs,
  conjugation, and basis order.
- [x] The quantum implementation imports no hidden-variable inequality or
  future geometric-violation module, and the abstract layer remains unchanged.
- [x] `#print axioms` for all headline normalization, Hermiticity, and correlation
  results reports only understood Lean/mathlib foundations.
- [x] Focused quantum/audit builds and the full public build pass.
- [x] Proof-hole, target-as-premise, import-boundary, convention, and diff scans
  pass.
- [x] Exact failures, corrections, declaration mapping, and evidence are
  recorded here and folded into `goal-1/0-plan.md`.

## Stage Results

Stage 5 completed on 2026-07-17. It did not choose Bell-violating directions,
apply the hidden-variable inequality, or state a physical nonlocality
conclusion.

### Public quantum API delivered

`Bell.Quantum.Basic` provides the reusable coordinate layer:

- `QubitIndex = Fin 2`, one-qubit kets/operators, and ordered two-qubit
  kets/operators indexed by `Fin 2 × Fin 2`;
- `ketInner psi phi = dotProduct (star psi) phi`, conjugate-linear in the first
  argument;
- `pureExpectation psi M = ketInner psi (M *ᵥ psi)`; and
- the separate normalization predicate `IsNormalizedKet`.

`Bell.Quantum.Pauli` provides:

- explicit standard matrices `pauliX`, `pauliY`, and `pauliZ`, with coordinates
  `0`, `1`, and `2` corresponding to x, y, and z;
- `Direction = EuclideanSpace Real (Fin 3)` and
  `spinObservable a = a0 sigmaX + a1 sigmaY + a2 sigmaZ`;
- Hermiticity of each Pauli matrix and every real directional observable;
- x/y/z coordinate-axis rewrite theorems; and
- `spinObservable_mul_self`, proving `(sigma·a)^2` is the coordinate squared
  length times the identity, plus inner-product and norm-one corollaries giving
  `(spinObservable a)^2 = I`. This is the checked algebraic certificate for the
  binary `±1` spin convention; a full spectral-measure API is not claimed.

`Bell.Quantum.Singlet` provides:

- `singletAmplitude = 1 / sqrt(2)` and the explicit state with coordinates
  `(0, 1/sqrt(2), -1/sqrt(2), 0)` in the ordered basis
  `|00>, |01>, |10>, |11>`;
- the four coordinate lemmas and `singletState_normalized`;
- `twoSpinObservable a b = spinObservable a ⊗ₖ spinObservable b`, with the first
  matrix acting on the first product index, and its Hermiticity theorem;
- `singletSpinExpectation`, the raw complex finite-matrix expectation, and
  `singletCorrelation`, its real part;
- `singlet_spin_expectation_coordinates`, which expands every finite sum and
  derives the full complex value
  `-(a0*b0 + a1*b1 + a2*b2)`;
- `singlet_spin_expectation`, rewriting that result as the embedded complex
  value `-(inner Real a b)`; and
- `singlet_spin_correlation`, proving the real equation
  `singletCorrelation a b = -inner Real a b`.

The public `Bell` root now re-exports `Bell.Quantum.Singlet`, whose public
import chain exposes `Pauli` and `Basic`. The root remains an import/documentation
surface; `Bell.Audit.Singlet` is not exported.

### Mathematical and convention audit

Bell's equation (3) uses dimensionless Pauli components, so no factor of
`hbar/2` belongs in this correlation. The scanned paper treats `a` and `b` as
unit measurement directions. Independent algebra and the compiled proof show
that the matrix identity itself is homogeneous and holds for arbitrary real
three-vectors. Unit length enters only when interpreting `spinObservable a` as
a binary spin component; the square-to-identity theorem makes that distinction
formal. This clarification is correction-log item 19 in `goal-1/0-plan.md`.

The exact conventions checked are:

- `pauliY = [[0,-i],[i,0]]`, so
  `spinObservable a = [[a2, a0-i*a1], [a0+i*a1, -a2]]`;
- the product index is `(first subsystem, second subsystem)`, matching
  mathlib's entry rule
  `(A ⊗ₖ B) (i,k) (j,l) = A i j * B k l`;
- the singlet is `(|01> - |10>)/sqrt(2)`; reversing its global sign would not
  change expectations, but the chosen signs are fixed by coordinate lemmas;
  and
- expectations are `sum_i conj(psi_i) (M psi)_i`, not an unconjugated bilinear
  form.

`Bell.Audit.Singlet` imports only the public `Bell` root plus the tactic needed
for finite cases. It verifies:

- the arbitrary-vector public theorem signatures and all four state entries;
- `pauliX * pauliY = i • pauliZ`, which fixes the Pauli-y handedness that
  equal-axis correlations alone cannot detect;
- `(pauliX ⊗ₖ pauliZ)|00> = |10>`, distinguishing the first tensor factor from
  the second;
- a genuinely complex bra example with value `-i`, detecting omission of
  conjugation; and
- direct finite-matrix calculations `XX = YY = ZZ = -1` and `XZ = 0`, without
  deriving those checks from the headline correlation theorem.

### Build and axiom evidence

The final focused verification command was:

```text
cd formal
lake build Bell.Quantum.Basic Bell.Quantum.Pauli Bell.Quantum.Singlet \
  Bell.Audit.Singlet Bell
```

It succeeded with 2,547 graph jobs. The audit printed the following exact axiom
set for Pauli-y Hermiticity, directional Hermiticity, the unit-direction
involution, singlet normalization, joint Hermiticity, the coordinate
calculation, the complex inner-product theorem, and the real correlation
theorem:

```text
[propext, Classical.choice, Quot.sound]
```

These are understood Lean/mathlib foundations; no project axiom is used. A
subsequent default `lake build` succeeded with 2,546 graph jobs.

### Failure-driven corrections

- The first `Bell.Quantum.Basic` skeleton build reported an expected-token
  error at `M *ᵥ psi`: the notation is scoped even though `Matrix.mulVec` was
  imported. Opening only the `Matrix` scope fixed the low-level leaf.
- The first singlet normalization proof stopped at a finite sum over product
  indices. It now explicitly expands `Fintype.sum_prod_type` and both `Fin 2`
  sums. A second attempt exposed the distinction between a real amplitude
  square and its complex coercion; `singletAmplitude_sq_complex` records the
  exact bridge used by normalization and correlation calculations.
- The first norm/involution corollary simplification rewrote `inner a a` to a
  norm equation before exposing its finite coordinate sum. A general
  two-vector inner-product identity is now specialized to `a,a`, avoiding the
  invalid simplification path.
- The first tensor-order audit expanded the Kronecker matrix action but stopped
  at an inner finite dot product. Adding the explicit `dotProduct` expansion
  completed all four product-basis cases.
- Direct audit calculations initially used broad simplification and emitted
  flexible-tactic warnings. Their final proofs use the exact finite rewrite
  sets suggested by Lean, so the focused build is warning-free apart from the
  intentional `#print axioms` informational output.

### Boundary and source scans

- A Lean-source scan over `formal/Bell` found no `sorry`, `admit`, `unsafe`,
  `native_decide`, project `axiom`, or `opaque` declaration.
- `Bell.Quantum.Basic` imports only complex/dot-product APIs; `Pauli` imports
  `Basic` plus Euclidean/Hermitian APIs; `Singlet` imports `Pauli` plus the
  Kronecker API. No quantum implementation imports the `Bell` umbrella,
  `Bell.HiddenVariable`, `Bell.Inequality`, `Bell.Geometry`, or an audit leaf.
- Conversely, no hidden-variable or inequality implementation imports a
  `Bell.Quantum` module. The two mathematical layers remain independent until
  the planned Stage 6 consumer.
- Definition inspection shows `singletCorrelation` is the real part of
  `pureExpectation` through `singletSpinExpectation`; neither definition
  contains `inner` or the target formula. The target first appears as a proved
  conclusion with no hypothesis beyond arbitrary vectors.
- Unit/norm premises occur only in the Pauli involution corollaries, not in the
  three arbitrary-vector singlet theorems.
- `Bell.lean` exports the stable quantum leaf but contains no `Bell.Audit`
  import.
- `git diff --check` passed.

The next incomplete stage is `6-VIOLATION`. It should define and prove the
concrete directions are unit, calculate their exact inner products, and only
then combine the already independent Bell and singlet theorem layers.
