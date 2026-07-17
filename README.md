# Bell 1964 in Lean 4

This repository is developing a reusable Lean formalization and audit of
J. S. Bell's 1964 paper *On the Einstein Podolsky Rosen Paradox*.

The current verified project infrastructure is intentionally minimal. The
mathematical implementation begins only after the source and dependency
guardrails in [`goal-1`](goal-1/0-plan.md) are established.

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
lake build
```

The API probes are diagnostic leaves and are not re-exported by `Bell.lean`.
Their role is to compile-check the planned probability, Euclidean-geometry, and
finite-matrix dependencies before substantive definitions are introduced.

The paper transcription and original scan are in [`bell-1964`](bell-1964/).
