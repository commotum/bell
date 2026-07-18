# 9-RELEASE-AUDIT

## Current Facts

- Stages 1–8 are complete. The current working tree contains only the final
  Stage 8 documentation fold-back in `goal-1/0-plan.md` and
  `goal-1/8-EXAMPLES.md`; those changes belong to the active goal and must be
  preserved.
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
- `README.md` is stale: it says the concrete geometric contradiction is a later
  stage, documents only the Stage 3–5 surface, and omits the robustness and CHSH
  modules and their audits.
- The planned release leaves `Bell.PaperMap` and `Bell.AxiomAudit` do not yet
  exist. Existing axiom checks are distributed across stage audit modules, so
  there is no single release command checking every headline result.
- The master plan contains the full equation/correction/deferment map, but it is
  development-process documentation. A concise compiled release map is still
  needed beside the Lean library.
- The repository has no CI workflow. Stage 9 will provide and actually exercise
  reproducible local commands; adding hosted CI is not required by the current
  plan.

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

- [ ] The public root, README, module map, and theorem names agree.
- [ ] A compiled `Bell.PaperMap` covers every equation (1)–(22), Sections V–VI,
  corrections, partial results, precise deferments, and the modern CHSH leaf.
- [ ] A compiled non-exported `Bell.AxiomAudit` checks every headline theorem;
  all outputs contain only understood Lean/mathlib foundations.
- [ ] The README provides a compiling minimal usage example and exact pinned
  build/audit commands without suggesting that `lake update` is required.
- [ ] The minimum core and the precise robustness result are described at their
  actual pointwise/a.e./expectation/uniform scopes.
- [ ] Every remaining optional or unresolved item has an exact obligation and
  none is presented as proved.
- [ ] Focused public/release/audit builds and the full default build succeed.
- [ ] A detached clean-checkout build succeeds from the final tracked tree.
- [ ] Link/path, import-boundary, assumption, quantifier, target-shortcut,
  physical-claim, generated-artifact, proof-hole, axiom, and whitespace scans
  pass with every nonempty result classified.
- [ ] The final Git diff/status is reviewed, existing user changes are
  preserved, and `goal-1/0-plan.md` records exact evidence and goal completion.
- [ ] Any repository-level release limitation not selected by the user, such as
  licensing policy, is stated without silently inventing a choice.

## Stage Results

Stage 9 is in progress. Results will be filled after implementation and the
requirement-by-requirement release audit.
