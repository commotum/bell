# Bell 1964 Goal Execution Loop

Use this protocol for every future stage in `goal-1`. Scaffolding does not
authorize starting a stage; wait for explicit user instruction.

## Repeatable Loop

1. Sync current state with actual files and tests. Read `goal-1/0-plan.md`, the
   relevant paper pages, `BUILD-PLAN.md`, existing Lean modules, the last stage
   record, and the current Git diff/status.
2. Update `goal-1/0-plan.md` with current facts before starting the next stage.
   Confirm or revise mathematical assumptions, API expectations, paper-map
   entries, and correction-log items from checked evidence.
3. Select the first incomplete stage.
4. Create or refresh `goal-1/[INDEX]-[SHORTHAND].md` from the stage template
   below. Never overwrite unincorporated stage results.
5. Implement only that stage. Preserve the dependency split between abstract
   probability, quantum calculation, geometric violation, optional examples,
   and interpretation.
6. Add verification and no-cheating checks. In particular audit proof holes,
   axioms, setting dependence of the measure/responses, a.e. quantifier order,
   normalization, binary/bounded ranges, and any result merely assumed through
   a theorem hypothesis.
7. Run focused tests, the smallest builds covering all touched modules, any
   required adjacent/full build, `#print axioms` for headline theorems,
   goal-specific shortcut scans, and whitespace/diff checks.
8. Record exact commands, outputs, failures, unresolved questions, and evidence
   in the stage file. A green command without requirement coverage is not
   evidence of completion.
9. Fold results back into `goal-1/0-plan.md`: update current facts, design
   choices, paper/declaration map, correction log, stage status, and next work.
10. Continue toward the original objective. If stopping for the session, leave
    the goal resumable with current evidence, next experiments, unblock actions,
    and assumptions to challenge. Open issues remain explicit next work rather
    than disappearing from the objective.

## Invariants

- Do not narrow the user's objective without saying so.
- Do not mark a stage complete without evidence for every completion
  requirement.
- Do not use tests or green checks as evidence unless they cover the
  requirement.
- Prefer small, low-complexity stages that narrow uncertainty.
- Convert blockers into work items: decompose them, route around them, or turn
  them into proof and verification tasks.
- Preserve the distinction between implementation, verifier, diagnostic, and
  fallback paths.
- Treat Bell's paper as a mathematical source, not a formal specification.
- Keep locality, determinism, measurement-setting independence, normalization,
  perfect anticorrelation, and quantum reproduction logically separate.
- Keep pointwise, setting-wise almost-everywhere, expectation, and uniform
  statements distinct in both theorem names and prose.
- Do not infer a single common null set over uncountably many settings from
  setting-wise a.e. facts.
- A finite/discrete proof is an explanatory or implementation step, not a
  substitute for the planned general measure theorem.
- Quantum correlation must be calculated from defined quantum objects; it may
  not be installed as an axiom or disguised definition.
- Do not formalize physical interpretations as theorem conclusions unless their
  additional concepts and premises are independently defined.
- Do not add `sorry`, `admit`, unexplained axioms, unsafe proof shortcuts, or
  declarations that merely restate the target as a premise.
- Keep heavy matrix, tensor, sphere, and averaging dependencies out of the
  low-level hidden-variable API.

## Default Verification Checklist

Adapt commands to the pinned package layout established by Stage 2.

```text
lake build <touched.module.targets>
lake build
rg -n "sorry|admit|axiom|unsafe" <lean-source-roots> goal-1
rg -n "<stage-specific-forbidden-patterns>" <lean-source-roots>
git diff --check
git status --short
```

For each headline result, add a small audit module or command using
`#print axioms <declaration>` and record the output. Documentation mentions of
guardrail terms are expected and should be classified; unexplained Lean source
hits are not.

## Stage File Template

```markdown
# [INDEX]-[SHORTHAND]

## Current Facts

- Facts from current code, tests, docs, paper checks, and previous stage results.

## Updated Assumptions

- Assumptions that still look valid.
- Assumptions that changed.
- Assumptions that need tests before being trusted.

## Big Picture Objective

- Restate the stage objective, adjusted for current facts.

## Detailed Implementation Plan

- Concrete code/doc/test changes for this stage.
- Files expected to change.
- New tests or commands required.

## No-Cheating Checks

- Explicit checks proving the implementation does not route through forbidden
  fallback paths.
- Checks for hidden premise bundling, setting-indexed distributions, invalid
  a.e. quantifier changes, assumed quantum correlations, proof holes, and
  unexplained axioms as applicable.

## Completion Requirements

- Requirement-by-requirement checks.
- Required focused and full test/build commands.
- Required `#print axioms`, source scans, and diff checks.
- Documentation, paper-map, and correction-log updates required.

## Stage Results

- Fill in at the end of the stage.
- Include exact tests/builds run and outcomes.
- Include what was learned and what remains unresolved.
- Include what should change in `0-plan.md` before the next stage.
```

