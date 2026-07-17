# 4-BELL-BOUND

## Current Facts

- Stages 1-3 are complete. Stage 4 began with the final Stage 3 documentation
  still present as uncommitted workspace changes; those changes are preserved.
- `DeterministicLocalModel` already stores one fixed arbitrary measure and local
  responses. Normalization, a.e. measurability, a.e./pointwise binary range, and
  perfect anticorrelation are separate assumptions.
- `correlation` is a Bochner integral. Stage 3 proves response-product
  integrability and correlation membership in `[-1,1]` from explicit
  fixed-setting assumptions.
- Mathlib provides `integral_eq_zero_iff_of_nonneg_ae`, `integral_add`,
  `integral_sub`, `integral_congr_ae`, `abs_integral_le_integral_abs`, and
  `integral_mono_ae` under the pinned revision.
- Bell's printed derivation uses equations (12)-(15). Equation (13) is only
  setting-wise almost everywhere. Independent algebraic review shows equation
  (15) for a fixed triple needs the relation only at `b`; requiring it also at
  `c` is an avoidable artifact of rewriting every correlation into Alice-only
  form as in equation (14).

## Updated Assumptions

- The bridge from diagonal correlation `-1` will be proved at one fixed setting.
  Its hypotheses must separately expose normalization, Alice/Bob a.e.
  measurability, and Alice/Bob a.e. binary range.
- The proof will apply zero-integral uniqueness to the nonnegative integrable
  function `A(setting,omega) * B(setting,omega) + 1`, then use binary algebra to
  obtain `A = -B` a.e.
- Equation (14) is an a.e.-congruence rewrite. It does not need a common null
  set over settings and does not itself require a quantum premise.
- The direct Bell theorem will take only `PerfectAnticorrelationAt model b`.
  A separate corollary will derive that premise from the one diagonal
  correlation at `b`. Equation (14) remains available independently for any
  Bob setting where perfect anticorrelation is known.
- The abstract theorem will use one polymorphic setting type for both parties,
  one fixed hidden-variable measure, and only fixed-setting measurability/binary
  hypotheses for the chosen triple.
- No continuity, unit-vector, quantum-correlation, or uniform-in-settings
  premise is needed for equation (15).

## Big Picture Objective

Prove Bell's original measure-theoretic inequality

```text
abs (correlation model a b - correlation model a c)
  <= 1 + correlation model b c
```

from explicit deterministic local-model assumptions, and prove the precise
fixed-setting bridge from correlation `-1` to a.e. perfect anticorrelation.

## Detailed Implementation Plan

- Extend `Bell.HiddenVariable.PerfectAnticorrelation` with the fixed-setting
  extremal-correlation bridge and the equation (14) correlation rewrite.
- Add `Bell.Inequality.Original` with a small binary algebra lemma, a theorem
  taking perfect anticorrelation directly, and a corollary taking diagonal
  correlations.
- Keep all helper facts local/private unless they have an immediate reusable
  consumer.
- Add `Bell.Audit.OriginalInequality`, importing only the public `Bell` root,
  with general-measure signature checks, the Stage 3 finite model, a nontrivial
  saturating/strict case if practical, and `#print axioms` output.
- Publicly re-export `Bell.Inequality.Original` from `Bell.lean`; do not export
  the audit module.
- Update README, the paper/declaration map, correction log if needed, and the
  master stage status.

Expected files:

- `formal/Bell/HiddenVariable/PerfectAnticorrelation.lean`
- `formal/Bell/Inequality/Original.lean`
- `formal/Bell/Audit/OriginalInequality.lean`
- `formal/Bell.lean`
- `README.md`
- `goal-1/0-plan.md`
- `goal-1/4-BELL-BOUND.md`

## Build Structure

- `Bell.HiddenVariable.PerfectAnticorrelation` remains the lowest suitable
  owner for the extremal-correlation bridge and equation (14) rewrite. It may
  import `Correlation`, but it must not import the later inequality leaf.
- `Bell.Inequality.Original` is a new narrow proof leaf importing only the
  hidden-variable correlation/anticorrelation surface. It owns equation (15)
  and its diagonal-correlation corollary.
- `Bell.Audit.OriginalInequality` is a private diagnostic consumer importing
  the public `Bell` umbrella; it owns examples, negative/boundary checks, and
  `#print axioms` commands.
- `Bell.lean` remains a thin public re-export surface. It will import the new
  inequality leaf only after the leaf compiles.
- No existing audit probe or heavy quantum/geometry leaf is a dependency of the
  implementation.

Focused build sequence:

```text
cd formal
lake build Bell.HiddenVariable.PerfectAnticorrelation
lake build Bell.Inequality.Original
lake build Bell.Audit.OriginalInequality
lake build Bell
lake build
```

## No-Cheating Checks

- Confirm the direct theorem takes perfect anticorrelation as a named premise,
  while the diagonal-correlation corollary derives it with the bridge theorem.
- Inspect theorem signatures to ensure the Bell conclusion is not itself a
  premise and no quantum correlation appears.
- Confirm the inequality uses only the one a.e. relation at fixed setting `b`;
  scan for a common `almost everywhere omega, forall setting` claim.
- Confirm the measure remains the model's single setting-independent field and
  no setting-indexed measure is introduced.
- Confirm abstract inequality imports contain no quantum, matrix, Euclidean,
  geometry, sphere, or averaging module.
- Confirm all integrals manipulated by linearity/monotonicity have proved
  integrability and all pointwise bounds are promoted only to a.e. bounds.
- Scan every Lean source for `sorry`, `admit`, project `axiom`, `opaque`, and
  `unsafe`.

## Completion Requirements

- [x] A fixed-setting theorem derives `PerfectAnticorrelationAt model setting`
  from correlation `-1` with normalization, measurability, and binary hypotheses
  visible separately.
- [x] A theorem corresponding to equation (14) rewrites correlation using the
  appropriate fixed-setting a.e. anticorrelation premise.
- [x] The public direct theorem proves equation (15) from only the relevant
  abstract probability/local-response assumptions.
- [x] A public corollary proves equation (15) from the one required diagonal
  correlation at `b`, deriving rather than assuming anticorrelation.
- [x] Every response product/difference used by integral linearity or monotonicity
  is proved integrable under explicit hypotheses.
- [x] General-measure and finite-model audits exercise the direct theorem,
  bridge, and diagonal-correlation corollary.
- [x] Inspection confirms only the required fixed-setting null sets are used and
  no continuity, quantum, geometric, or uniform premise enters the core.
- [x] `#print axioms` for every headline result reports only understood
  Lean/mathlib foundations.
- [x] Focused theorem/audit builds and the full public build pass.
- [x] Proof-hole, import-boundary, hypothesis, quantifier, and diff scans pass.
- [x] Exact failures/corrections/evidence are recorded here and folded into
  `goal-1/0-plan.md`.

## Stage Results

Stage 4 completed on 2026-07-17. No quantum calculation, geometric direction,
or physical interpretation was added.

### Public declarations delivered

- `Bell.HiddenVariable.perfectAnticorrelationAt_of_correlation_eq_neg_one`
  proves equation (13) at one fixed setting. Its signature separately requires
  `[IsProbabilityMeasure model.hiddenMeasure]`, Alice/Bob a.e.
  measurability, Alice/Bob a.e. binary range, and the diagonal correlation
  equality. The proof integrates the nonnegative defect `A * B + 1`, proves its
  integral is zero using normalization, obtains defect zero a.e., and closes
  the binary cases. The conclusion is setting-wise a.e., not pointwise.
- `Bell.HiddenVariable.correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt`
  is equation (14). It uses `integral_congr_ae` at the named Bob setting and
  does not claim a common null set over settings.
- `Bell.Inequality.bell_original_of_perfectAnticorrelationAt` proves equation
  (15) for an arbitrary hidden-variable probability measure. The public
  signature uses only a.e. measurability and binary range for `A(a)`, `A(b)`,
  and `B(c)`, plus `PerfectAnticorrelationAt model b`. Integrability of the
  `A(a) * B(b)` product is transferred through its a.e. equality with
  `-(A(a) * A(b))`; every other integral linearity or monotonicity step has an
  explicit integrability proof.
- `Bell.Inequality.bell_original_of_diagonal_correlation_eq_neg_one` derives
  the preceding fixed-`b` premise from the single equality `P(b,b) = -1` and
  then invokes the direct theorem. It does not require `P(c,c) = -1`.
- `Bell.lean` remains a thin re-export surface and now publicly imports only
  the stable `Bell.Inequality.Original` leaf in addition to the Stage 3 leaves.
  The audit module is not re-exported.

Paper equations (12)-(15) now map as follows:

| Equation | Lean treatment |
|---|---|
| (12) | `[IsProbabilityMeasure model.hiddenMeasure]`; its `measure_univ = 1` fact is used when integrating constants |
| (13) | `perfectAnticorrelationAt_of_correlation_eq_neg_one` |
| (14) | `correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt` |
| (15) | `bell_original_of_perfectAnticorrelationAt` and `bell_original_of_diagonal_correlation_eq_neg_one` |

### Checked mathematical correction

The initial equation-(14)-style proof plan rewrote every correlation into an
Alice-only integral and therefore assumed perfect anticorrelation at both `b`
and `c`. Independent pointwise algebra showed that this was stronger than
necessary. Keeping the `c` response as `B(c)` gives, at the fixed `b` null-set
intersection,

```text
|A(a) B(b) - A(a) B(c)| <= 1 + A(b) B(c).
```

Consequently equation (15) requires perfect anticorrelation only at `b`; the
final direct theorem and diagonal corollary use that minimized assumption. This
correction is recorded as item 18 in `goal-1/0-plan.md`.

### Audit evidence

`Bell.Audit.OriginalInequality` is a private diagnostic consumer importing the
public `Bell` root plus only the ENNReal/Dirac APIs needed for its models. It
contains:

- arbitrary-setting/arbitrary-measurable-space examples reproducing both
  public theorem signatures;
- an equal mixture of two Boolean hidden values and a nonconstant three-setting
  model with pointwise perfect anticorrelation;
- checked values `P(a,b)=0`, `P(a,c)=0`, `P(b,b)=-1`, and `P(b,c)=1`;
- applications of the direct theorem, equation (14), and the
  diagonal-correlation corollary to that finite model;
- a strict instance `0 < 2` and a sharp instance `2 = 2`;
- a Dirac model whose diagonal correlation is `-1` and for which the bridge
  yields a.e. anticorrelation, while pointwise anticorrelation provably fails at
  the null hidden value; and
- three adversarial models. A normalized binary model without anticorrelation,
  a normalized perfectly anticorrelated model without binary range, and a
  mass-two binary perfectly anticorrelated model each falsify the displayed
  inequality. These confirm that the named premises are substantive.

### Build and axiom evidence

The final focused verification command was:

```text
cd formal
lake build Bell.HiddenVariable.PerfectAnticorrelation \
  Bell.Inequality.Original Bell.Audit.OriginalInequality Bell
```

It succeeded with 2,515 graph jobs. The audit replay printed the following for
each of the bridge, equation (14), direct inequality, and diagonal corollary:

```text
[propext, Classical.choice, Quot.sound]
```

These are understood Lean/mathlib foundations; no project axiom is used. A
subsequent default `lake build` succeeded with 2,514 graph jobs.

### Failure-driven corrections

- The first focused bridge build failed because a combined four-case
  `norm_num ... at hzero ⊢` invocation sometimes closed the goal before the
  trailing target action. The cases that need the zero-defect contradiction
  are now explicit; the focused bridge build then passed.
- The first focused inequality build left eight pointwise goals after
  `simp_all` oriented the anticorrelation equality through the unconstrained
  expression `B(b)`. The proof now explicitly derives
  `B(b) = -A(b)` before splitting the three binary responses. The next focused
  build passed.
- The stronger initial public theorem requiring anticorrelation at both `b`
  and `c` was removed before publication after the fixed-`b` mixed-response
  proof compiled. The plan, record, and theorem documentation were updated to
  match the checked weaker assumptions.

### Boundary and source scans

- A Lean-source scan over `formal/Bell` found no `sorry`, `admit`, `unsafe`,
  `native_decide`, project `axiom`, or `opaque` declaration.
- The corresponding scan including `goal-1` found only the expected guardrail,
  command-template, and recorded axiom-audit prose; the Lean-source-only scan
  remained empty.
- Import inspection found no quantum, matrix, Euclidean, geometry, sphere,
  averaging, continuity, or topology import in the hidden-variable or original
  inequality layers. `Bell.Inequality.Original` imports only
  `Bell.HiddenVariable.PerfectAnticorrelation`.
- Quantifier scans found no `almost everywhere omega, forall setting`,
  `ae_all_iff`, or infinite-intersection shortcut. The theorem proof intersects
  only fixed-setting a.e. facts with `filter_upwards`.
- Measure-shape inspection still finds exactly the one
  `hiddenMeasure : Measure Ω` field and no setting-indexed distribution.
- `Bell.lean` contains no `Bell.Audit` import; the diagnostic examples do not
  enter the public dependency graph.
- `git diff --check` passed.

The next incomplete stage is `5-SINGLET`. It should independently define and
calculate the finite-dimensional singlet correlation without importing the
Bell inequality into the quantum calculation leaf.
