# 3-LOCAL-MODEL

## Current Facts

- Stages 1 and 2 are complete, and Stage 3 began from a clean Git worktree.
- The source equations relevant here are Bell's response functions in (1), the
  fixed distribution and correlation in (2), normalization in (12), and the
  pointwise-except-on-a-null-set relation in (13).
- The pinned probability probe confirms `Measure`, `IsProbabilityMeasure`,
  `AEMeasurable`, `Integrable`, Bochner integration, `integral_congr_ae`, and
  finite conjunction of a.e. facts.
- The public root now exports the three stable hidden-variable modules. All
  audit modules remain non-exported leaves.
- Stage 4, not this stage, owns the implication from correlation `-1` to perfect
  anticorrelation and Bell's inequality.

## Updated Assumptions

- A deterministic local model stores exactly one measure on the hidden
  variable space and two response functions with arities
  `SettingA -> Omega -> Real` and `SettingB -> Omega -> Real`.
- Determinism is represented by response functions. Locality is represented by
  the absence of the remote setting from each response's arguments. This is a
  mathematical parameter-independence interface, not a formalization of every
  physical meaning of locality.
- Measurement-setting independence is represented by the single stored measure,
  whose type has no setting argument. Probability normalization remains a
  separate `IsProbabilityMeasure` assumption.
- Binary range and a.e. measurability are separately named predicates; the
  raw structure does not silently assume either one.
- Correlation is the Bochner integral of the product. Its definition is total,
  while the useful integrability and range theorems require explicit fixed-
  setting measurability, binary-range, and probability assumptions.
- Pointwise and a.e. perfect anticorrelation are different declarations.
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

- [x] The raw public model exposes fixed-measure and local-response arities with
  normalization, range, and measurability logically separate.
- [x] Pointwise and a.e. binary predicates compile and have the elementary
  absolute-value/range lemmas required by correlation proofs.
- [x] The correlation definition compiles for an arbitrary measure space.
- [x] Under explicit probability, a.e.-measurability, and binary assumptions,
  the response product is integrable and correlation lies in `[-1,1]`.
- [x] Pointwise and setting-wise a.e. perfect anticorrelation are distinct, with
  no invalid a.e. quantifier-order theorem.
- [x] An audit module covers a general-measure signature and a finite two-point
  normalized model with checked correlation values.
- [x] `#print axioms` for Stage 3 headline theorems contains only understood
  Lean/mathlib foundations.
- [x] Focused hidden-variable/audit builds and the full public build pass.
- [x] Dependency/no-cheating scans and `git diff --check` pass.
- [x] Exact evidence is recorded here and folded into `goal-1/0-plan.md`.

## Stage Results

Stage 3 completed on 2026-07-17. No Bell inequality, quantum calculation, or
geometric violation was started.

### Public API delivered

- `DeterministicLocalModel` stores one `Measure Omega` and responses of types
  `SettingA -> Omega -> Real` and `SettingB -> Omega -> Real`. It has no proof
  fields. The fixed measure has no setting argument and each response lacks the
  remote setting argument.
- `IsBinaryOutcome`, `IsBinaryValued`, and `IsAEBinaryValued` distinguish a
  single value, a pointwise response, and an a.e. response. Alice/Bob variants
  separately quantify these assumptions over settings. Pointwise binary range
  implies setting-wise a.e. binary range.
- `AliceAEMeasurable` and `BobAEMeasurable` name measurability independently of
  the range predicates. Normalization appears separately as
  `[IsProbabilityMeasure model.hiddenMeasure]` in analytic theorem signatures.
- `correlation` is the Bochner integral of the local response product with
  respect to the stored arbitrary measure.
- `responseProduct_integrable`, `neg_one_le_correlation`,
  `correlation_le_one`, `abs_correlation_le_one`, and `correlation_mem_Icc`
  establish integrability and the closed interval bound from explicit fixed-
  setting probability, a.e.-measurability, and a.e.-binary premises. The lower
  and upper bounds use `integral_mono_ae`, so measurability/integrability are
  semantically used rather than decorative hypotheses.
- `PointwisePerfectAnticorrelationAt` and `PerfectAnticorrelationAt` distinguish
  pointwise from fixed-setting a.e. equality. Their all-setting counterparts
  preserve `forall setting, almost everywhere omega`; no common a.e. set over
  every setting is defined.

`Bell.lean` publicly re-exports these three stable modules. The audit module
imports only `Bell` to verify that the advertised public surface is sufficient.

### Requirement-specific examples

`Bell.Audit.LocalModel` contains:

- an arbitrary-measure construction/signature check with polymorphic setting
  and hidden-variable types;
- an equal mixture of `dirac false` and `dirac true`, proved normalized and
  proved to give strictly positive mass to both points;
- nonconstant binary local responses, separately proved measurable and
  pointwise perfectly anticorrelated;
- checked correlations `-1` at equal Boolean settings and `1` at opposite
  settings;
- a Dirac model whose relation holds a.e. but fails pointwise at the null point,
  proving the two public notions are not being conflated.

The finite example is diagnostic only. The implementation and correlation
theorems remain general over an arbitrary measurable hidden-variable space.

### Build and axiom evidence

Final focused verification:

```text
cd formal
lake build Bell.HiddenVariable.Basic Bell.HiddenVariable.Correlation \
  Bell.HiddenVariable.PerfectAnticorrelation Bell.Audit.LocalModel Bell
```

The three public leaves and root built successfully; the final audit build
reported 2,514 graph jobs and no warning. A subsequent default `lake build`
reported success with 2,513 graph jobs.

The retained `#print axioms` checks for the outcome lemma, product
integrability, all three correlation-bound forms, interval membership, and the
pointwise-to-a.e. anticorrelation conversion each reported exactly:

```text
[propext, Classical.choice, Quot.sound]
```

These are understood Lean/mathlib foundations. There is no project axiom.

### Failure-driven corrections

- The first skeleton build revealed Lean 4.31's module visibility rule. Public
  declarations now live under `@[expose] public section`, dependencies intended
  for consumers use `public import`, and audits remain private.
- Initial norm-bound simplification did not match `abs (A * B)` after rewriting;
  the proof was corrected with an exact absolute-value rewrite.
- The first finite audit exposed missing local ENNReal notation/imports,
  reducibility of the probability instance through the model projection, and
  an overly complicated Dirac a.e. proof. Exact ENNReal imports, an explicit
  projected instance, and `ae_eq_dirac` resolved those issues.
- An initial correlation bound could technically ignore integrability because
  mathlib defines an integral for every function. It was replaced by lower and
  upper `integral_mono_ae` proofs using the proved product integrability; the
  absolute-value and interval forms now derive from those bounds.

### Boundary and no-cheating audit

- Lean-source scans found no `sorry`, `admit`, `unsafe`, or project `axiom`.
- Hidden-variable imports contain no project quantum, matrix, Euclidean,
  geometry, or Bell-inequality module.
- Inspection found exactly one `hiddenMeasure : Measure Omega` field and no
  setting-indexed measure type.
- The response fields have only local-setting and hidden-variable arguments.
- A quantifier scan found no `almost everywhere omega, forall setting`
  declaration. The documented all-setting a.e. predicate unfolds in the safe
  opposite order.
- `Bell.lean` re-exports the stable leaves but not `Bell.Audit.LocalModel`.
- `git diff --check` passed.

Stage 4 should use this API to prove the correlation-`-1` bridge and Bell's
inequality. The Stage 3 a.e.-binary results are a deliberate modern weakening
of Bell's pointwise equation (1); `IsBinaryValued.ae` records that the paper's
stronger assumption implies the reusable analytic one.
