# 3-LOCAL-MODEL

## Current Facts

- Stages 1 and 2 are complete, and Stage 3 began from a clean Git worktree.
- The source equations relevant here are Bell's response functions in (1), the
  fixed distribution and correlation in (2), normalization in (12), and the
  pointwise-except-on-a-null-set relation in (13).
- The pinned probability probe confirms `Measure`, `IsProbabilityMeasure`,
  `AEMeasurable`, `Integrable`, Bochner integration, `integral_congr_ae`, and
  finite conjunction of a.e. facts.
- The public root currently exports no declarations. The audit probes remain
  non-exported leaves.
- Stage 4, not this stage, owns the implication from correlation `-1` to perfect
  anticorrelation and Bell's inequality.

## Updated Assumptions

- A deterministic local model will store exactly one measure on the hidden
  variable space and two response functions with arities
  `SettingA -> Omega -> Real` and `SettingB -> Omega -> Real`.
- Determinism is represented by response functions. Locality is represented by
  the absence of the remote setting from each response's arguments. This is a
  mathematical parameter-independence interface, not a formalization of every
  physical meaning of locality.
- Measurement-setting independence is represented by the single stored measure,
  whose type has no setting argument. Probability normalization remains a
  separate `IsProbabilityMeasure` assumption.
- Binary range and a.e. measurability remain separately named predicates; the
  raw structure does not silently assume either one.
- Correlation is the Bochner integral of the product. Its definition is total,
  while the useful integrability and range theorems require explicit fixed-
  setting measurability, binary-range, and probability assumptions.
- Pointwise and a.e. perfect anticorrelation will be different declarations.
  No declaration may exchange `forall setting, eventually` with
  `eventually, forall setting`.

## Big Picture Objective

Define a reusable general-measure deterministic local hidden-variable model,
its correlation, and precise pointwise/a.e. assumption vocabulary. Prove the
basic integrability and `[-1,1]` correlation bounds needed by Stage 4 without
proving Bell's inequality itself.

## Detailed Implementation Plan

- Add `Bell.HiddenVariable.Basic` with the raw model, binary outcome predicates,
  separately named Alice/Bob range and measurability predicates, and elementary
  range lemmas.
- Add `Bell.HiddenVariable.Correlation` with the correlation integral,
  fixed-setting integrability, and lower/upper bound theorems.
- Add `Bell.HiddenVariable.PerfectAnticorrelation` with distinct pointwise and
  setting-wise a.e. definitions and only logically immediate conversion lemmas.
- Add `Bell.Audit.LocalModel` with a general-measure signature check, a
  nontrivial finite two-point model, computed boundary correlations, and
  `#print axioms` for the Stage 3 headline theorems.
- Re-export only the three stable hidden-variable modules from `Bell.lean`; do
  not export the audit module.
- Update the README and master plan with the exact API and evidence.

Expected files:

- `formal/Bell/HiddenVariable/Basic.lean`
- `formal/Bell/HiddenVariable/Correlation.lean`
- `formal/Bell/HiddenVariable/PerfectAnticorrelation.lean`
- `formal/Bell/Audit/LocalModel.lean`
- `formal/Bell.lean`
- `README.md`
- `goal-1/0-plan.md`
- `goal-1/3-LOCAL-MODEL.md`

## No-Cheating Checks

- Inspect the model's measure field type and scan for a setting-indexed measure.
- Inspect response arities to confirm Alice has no Bob setting and Bob has no
  Alice setting.
- Confirm normalization, binary range, and measurability are not proof fields of
  the raw model and remain explicit in theorem signatures.
- Scan for a theorem with the forbidden quantifier order
  `forall eventually`/a common full-measure set over all settings.
- Confirm the finite model is an audit example and not the implementation of
  the general correlation theorem.
- Confirm no quantum, matrix, Euclidean-geometry, or Bell-inequality module is
  imported by the hidden-variable layer.
- Scan all Lean sources for `sorry`, `admit`, project `axiom`, `unsafe`, and
  declarations that merely assume a claimed range conclusion.

## Completion Requirements

- [ ] The raw public model exposes fixed-measure and local-response arities with
  normalization, range, and measurability logically separate.
- [ ] Pointwise and a.e. binary predicates compile and have the elementary
  absolute-value/range lemmas required by correlation proofs.
- [ ] The correlation definition compiles for an arbitrary measure space.
- [ ] Under explicit probability, a.e.-measurability, and binary assumptions,
  the response product is integrable and correlation lies in `[-1,1]`.
- [ ] Pointwise and setting-wise a.e. perfect anticorrelation are distinct, with
  no invalid a.e. quantifier-order theorem.
- [ ] An audit module covers a general-measure signature and a finite two-point
  normalized model with checked correlation values.
- [ ] `#print axioms` for Stage 3 headline theorems contains only understood
  Lean/mathlib foundations.
- [ ] Focused hidden-variable/audit builds and the full public build pass.
- [ ] Dependency/no-cheating scans and `git diff --check` pass.
- [ ] Exact evidence is recorded here and folded into `goal-1/0-plan.md`.

## Stage Results

- In progress.
