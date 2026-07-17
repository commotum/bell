# Bell 1964 in Lean 4

This repository is developing a reusable Lean formalization and audit of
J. S. Bell's 1964 paper *On the Einstein Podolsky Rosen Paradox*.

The source and dependency guardrails are established. The public abstract layer
now defines deterministic local hidden-variable models and proves Bell's
original inequality for an arbitrary probability measure. The quantum
calculation remains a later, independent stage.

## Public hidden-variable API

The `Bell.HiddenVariable` namespace currently provides:

- `DeterministicLocalModel`, containing one fixed hidden-variable measure and
  local response functions whose arities exclude the remote setting;
- pointwise and almost-everywhere binary outcome predicates;
- separately named Alice/Bob measurability and binary-range assumptions;
- `correlation`, defined as the integral of the response product;
- integrability and `[-1, 1]` bounds under explicit normalization,
  measurability, and binary-range hypotheses;
- distinct pointwise and setting-wise almost-everywhere perfect
  anticorrelation predicates;
- a fixed-setting proof that diagonal correlation `-1` forces almost-everywhere
  perfect anticorrelation;
- Bell's equation (14) correlation rewrite; and
- `bell_original_of_perfectAnticorrelationAt` together with
  `bell_original_of_diagonal_correlation_eq_neg_one`, proving
  `|P(a,b) - P(a,c)| ≤ 1 + P(b,c)` without quantum or geometric assumptions.

The raw model deliberately does not bundle probability normalization,
measurability, or binary range. A single stored measure represents
measurement-setting independence for this model class; it has no setting
argument.

## Pinned formal environment

- Lean: `v4.31.0`
- mathlib: commit `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`
  (tag `v4.31.0`)

From a checkout with `elan` installed:

```text
cd formal
lake update
lake exe cache get
lake build Bell.Audit.ProbabilityApi Bell.Audit.GeometryApi Bell.Audit.QuantumApi
lake build Bell.Audit.LocalModel
lake build Bell.Audit.OriginalInequality
lake build
```

The audit modules are diagnostic leaves and are not re-exported by `Bell.lean`.
`Bell.Audit.LocalModel` checks a general-measure signature, an equal-weight
two-point model, exact boundary correlations, a zero-probability exception, and
the axioms of the Stage 3 headline theorems.

`Bell.Audit.OriginalInequality` checks the general measure-theoretic theorem
signatures, a nonconstant equal-weight two-point model with strict and sharp
instances, the fixed-setting null-set behavior, and countermodels showing that
normalization, binary range, and perfect anticorrelation are substantive
premises. The direct fixed-triple proof needs anticorrelation only at `b`; the
diagonal-correlation corollary accordingly assumes only `P(b,b) = -1`.

The paper transcription and original scan are in [`bell-1964`](bell-1964/).
