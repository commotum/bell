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
  setting-wise almost everywhere, and a fixed triple needs only the relations
  at `b` and `c`.

## Updated Assumptions

- The bridge from diagonal correlation `-1` will be proved at one fixed setting.
  Its hypotheses must separately expose normalization, Alice/Bob a.e.
  measurability, and Alice/Bob a.e. binary range.
- The proof will apply zero-integral uniqueness to the nonnegative integrable
  function `A(setting,omega) * B(setting,omega) + 1`, then use binary algebra to
  obtain `A = -B` a.e.
- Equation (14) is an a.e.-congruence rewrite. It does not need a common null
  set over settings and does not itself require a quantum premise.
- The direct Bell theorem will take `PerfectAnticorrelationAt model b` and
  `PerfectAnticorrelationAt model c` explicitly. A separate corollary will
  derive those two premises from diagonal correlations at `b` and `c`.
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
- Confirm the two a.e. relations used are only at the fixed settings `b` and
  `c`; scan for a common `almost everywhere omega, forall setting` claim.
- Confirm the measure remains the model's single setting-independent field and
  no setting-indexed measure is introduced.
- Confirm abstract inequality imports contain no quantum, matrix, Euclidean,
  geometry, sphere, or averaging module.
- Confirm all integrals manipulated by linearity/monotonicity have proved
  integrability and all pointwise bounds are promoted only to a.e. bounds.
- Scan every Lean source for `sorry`, `admit`, project `axiom`, `opaque`, and
  `unsafe`.

## Completion Requirements

- [ ] A fixed-setting theorem derives `PerfectAnticorrelationAt model setting`
  from correlation `-1` with normalization, measurability, and binary hypotheses
  visible separately.
- [ ] A theorem corresponding to equation (14) rewrites correlation using the
  appropriate fixed-setting a.e. anticorrelation premise.
- [ ] The public direct theorem proves equation (15) from only the relevant
  abstract probability/local-response assumptions.
- [ ] A public corollary proves equation (15) from diagonal correlations at the
  two required settings, deriving rather than assuming anticorrelation.
- [ ] Every response product/difference used by integral linearity or monotonicity
  is proved integrable under explicit hypotheses.
- [ ] General-measure and finite-model audits exercise the direct theorem,
  bridge, and diagonal-correlation corollary.
- [ ] Inspection confirms only finitely many fixed-setting null sets are used and
  no continuity, quantum, geometric, or uniform premise enters the core.
- [ ] `#print axioms` for every headline result reports only understood
  Lean/mathlib foundations.
- [ ] Focused theorem/audit builds and the full public build pass.
- [ ] Proof-hole, import-boundary, hypothesis, quantifier, and diff scans pass.
- [ ] Exact failures/corrections/evidence are recorded here and folded into
  `goal-1/0-plan.md`.

## Stage Results

- In progress.
