# 2-BOOTSTRAP

## Current Facts

- Stage 1 is complete and its final evidence append was the only pre-existing
  working-tree modification at Stage 2 start.
- The repository had no Lean project or Lean source before this stage.
- Lean `v4.31.0` and `v4.32.0` are installed locally; `v4.31.0` was the default
  and reports commit `68218e876d2a38b1985b8590fff244a83c321783`.
- Lake reports version `5.0.0-src+68218e8` under Lean `v4.31.0`.
- A clean local checkout of mathlib tag `v4.31.0` identifies exact commit
  `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f` and declares the matching
  `leanprover/lean4:v4.31.0` toolchain.
- The pinned mathlib source exposes probability-measure instances and Bochner
  integration, `EuclideanSpace`, real inner products and coordinate vectors,
  complex matrices, Kronecker products, traces, Hermitian predicates, and
  algebraic tensor products.
- Running `elan show` inside the managed sandbox aborted in Rust's
  `wait-timeout` signal handler with `Operation not permitted`; direct
  `lean --version`, `lake --version`, the installed toolchain directories, and
  the pinned toolchain file provide the required version evidence instead.

## Updated Assumptions

- Use `Measure Ω` with `[IsProbabilityMeasure μ]` for theorem parameters. This
  matches integration APIs directly and makes normalization an explicit typeclass
  assumption. A fixed `μ` in a model will represent measurement-setting
  independence; `ProbabilityMeasure Ω` remains available for packaged values.
- Represent response functions as real-valued functions with a separately named
  binary-range predicate. This makes the `±1` assumption visible and makes
  products/integrals direct. A custom two-constructor outcome type would make
  invalid values unrepresentable but would add coercion, measurability, and
  algebraic conversion overhead to every inequality.
- Use `EuclideanSpace ℝ (Fin 3)` for physical directions. It provides function
  coordinates, canonical single-coordinate unit vectors, norms, and a real
  inner product while preserving an explicit three-dimensional type.
- Use basis-indexed complex functions for kets and complex matrices for
  observables: one-qubit index `Fin 2`, two-qubit index `Fin 2 × Fin 2`.
  Matrix Kronecker products make subsystem order explicit and support direct
  finite calculations. Abstract `TensorProduct` exists but is not selected as
  the core representation because it adds quotient/basis transport without
  helping the coordinate calculation.
- Keep probability, geometry, and quantum imports in separate leaves. The
  public root may eventually re-export stable modules, but low-level hidden
  variable files must never import the quantum or Euclidean leaves indirectly.

## Big Picture Objective

Create the smallest reproducible Lean 4/mathlib package, compile-check every
planned dependency surface, and make provisional representation decisions from
actual pinned APIs without starting the Bell formalization itself.

## Detailed Implementation Plan

- Pin Lean `v4.31.0` and mathlib commit
  `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f` under `formal/`.
- Add a minimal `Bell` library root that exports no mathematical declaration.
- Add three non-exported diagnostic leaves for probability/a.e./integration,
  Euclidean geometry and square roots, and finite complex quantum matrices.
- Generate and retain `lake-manifest.json` so every transitive dependency is
  reproducibly fixed.
- Compile each diagnostic leaf and the default public root.
- Document rejected representations, dependency boundaries, exact setup and
  verification commands, and any API obstruction.
- Do not define local hidden-variable models, correlations, singlet states,
  Pauli matrices, or theorem statements in this stage.

Expected files:

- `formal/lean-toolchain`
- `formal/lakefile.toml`
- `formal/lake-manifest.json`
- `formal/Bell.lean`
- `formal/Bell/Audit/ProbabilityApi.lean`
- `formal/Bell/Audit/GeometryApi.lean`
- `formal/Bell/Audit/QuantumApi.lean`
- `.gitignore`
- `README.md`
- `goal-1/0-plan.md`
- `goal-1/2-BOOTSTRAP.md`

## No-Cheating Checks

- Confirm `Bell.lean` imports no diagnostic probe and exposes no claimed
  mathematical result.
- Confirm API probes are compile-only diagnostics, not public dependencies.
- Confirm probability imports do not depend on project quantum/geometry files.
- Confirm the mathlib revision is an exact commit, not a branch or floating tag.
- Scan all Lean sources for `sorry`, `admit`, project `axiom`, `unsafe`, and
  theorem declarations.
- Do not treat a successful root build as evidence that non-exported probes
  compile; build all three probes explicitly.
- Do not treat raw vectors or matrices as normalized states or observables.
- Do not add a finite hidden-variable theorem or any part of the substantive
  Bell proof during bootstrap.

## Completion Requirements

- [x] `lean --version` and `lake --version` report the pinned toolchain.
- [x] `lake-manifest.json` pins mathlib and all transitive packages.
- [x] Each probability, geometry, and quantum API probe compiles.
- [x] `lake build` succeeds for the minimal public library.
- [x] Representation and module-boundary decisions are documented with compiled
  evidence or an explicit replacement plan.
- [x] Public-root and dependency-boundary inspections pass.
- [x] Lean scans find no proof holes, project axioms, `unsafe`, or substantive
  theorem declarations.
- [x] `git diff --check` passes.
- [x] Exact commands and outcomes are recorded below and folded into
  `goal-1/0-plan.md`.

## Stage Results

Stage 2 completed on 2026-07-17 without beginning any substantive Bell
definition or proof.

### Reproducibility and dependency resolution

- `lean --version` reported Lean `4.31.0`, commit
  `68218e876d2a38b1985b8590fff244a83c321783`.
- `lake --version` reported Lake `5.0.0-src+68218e8` under Lean `4.31.0`.
- `formal/lean-toolchain` pins `leanprover/lean4:v4.31.0`.
- `formal/lakefile.toml` pins mathlib to exact commit
  `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`; the resolved checkout reports
  both that HEAD and exact tag `v4.31.0`.
- `lake update` initially failed because DNS was unavailable in the managed
  sandbox. The approved network-enabled retry succeeded. `lake exe cache get`
  then obtained 8,538 cached files.
- `lake-manifest.json` fixes mathlib plus `plausible`, `LeanSearchClient`,
  `importGraph`, `proofwidgets`, `aesop`, `Qq`, `batteries`, and `Cli` to exact
  revisions. Although inherited dependency inputs may name branches, every
  resolved `rev` in the retained manifest is a commit hash.

### Compile evidence

The first narrow probe build exposed three representation/API details rather
than a mathematical failure: inner-product notation needs its scoped support,
matrix Kronecker notation needs the appropriate scope, and an unrestricted
integral-valued example must be `noncomputable`. The probes were corrected to
use the pinned APIs and then compiled cleanly.

Final clean verification used:

```text
cd formal
lake clean
lake build Bell.Audit.ProbabilityApi Bell.Audit.GeometryApi Bell.Audit.QuantumApi
lake build
```

The explicit probe build succeeded after rebuilding 2,557 jobs from the clean
package graph. It exercised probability measures, a.e. conjunction and Bochner
integration; `EuclideanSpace ℝ (Fin 3)`, coordinate vectors, inner products,
norms and square roots; and complex matrices, pure-state expectations,
Hermitian predicates, traces, Kronecker products and algebraic tensor-product
availability. The independent public-root build then succeeded in 3 jobs and
reported `Built Bell`.

### Boundary and no-cheating audit

- `Bell.lean` has no imports and contains only an empty namespace, so no probe
  or claimed mathematical result enters the public surface.
- The probability probe imports only mathlib measure/integration modules; no
  project geometry or quantum module can enter the abstract layer through it.
- A scan of every project Lean source found no `sorry`, `admit`, declaration of
  `axiom`, `unsafe`, `theorem`, `lemma`, or `opaque`. The one diagnostic `def`
  computes a raw matrix expectation and is neither exported nor a claimed
  result.
- No headline theorem exists yet, so `#print axioms` is not applicable at this
  stage. Later stages must audit every headline result individually.
- `git diff --check` passed. Repository status was clean after the automatic
  workspace snapshots.

The `elan show` sandbox-specific crash recorded under Current Facts does not
affect the pin or build: both direct version commands, the exact toolchain file,
the resolved mathlib checkout, and the clean builds agree.
