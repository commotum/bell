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

- [ ] `lean --version` and `lake --version` report the pinned toolchain.
- [ ] `lake-manifest.json` pins mathlib and all transitive packages.
- [ ] Each probability, geometry, and quantum API probe compiles.
- [ ] `lake build` succeeds for the minimal public library.
- [ ] Representation and module-boundary decisions are documented with compiled
  evidence or an explicit replacement plan.
- [ ] Public-root and dependency-boundary inspections pass.
- [ ] Lean scans find no proof holes, project axioms, `unsafe`, or substantive
  theorem declarations.
- [ ] `git diff --check` passes.
- [ ] Exact commands and outcomes are recorded below and folded into
  `goal-1/0-plan.md`.

## Stage Results

- In progress.
