# 6-VIOLATION

## Current Facts

- Stages 1–5 are complete, the repository was clean at Stage 6 start, and the
  public root independently exports both the abstract Bell inequality and the
  calculated singlet correlation.
- The pinned baseline command
  `cd formal && lake build Bell.Inequality.Original Bell.Quantum.Singlet
  Bell.Audit.GeometryApi Bell` succeeds with 2,547 graph jobs.
- `Bell.Quantum.Direction` is `EuclideanSpace Real (Fin 3)`, with coordinates
  `0`, `1`, and `2` corresponding to the x, y, and z axes.
- `singlet_spin_correlation a b` proves
  `singletCorrelation a b = -inner Real a b` from the explicit matrix
  calculation and has no unit-vector or hidden-variable premise.
- `bell_original_of_diagonal_correlation_eq_neg_one` proves equation (15) for
  an arbitrary normalized hidden-variable measure from fixed-setting
  measurability, a.e. binary range, and `correlation model b b = -1`.
- Bell's example after equation (22) uses unit directions satisfying
  `a dot c = 0` and `a dot b = b dot c = 1 / sqrt(2)`. The concrete choice
  `a=e0`, `c=e1`, and `b=(e0+e1)/sqrt(2)` realizes those values.
- Substitution into equation (15) gives `1/sqrt(2) <= 1-1/sqrt(2)`, which is
  false. This arithmetic remains a planning fact until the Stage 6 Lean leaf
  compiles.

## Updated Assumptions

- Keep the concrete directions as ordinary vectors plus separately proved unit
  norm theorems. Do not change the quantum setting type to a subtype merely for
  this finite instantiation.
- A finite-setting reproduction predicate should be an equality between a
  model correlation and an arbitrary target correlation. It belongs in a
  low-dependency hidden-variable leaf and must not import quantum mechanics.
- The no-model result will require reproduction at `(a,b)`, `(a,c)`, `(b,c)`,
  and `(b,b)`. Reproduction at the diagonal is used to derive perfect
  anticorrelation; perfect anticorrelation is not silently bundled into
  reproduction.
- Determinism, local response dependence, and measurement-setting independence
  remain structural properties of `DeterministicLocalModel`: response arities
  omit the remote setting, and one stored measure serves every setting pair.
  Probability normalization, measurability, a.e. binary range, and reproduction
  remain separate theorem hypotheses.
- The numerical violation theorem concerns the explicitly calculated quantum
  correlation only. It states no philosophical, signaling, spacetime, or
  Lorentz-invariance conclusion.

## Big Picture Objective

Construct Bell's explicit unit directions, prove their exact Euclidean
geometry, specialize the independently calculated singlet correlation, and
combine it with the independent measure-theoretic inequality to obtain a
machine-checked finite-setting no-model result with every assumption boundary
visible.

## Detailed Implementation Plan

- Add a narrow geometry leaf owning the three concrete vectors, square-root
  arithmetic, unit-norm theorems, and exact inner products. It may import the
  quantum direction type but no hidden-variable or inequality module.
- Add a low-dependency reproduction leaf defining setting-wise and global
  equality between `correlation model` and an arbitrary target correlation. It
  may import only the hidden-variable correlation layer.
- Add a geometric violation leaf as the first public join between the abstract
  inequality, quantum singlet calculation, concrete directions, and
  reproduction predicate.
- Prove exact singlet-correlation values at the four required setting pairs,
  a strict numerical reversal of equation (15), and the advertised negated
  equation-(15) theorem.
- Prove a finite no-model corollary from the four reproduction equalities, plus
  a convenient global-reproduction corollary if it does not obscure the finite
  logical core.
- Add a non-exported Stage 6 audit leaf checking direction coordinates, unit
  norms, dot products, exact quantum values, theorem signatures, and
  `#print axioms` output.
- Re-export only stable public leaves from `Bell.lean` after their focused
  builds pass.

Expected files:

```text
formal/Bell/HiddenVariable/Reproduction.lean
formal/Bell/Geometry/BellDirections.lean
formal/Bell/Geometry/Violation.lean
formal/Bell/Audit/Violation.lean
formal/Bell.lean
goal-1/6-VIOLATION.md
goal-1/0-plan.md
```

Intended focused build sequence:

```text
cd formal
lake build Bell.HiddenVariable.Reproduction
lake build Bell.Geometry.BellDirections
lake build Bell.Geometry.Violation
lake build Bell.Audit.Violation Bell
lake build
```

## No-Cheating Checks

- Inspect the direction definitions and prove all coordinates, norms, and
  inner products from Euclidean definitions; do not assume the advertised
  geometry in the violation theorem.
- Derive each quantum value through `singlet_spin_correlation`; do not redefine
  `singletCorrelation` or install `-a dot b` as a premise.
- Obtain the local bound only through the general Stage 4 theorem. Do not add a
  special Bell-bound premise whose statement is already the desired bound.
- Inspect the no-model signature to confirm that normalization,
  measurability, a.e. binary range, and the four finite reproduction claims are
  distinct. Confirm structurally that there is one setting-independent measure
  and no remote-setting response argument.
- Confirm that no pointwise perfect-anticorrelation claim is inferred from the
  diagonal expectation. The Stage 4 fixed-setting a.e. bridge must remain the
  only such inference.
- Scan the new geometry and violation leaves for setting-indexed measures,
  hidden target assumptions, physical interpretation claims, proof holes,
  `opaque`, `unsafe`, `native_decide`, and unexplained axioms.

## Completion Requirements

- [ ] Lean proves all three directions have norm one and exactly the advertised
  pairwise inner products.
- [ ] Public theorems expose the exact four singlet-correlation values used by
  the contradiction.
- [ ] `singlet_violates_bell_original` proves that the calculated singlet
  predictions violate equation (15), with no hidden-variable premise.
- [ ] A separate finite-setting no-model corollary enumerates normalization,
  response measurability, a.e. binary outcomes, and reproduction, while its
  model structure visibly encodes deterministic local responses and one fixed
  measure.
- [ ] Any global-reproduction wrapper is proved from the finite theorem and is
  not presented as the minimal result.
- [ ] No philosophical or physical interpretation is embedded in the Lean
  theorem conclusions.
- [ ] Focused builds, adjacent public/audit builds, and the default full build
  succeed.
- [ ] `#print axioms` for geometry, numerical violation, and no-model headline
  theorems reports only understood Lean/mathlib foundations.
- [ ] Proof-hole, target-as-premise, dependency-boundary, setting-dependence,
  interpretation, and whitespace scans pass with every documentation-only hit
  classified.
- [ ] Exact results, failures, corrections, theorem mapping, and remaining
  uncertainty are recorded here and folded into `goal-1/0-plan.md`.

## Stage Results

- In progress. Fill this section only from checked Stage 6 evidence.
