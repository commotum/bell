# 6-VIOLATION

## Current Facts

- Stages 1–5 were complete and the repository was clean at Stage 6 start. Stage
  6 is now complete, and the public root exports the abstract inequality,
  calculated singlet correlation, generic reproduction predicates, concrete
  directions, and their integration theorem.
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
- Substitution into equation (15) gives `1/sqrt(2) <= 1-1/sqrt(2)`. Lean now
  proves the strict reverse and the negation of equation (15) at these settings.

## Updated Assumptions

- Keep the concrete directions as ordinary vectors plus separately proved unit
  norm theorems. Do not change the quantum setting type to a subtype merely for
  this finite instantiation.
- The finite-setting reproduction predicate is an equality between a
  model correlation and an arbitrary target correlation. It belongs in a
  low-dependency hidden-variable leaf and must not import quantum mechanics.
- The minimal four-correlation result requires reproduction at `(a,b)`,
  `(a,c)`, `(b,c)`, and `(b,b)`. Reproduction at the diagonal is used to derive
  perfect anticorrelation; perfect anticorrelation is not silently bundled into
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

- [x] Lean proves all three directions have norm one and exactly the advertised
  pairwise inner products.
- [x] Public theorems expose the exact four singlet-correlation values used by
  the contradiction.
- [x] `singlet_violates_bell_original` proves that the calculated singlet
  predictions violate equation (15), with no hidden-variable premise.
- [x] A separate finite-setting no-model corollary enumerates normalization,
  response measurability, a.e. binary outcomes, and reproduction, while its
  model structure visibly encodes deterministic local responses and one fixed
  measure.
- [x] Any global-reproduction wrapper is proved from the finite theorem and is
  not presented as the minimal result.
- [x] No philosophical or physical interpretation is embedded in the Lean
  theorem conclusions.
- [x] Focused builds, adjacent public/audit builds, and the default full build
  succeed.
- [x] `#print axioms` for geometry, numerical violation, and no-model headline
  theorems reports only understood Lean/mathlib foundations.
- [x] Proof-hole, target-as-premise, dependency-boundary, setting-dependence,
  interpretation, and whitespace scans pass with every documentation-only hit
  classified.
- [x] Exact results, failures, corrections, theorem mapping, and remaining
  uncertainty are recorded here and folded into `goal-1/0-plan.md`.

## Stage Results

Stage 6 completed on 2026-07-17. It formalizes the exact finite-setting
contradiction only; Bell's quantitative smoothed non-approximation argument
remains Stage 7 work.

### Public API delivered

`Bell.HiddenVariable.Reproduction` is a low-dependency leaf importing only the
correlation layer. It provides:

- `ReproducesCorrelationAt model target a b`, equality of one model
  correlation and one independently supplied target value; and
- `ReproducesCorrelation model target`, the pointwise-in-settings family of
  those equalities, plus `.at` specialization.

Neither predicate bundles normalization, measurability, binary outcomes,
perfect anticorrelation, or a quantum definition. They concern correlation
expectations, not complete joint probability laws.

`Bell.Geometry.BellDirections` imports the existing quantum direction type and
real square-root arithmetic, but no hidden-variable or inequality module. It
defines

```text
bellA = e0
bellC = e1
bellB = (1 / sqrt(2)) • (bellA + bellC)
```

and proves positivity/nonzeroness of `sqrt(2)` and `bellScale`,
`bellScale^2=1/2`, the strict scalar inequality
`1-bellScale < bellScale`, all three unit norms, and

```text
inner bellA bellC = 0
inner bellA bellB = inner bellB bellC = 1 / sqrt(2).
```

`Bell.Geometry.Violation` is the first join between the abstract and quantum
layers. Its public results include:

- the exact calculated values `Q(a,b)=-bellScale`, `Q(a,c)=0`,
  `Q(b,c)=-bellScale`, and `Q(b,b)=-1`;
- `singlet_bell_original_lhs` and `singlet_bell_original_rhs`, identifying the
  two sides as `bellScale` and `1-bellScale`;
- `singlet_bell_original_strict_violation` and the premise-free
  `singlet_violates_bell_original`;
- `singletCorrelations_incompatible_with_perfectAnticorrelationAt_bellB`, the
  direct layer with fixed-`b` a.e. perfect anticorrelation visible;
- `singletCorrelations_incompatible_with_deterministicLocalModel_at_bellDirections`,
  the four-correlation layer that derives that a.e. premise from `Q(b,b)=-1`;
- `no_deterministicLocalModel_reproduces_singletCorrelations_at_bellDirections`,
  a literal negated-existence statement listing the finite normalization,
  measurability, a.e. binary-range, and reproduction assumptions; and
- `no_deterministicLocalModel_reproduces_singletCorrelation`, a convenient
  all-settings wrapper proved by specializing the finite theorem.

`Bell.lean` re-exports the stable reproduction and geometric violation layers.
`Bell.Audit.Violation` remains private and imports the public root, so its
success verifies the intended export surface.

### Assumption and quantifier audit

The finite theorem uses an arbitrary hidden-variable type and measurable space.
Its `DeterministicLocalModel Direction Direction Omega` argument structurally
records deterministic responses, local response dependence through separate
arities, and measurement-setting independence through one measure with no
setting argument. It separately requires:

- `[IsProbabilityMeasure model.hiddenMeasure]`;
- Alice a.e. measurability and a.e. binary range only at `a` and `b`;
- Bob a.e. measurability and a.e. binary range only at `b` and `c`; and
- correlation reproduction only at `(a,b)`, `(a,c)`, `(b,b)`, and `(b,c)`.

The `(b,b)` equality is combined with the calculated quantum value to obtain
the diagonal model correlation `-1`. The existing Stage 4 extremal-correlation
theorem then derives `PerfectAnticorrelationAt model b`, explicitly a
fixed-setting a.e. statement. The direct Stage 6 theorem applies the general
Stage 4 Bell inequality and rewrites only its three correlation values. No
pointwise anticorrelation claim, common null set, continuity premise, or a.e.
quantifier exchange occurs.

The audit's printed signatures confirm that Bob-at-`a` and Alice-at-`c`
assumptions are absent. The global wrapper merely specializes four
setting-wise hypotheses; it does not construct `almost everywhere omega,
forall setting`.

### Geometry and source audit

The audit expands all nine coordinates and proves that the three directional
Pauli observables square to the identity using the public norm theorems. This
connects the geometric choice to the Stage 5 `±1` observable certificate rather
than using non-unit algebraic vectors accidentally.

The exact sign choice is `bellB=(bellA+bellC)/sqrt(2)`. With the calculated
singlet correlation, equation (15) becomes

```text
bellScale <= 1 - bellScale,
```

while `one_sub_bellScale_lt_bellScale` proves the strict reverse. Choosing the
opposite diagonal would not instantiate this displayed form of the violation.

Bell states this inner-product triple after equation (22), in the robustness
argument. Its use here to give an explicit instance of the already independent
equations (3) and (15) is a valid modern specialization, not a claim that the
paper displayed this exact substitution immediately after (15). This is now
correction/clarification item 21 in `goal-1/0-plan.md`. Item 20 records the
separate distinction between correlation reproduction and reproduction of all
quantum statistics.

### Build and axiom evidence

The final focused command was:

```text
cd formal
lake build Bell.HiddenVariable.Reproduction Bell.Geometry.BellDirections \
  Bell.Geometry.Violation Bell.Audit.Violation Bell
```

It succeeded with 2,550 graph jobs. The audit printed the exact public
direction, inner-product, strict-violation, direct-perfect-anticorrelation,
four-correlation, finite-existence-negation, and global-wrapper signatures.
Every recorded `#print axioms` result was exactly:

```text
[propext, Classical.choice, Quot.sound]
```

These are understood Lean/mathlib foundations; no project axiom is used. The
subsequent default `lake build` succeeded with 2,549 graph jobs.

### No-cheating and source-scan evidence

The proof-hole command

```text
rg -n --glob '*.lean' \
  '\bsorry\b|\badmit\b|^\s*axiom\b|\bunsafe\b|\bopaque\b|\bnative_decide\b' \
  formal/Bell
```

returned no matches. Import scans returned no quantum-to-hidden-variable,
quantum-to-inequality, quantum-to-geometry, abstract-to-quantum,
abstract-to-geometry, or public-to-audit dependency. The recorded imports are
exactly layered as planned: reproduction imports `Correlation`; directions
import `Pauli` and `Real.Sqrt`; violation imports the four exact public leaves;
the audit alone imports `Bell`.

The target-shortcut scan found only the existing Stage 5
`def singletCorrelation`, whose inspected body is the real part of the explicit
matrix expectation. The Stage 6 value proofs call `singlet_spin_correlation`;
no target is installed as `fun a b => -inner Real a b`, and no violation or
Bell-bound hypothesis appears in a headline theorem. The structural scan found
the sole model fields

```text
hiddenMeasure : Measure Omega
aliceResponse : SettingA -> Omega -> Real
bobResponse : SettingB -> Omega -> Real
```

and no setting-indexed measure or forbidden a.e. quantifier pattern. The only
physical-term hit was the module-level sentence saying that no signaling or
spacetime conclusion is stated; theorem conclusions contain none.

`git diff --check` succeeded. The recorded status after verification listed
only the Stage 6 public-root/direction edits and the new audit leaf; unrelated
workspace files were untouched.

### Failure-driven refinements and next work

- An initial scratch geometry probe imported the broad `Mathlib.Tactic`
  umbrella and failed because that aggregate object had not been built. The
  checked leaf uses only `Mathlib.Tactic.NormNum`, matching the import-hygiene
  rule and compiling directly.
- The first API sketch exposed only the four-correlation no-go. Independent
  assumption-flow review identified the value of a separate direct theorem
  taking `PerfectAnticorrelationAt model bellB`; that layer was added before
  final validation.
- Literal `1 / sqrt(2)` inner-product aliases were added alongside the internal
  `bellScale` forms so the paper's advertised values are directly visible in
  public theorem statements.
- No Stage 6 mathematical or API uncertainty remains open. Stage 7 must still
  decide and prove the precise robust approximation theorem; this exact
  contradiction does not by itself complete equations (16)–(22).
