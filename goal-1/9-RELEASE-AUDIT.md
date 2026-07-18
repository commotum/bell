# 9-RELEASE-AUDIT

## Current Facts

- At the start of Stage 9, Stages 1–8 were complete and the working tree
  contained only their final documentation fold-back. Those changes belonged
  to the active goal and were preserved.
- The package is pinned to Lean `v4.31.0` and mathlib commit
  `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`. At the Stage 9 baseline,
  `lake env lean --version` reports Lean 4.31.0, `lake --version` reports Lake
  5.0.0, and `cd formal && lake build Bell` succeeds with 2,555 jobs.
- `Bell.lean` re-exports the stable hidden-variable, original inequality,
  finite-matrix singlet, explicit violation, robustness, and modern CHSH
  surfaces. Audit leaves are not re-exported.
- The minimum mathematical core is implemented for an arbitrary probability
  measure: the abstract Bell inequality, the independently calculated singlet
  correlation, and the explicit unit-direction contradiction all compile.
- The quantitative layer proves a precise post-factorization uniform
  obstruction and Bell's `epsilon`/`delta` arithmetic. The literal angular-cap
  measure construction and Fubini derivation remain explicitly deferred; the
  release must not describe those missing premises as proved.
- At the Stage 9 baseline, `README.md` was stale: it said the concrete geometric
  contradiction was a later stage, documented only the Stage 3–5 surface, and
  omitted the robustness and CHSH modules and their audits.
- At the Stage 9 baseline, the planned release leaves `Bell.PaperMap` and
  `Bell.AxiomAudit` did not yet exist. Existing axiom checks were distributed
  across stage audit modules, so there was no single release command checking
  every headline result.
- At the Stage 9 baseline, the master plan contained the full
  equation/correction/deferment map only as development-process documentation;
  a concise compiled release map was still needed beside the Lean library.
- The repository has no CI workflow. At baseline, Stage 9 was planned to provide
  and actually exercise reproducible local commands; adding hosted CI was not
  required by the plan.
- At the Stage 9 baseline, `bell-1964/.DS_Store` was a tracked generated
  desktop-metadata file and no `.DS_Store` ignore rule existed. It needed to be
  removed from the release tree and ignored without touching the paper sources.
- The root Python/uv starter still contains placeholder metadata and a hello
  program unrelated to the Lean library. Earlier stages explicitly preserved
  it; the Stage 9 plan was to document that separation rather than delete or
  repurpose it without user authorization.

## Updated Assumptions

- Keep the current public theorem names and dependency layering unless the API
  audit finds a correctness or materially misleading documentation defect.
- Add `Bell.PaperMap` as a compiled documentation/check leaf over the public
  root. It should map equations (1)–(22), corrections, modern reformulations,
  precise deferments, and excluded physical interpretations without becoming a
  new mathematical premise or being re-exported by `Bell.lean`.
- Add `Bell.AxiomAudit` as a non-exported diagnostic leaf importing the public
  root and issuing `#check`/`#print axioms` commands for every headline theorem.
  It must not introduce wrapper theorems that could hide assumptions.
- Rewrite the root README as the stable user entry point: scope, assumptions,
  module map, minimal usage, exact result boundaries, reproducible commands,
  paper/correction links, axiom expectations, and known limitations.
- Preserve the distinction between correlation reproduction and full joint-law
  reproduction, and between a fixed hidden-variable measure and probability
  normalization. Do not use “local realism” as an assumption bundle.
- Treat a clean-checkout build as a tracked-source reproducibility check. Use a
  temporary detached worktree after the Stage 9 files are present in Git,
  leaving the user's working tree and branch untouched.
- The absence of a repository license is a release-policy question, not a Lean
  proof obligation. Do not choose legal terms on the user's behalf; record it
  as a repository-level limitation if still absent at completion.

## Big Picture Objective

Turn the checked development into a coherent release surface whose public API,
paper map, correction/deferment log, axiom audit, and build instructions agree
with the compiled library. Prove release readiness requirement by requirement,
including a clean-checkout build, without adding new mathematical scope or
blurring deferred parts of Bell's argument.

## Detailed Implementation Plan

- Audit every public module, theorem docstring, export, and existing audit leaf
  against the Stage 9 completion requirements.
- Add `formal/Bell/PaperMap.lean` as a compiled documentation/check leaf. Map:
  equations (1)–(3), optional examples (4)–(11), equations (12)–(15), the
  robustness chain (16)–(22), the explicit direction example, Sections V–VI,
  and CHSH as a modern theorem not present in the paper.
- Add `formal/Bell/AxiomAudit.lean` as a consolidated diagnostic leaf with
  theorem signatures and axiom output for the model/correlation range,
  extremal-correlation bridge, equation (14), original inequality, singlet
  calculation, explicit contradiction/no-model results, robustness results,
  and CHSH results.
- Rewrite `README.md` to expose the actual public modules, a minimal Lean usage
  example, exact assumptions/conclusions, pinned setup/build/audit commands,
  the paper map, and known limitations.
- Remove the tracked `.DS_Store` generated artifact and add a narrow ignore
  rule. Preserve the unrelated Python/uv starter files and identify them as
  outside the formal package.
- Make only narrow docstring or export corrections established by the API
  audit. Avoid proof refactors and unrelated cleanup.
- Run focused builds for both new leaves, the public root, every existing audit
  leaf, and the full default target.
- Check Markdown links and referenced repository paths, source/header hygiene,
  imports, proof holes, project axioms, forbidden physical/quantifier claims,
  generated artifacts, whitespace, and Git status.
- Validate a detached clean worktree from the final tracked tree, including
  toolchain/pin checks and `lake build`/release-audit builds.
- Fold exact results, remaining limitations, and completion evidence into
  `goal-1/0-plan.md`.

Expected files:

```text
README.md
.gitignore
bell-1964/.DS_Store                 # remove tracked generated artifact
formal/Bell/PaperMap.lean
formal/Bell/AxiomAudit.lean
goal-1/9-RELEASE-AUDIT.md
goal-1/0-plan.md
```

## Build Structure

- `Bell.PaperMap` is a compiled documentation leaf over `Bell`; it validates
  referenced declaration names while adding no public theorem or instance.
- `Bell.AxiomAudit` is a diagnostic leaf over `Bell`; it centralizes release
  signatures and axiom reports and is not imported by the public root.
- `Bell.lean` should remain a thin public umbrella. It will not import either
  release-check leaf unless a checked consumer need emerges.
- Existing mathematical leaves are high-fanout or already audited and should
  not be edited absent a concrete release defect.

Focused and adjacent build sequence:

```text
cd formal
lake build Bell.PaperMap
lake build Bell.AxiomAudit
lake build Bell
lake build Bell.Audit.ProbabilityApi Bell.Audit.GeometryApi Bell.Audit.QuantumApi
lake build Bell.Audit.LocalModel Bell.Audit.OriginalInequality Bell.Audit.Singlet
lake build Bell.Audit.Violation Bell.Audit.Robust Bell.Audit.CHSH
lake build
```

## Boundary Checks

- Inspect the public root: it must export stable mathematics but no audit leaf.
- Inspect `Bell.PaperMap`: paper claims must be represented by existing checked
  declarations or explicitly classified as corrected, partial, deferred, or
  interpretation-only. Documentation text alone must not upgrade a result.
- Inspect `Bell.AxiomAudit`: it may only reference declarations; it must not
  prove release wrappers from assumptions that restate their targets.
- Confirm the abstract probability/inequality modules still import no quantum
  or geometry layer.
- Confirm the quantum calculation imports no hidden-variable inequality and
  defines the target through matrices rather than `-inner`.
- Confirm no setting-indexed hidden-variable measure or common a.e. null set has
  entered the public API.
- Confirm the robust README/paper-map language distinguishes the compiled
  post-factorization theorem from the deferred angular-smearing construction.
- Confirm no theorem or documentation advertises signaling, superluminal
  influence, or Lorentz failure as a proved mathematical conclusion.
- Scan all Lean source for proof holes, declaration axioms, `unsafe`, `opaque`,
  and `native_decide`; classify documentation-only guardrail hits separately.

## Completion Requirements

- [x] The public root, README, module map, and theorem names agree.
- [x] A compiled `Bell.PaperMap` covers every equation (1)–(22), Sections V–VI,
  corrections, partial results, precise deferments, and the modern CHSH leaf.
- [x] A compiled non-exported `Bell.AxiomAudit` checks every headline theorem;
  all outputs contain only understood Lean/mathlib foundations.
- [x] The README provides a compiling minimal usage example and exact pinned
  build/audit commands without suggesting that `lake update` is required.
- [x] The minimum core and the precise robustness result are described at their
  actual pointwise/a.e./expectation/uniform scopes.
- [x] Every remaining optional or unresolved item has an exact obligation and
  none is presented as proved.
- [x] Focused public/release/audit builds and the full default build succeed.
- [x] A detached clean-checkout build succeeds from the final tracked tree.
- [x] Link/path, import-boundary, assumption, quantifier, target-shortcut,
  physical-claim, generated-artifact, proof-hole, axiom, and whitespace scans
  pass with every nonempty result classified.
- [x] The final Git diff/status is reviewed, existing user changes are
  preserved, and `goal-1/0-plan.md` records exact evidence and goal completion.
- [x] Any repository-level release limitation not selected by the user, such as
  licensing policy, is stated without silently inventing a choice.

## Stage Results

Stage 9 completed on 2026-07-17.

### Release surface delivered

- Added `formal/Bell/PaperMap.lean`, a compiled documentation leaf importing
  `Bell`. It gives a separate status-tagged section for every equation
  (1)–(22), covers the unnumbered claims and Sections V–VI, distinguishes CHSH
  as modern, and records 28 material corrections or scope qualifications. Its
  declaration checks and the README usage example compile, but the leaf defines
  no theorem, instance, or premise and is not re-exported by `Bell.lean`.
- Added `formal/Bell/AxiomAudit.lean`, a non-exported diagnostic leaf with 41
  `#print axioms` commands spanning the local-model, original-inequality,
  quantum, exact-violation, robustness, and CHSH headline results. It defines no
  wrapper theorem.
- Rewrote `README.md` as the public entry point, including the separated model
  assumptions, current module map, headline declarations, compiled minimal
  example, exact pins and commands, scope/deferment notes, and repository-level
  limitations.
- Added a repository-wide `.DS_Store` ignore rule and removed
  `bell-1964/.DS_Store` from tracked files. The paper Markdown/PDF and the
  unrelated root Python/uv starter were preserved.
- Made only the narrow public documentation corrections established by the API
  audit: the unit-observable and singlet-normalization facts, direction norms,
  global-versus-finite no-model scope, four-error coefficient provenance,
  post-(22) direction provenance, and CHSH norm/violation facts are now stated
  where consumers encounter them. No proof statement or dependency layer was
  changed.

### Mathematical and boundary audit

- The public model still stores exactly one `Measure Ω`; normalization remains
  a separate `IsProbabilityMeasure` instance, binary/bounded range and
  measurability remain explicit, and setting-wise a.e. predicates retain the
  quantifier order `∀ setting, ∀ᵐ ω`.
- `singletCorrelation` remains the real part of an independently defined matrix
  expectation. The formula `-inner ℝ a b` occurs as the proved theorem
  `singlet_spin_correlation`, not as the target definition or an axiom.
- The abstract hidden-variable, approximation, and inequality directories
  import no quantum or geometry module. The quantum directory imports no
  hidden-variable, inequality, geometry, approximation, or umbrella module.
- The approximation statement is exactly the compiled uniform
  post-factorization obstruction on `unitDirectionSet`. The equation-(19)
  angular-cap construction, its center-indexed measures, joint measurability,
  product integrability, independence, atomlessness/absolute-continuity
  conditions, and Fubini step remain explicitly deferred.
- Global no-model results are documented as stronger ambient-`Direction`
  convenience corollaries; the finite results at proved unit vectors are the
  physically scoped contradictions. Correlation reproduction is not described
  as full joint-law reproduction, and no signaling or spacetime conclusion is
  advertised as a theorem.

### Build and reproducibility evidence

- The working-tree focused builds `lake build Bell.PaperMap` and
  `lake build Bell.AxiomAudit` each succeeded. The initial axiom-audit build
  reported only three line-length linter warnings; splitting those diagnostic
  commands removed every warning on the repeated build.
- `lake build Bell.PaperMap Bell.AxiomAudit Bell` succeeded with 2,557 jobs;
  the combined nine-leaf audit command succeeded with 2,573 jobs; and the
  default `lake build` succeeded with 2,555 jobs.
- A temporary detached worktree was populated strictly from tracked `HEAD`.
  `lake exe cache get` resolved the committed manifest, Lean reported 4.31.0,
  Lake reported 5.0.0, and the checked-out mathlib revision was exactly
  `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`. The same 2,557-job release
  build, 2,573-job audit build, and 2,555-job default build all succeeded there.
  Its tracked status and `git diff --check` output were empty; only the ignored
  `formal/.lake/` cache appeared under `git status --ignored`.
- The sandbox initially prevented Git from writing temporary worktree metadata,
  and the first dependency fetch could not resolve GitHub without network
  access. The authorized retries performed only the planned temporary-worktree
  operation and pinned dependency/cache fetch; neither failure reflected a
  source, manifest, or proof defect.

### Scan and axiom evidence

- Lean source scans found no `sorry`, `admit`, declaration `axiom`, `unsafe`,
  `opaque`, or `native_decide`; no diagnostic leaf is publicly imported; no
  target-definition shortcut, setting-indexed hidden measure, invalid common
  a.e. quantifier pattern, or forbidden cross-layer import was found.
- `Bell.PaperMap` has exactly 22 numbered equation headings and 28 correction
  entries. `Bell.AxiomAudit` has 41 axiom commands. Every axiom result was
  exactly `[propext, Classical.choice, Quot.sound]`, with no custom project
  axiom.
- Markdown links and their repository targets exist. Proof-scope, physical,
  full-statistics, and angular-smearing text searches returned only the
  intentional negative guardrails or deferment explanations quoted above.
  Generated-artifact and ambiguous “exact/optimal/sharp coefficient” scans were
  empty, and `git diff --check` passed.
- The repository still has no license file. README records this as an owner
  decision rather than inventing reuse terms. No hosted CI workflow was added;
  the exercised local clean-checkout commands are the release reproducibility
  procedure required by this stage.

### Exact final command ledger

The focused, adjacent, and full builds were run exactly as follows from
`formal/`; every command exited zero:

```text
lake env lean --version
lake --version
lake build Bell.PaperMap
lake build Bell.AxiomAudit
lake build Bell.PaperMap Bell.AxiomAudit Bell
lake build Bell.Audit.ProbabilityApi Bell.Audit.GeometryApi Bell.Audit.QuantumApi Bell.Audit.LocalModel Bell.Audit.OriginalInequality Bell.Audit.Singlet Bell.Audit.Violation Bell.Audit.Robust Bell.Audit.CHSH
lake build
```

The final source/boundary scans were run from the repository root:

```text
rg -n --glob '*.lean' '\bsorry\b|\badmit\b|^[[:space:]]*axiom\b|\bunsafe\b|\bopaque\b|\bnative_decide\b' formal/Bell formal/Bell.lean
rg -n '^public import Bell\.(Audit|PaperMap|AxiomAudit)' formal/Bell.lean
rg -n '^(public )?import Bell\.(Quantum|Geometry)|^(public )?import Bell$' formal/Bell/HiddenVariable formal/Bell/Inequality formal/Bell/Approximation
rg -n '^(public )?import Bell\.(HiddenVariable|Inequality|Geometry|Approximation)|^(public )?import Bell$' formal/Bell/Quantum
rg -n '^(noncomputable )?def singletCorrelation.*inner|singletCorrelation.*:=.*inner|^[[:space:]]*axiom.*singlet' formal/Bell/Quantum formal/Bell/Geometry formal/Bell/Inequality formal/Bell/HiddenVariable
rg -n 'hiddenMeasure[[:space:]]*:[^\n]*(Setting|→)|hiddenMeasure[[:space:]]*:=[^\n]*(fun|λ)[^\n]*(setting|a|b)' formal/Bell
rg -n '∀ᵐ[^\n]*∀|iInter|ae_all_iff|Eventually\.all' formal/Bell --glob '!**/Audit/**'
rg -n 'exact coefficient|optimal coefficient|sharp coefficient' formal/Bell README.md goal-1/0-plan.md goal-1/8-EXAMPLES.md
git ls-files | rg '(^|/)(\.DS_Store|__pycache__|\.lake|\.venv)(/|$)|\.(olean|ilean|o)$'
```

Every command in that block exited one with no matches, the expected success
condition for these negative scans. Positive controls found exactly
`hiddenMeasure : Measure Ω`, the documented `∀ setting, ∀ᵐ` order, 22 paper
equation headings, 28 correction entries, and 41 `#print axioms` commands:

```text
rg -n 'hiddenMeasure : Measure Ω' formal/Bell/HiddenVariable/Basic.lean
rg -n '∀ setting, ∀ᵐ' formal/Bell/HiddenVariable
rg -c '^### Equation \([0-9]+\)' formal/Bell/PaperMap.lean
rg -c '^[0-9]+\.' formal/Bell/PaperMap.lean
rg -c '^#print axioms' formal/Bell/AxiomAudit.lean
```

The required goal-folder proof-escape scan was also run:

```text
rg -n '\bsorry\b|\badmit\b|^[[:space:]]*axiom\b|\bunsafe\b|\bopaque\b|\bnative_decide\b' goal-1
```

It exited zero only on planning templates, explicit no-cheating guardrails,
prior scan reports, the Stage 9 command ledger itself, and ordinary prose such
as “admit averages” or “opaque uniform predicate.” None is a Lean declaration
or proof escape; the Lean-source-only scan above was empty.

The following documentation searches exited zero only on explicit negative
guardrails or deferment prose; each hit was inspected and retained:

```text
rg -n -i 'signaling|superluminal|Lorentz' README.md formal/Bell goal-1/0-plan.md goal-1/9-RELEASE-AUDIT.md
rg -n -i 'full (quantum )?statistics|all quantum statistics|joint (probability )?law' README.md formal/Bell goal-1/0-plan.md goal-1/9-RELEASE-AUDIT.md
rg -n -i 'angular|smear|Fubini|Tonelli|post-factorization' README.md formal/Bell/PaperMap.lean formal/Bell/Geometry/RobustViolation.lean goal-1/0-plan.md goal-1/9-RELEASE-AUDIT.md
```

Markdown links were enumerated with the first command below. Its six link
occurrences resolve to the five repository files checked with `test -e`; all
exited zero. The generated-file query had no tracked match, and both final Git
checks passed:

```text
rg -n '\[[^]]+\]\([^)]+\)' --glob '*.md' .
test -e formal/Bell/PaperMap.lean
test -e bell-1964/bell-1964.md
test -e bell-1964/bell-1964.pdf
test -e goal-1/0-plan.md
test -e goal-1/9-RELEASE-AUDIT.md
git ls-files --error-unmatch README.md formal/Bell/PaperMap.lean formal/Bell/AxiomAudit.lean goal-1/9-RELEASE-AUDIT.md
git check-ignore -v bell-1964/.DS_Store
git diff --check
git status --short --branch
```

The final main-worktree status output was only
`## master...origin/master`, with no changed or untracked path. Ignored local
development state consisted of `.venv/`, `bell-1964/.DS_Store`, and
`formal/.lake/`; none is tracked. The tracked-file check printed all four
release artifacts, and the ignore check identified `.gitignore`'s `.DS_Store`
rule.

Finally, the tracked-source gate used this detached-worktree sequence:

```text
git worktree add --detach /tmp/bell-release-audit-final HEAD
cd /tmp/bell-release-audit-final/formal
lake env lean --version
lake --version
lake exe cache get
git diff --exit-code -- lake-manifest.json lakefile.toml lean-toolchain
git -C .lake/packages/mathlib rev-parse HEAD
lake build Bell.PaperMap Bell.AxiomAudit Bell
lake build Bell.Audit.ProbabilityApi Bell.Audit.GeometryApi Bell.Audit.QuantumApi Bell.Audit.LocalModel Bell.Audit.OriginalInequality Bell.Audit.Singlet Bell.Audit.Violation Bell.Audit.Robust Bell.Audit.CHSH
lake build
git -C /tmp/bell-release-audit-final diff --check
git -C /tmp/bell-release-audit-final status --short
git worktree remove /tmp/bell-release-audit-final
```

The manifest diff and both final worktree checks were empty. The dependency
revision command printed the exact committed mathlib pin. Under
`git status --ignored`, the detached tree contained only its expected
`formal/.lake/` cache.

All Stage 9 requirements are covered. The verified results and exact remaining
optional work have been folded back into `goal-1/0-plan.md`; there is no next
required implementation stage.
