# Bell 1964 in Lean 4

This repository is developing a reusable Lean formalization and audit of
J. S. Bell's 1964 paper *On the Einstein Podolsky Rosen Paradox*.

The source and dependency guardrails are established, and the first public
mathematical layer now defines deterministic local hidden-variable models and
their correlations. Bell's inequality and the quantum calculation remain later,
independent stages.

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
  anticorrelation predicates.

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
lake build
```

The audit modules are diagnostic leaves and are not re-exported by `Bell.lean`.
`Bell.Audit.LocalModel` checks a general-measure signature, an equal-weight
two-point model, exact boundary correlations, a zero-probability exception, and
the axioms of the Stage 3 headline theorems.

The paper transcription and original scan are in [`bell-1964`](bell-1964/).
