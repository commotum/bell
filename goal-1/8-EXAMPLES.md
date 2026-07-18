# 8-EXAMPLES

## Current Facts

- Stages 1–7 are complete. The Stage 7 bounded-response and uniform-robustness
  leaves are public, and its final record remains an existing workspace change
  that this stage will preserve.
- The Stage 8 baseline command `cd formal && lake build Bell` succeeds with
  2,553 graph jobs.
- `Bell.Audit.LocalModel` already contains a genuine normalized two-point
  binary model and exact correlations. Promoting that diagnostic unchanged
  would add no new reusable surface.
- Bell's equations (4)–(10) require normalized hemisphere/sphere measures,
  total sign conventions, null great-circle boundaries, angle geometry, and
  explicit symmetric-difference measure calculations. Equation (6)'s printed
  “rotation towards” prescription is not globally valid for obtuse angles, as
  recorded in the correction log.
- Equation (11) is not determined by the phrase “isotropic mixture of product
  states” alone. Its coefficient `-1/3` requires a specified ensemble, for
  example the uniform mixture of oppositely polarized states, and a derived
  sphere second-moment calculation.
- The paper's final Section III construction deliberately violates local
  response arity and repeats the equation-(6) prescribed-angle issue. It is an
  optional countermodel, not a premise or consumer of the verified core.
- A full stochastic-local reduction would require probability kernels,
  conditional means, joint measurability, and product/Fubini arguments. The
  existing bounded-response theorem already covers the resulting effective
  response functions once those facts are supplied, so a superficial renamed
  structure would not constitute the reduction.
- Section V's higher-dimensional extension requires explicit subspace
  embeddings and state support. Extending spin operators by zero produces a
  zero eigenvalue off the selected subspace, so it does not preserve a global
  binary-outcome interpretation without a support-restricted theorem.
- A modern CHSH theorem has a direct public consumer and needs none of that
  measure geometry. For real scalars bounded by one,
  `|x*(y+y')+x'*(y-y')| <= 2`; integrating gives
  `|P(a,b)+P(a,b')+P(a',b)-P(a',b')| <= 2` for one fixed normalized hidden
  measure and four setting-specific a.e. measurability/boundedness hypotheses.
  A scratch Lean prototype of the scalar and general-measure statements
  compiles with only `[propext, Classical.choice, Quot.sound]`.
- With `a=bellA`, `a'=bellC`, `b=bellB`, and
  `b'=bellScale • (bellA-bellC)`, the calculated singlet values are expected to
  be `-bellScale`, `-bellScale`, `-bellScale`, and `bellScale`. The CHSH
  combination is therefore `-4*bellScale`, with absolute value `2*sqrt(2)>2`.
  These geometry and matrix-derived claims remain planning facts until the
  Stage 8 integration leaf compiles.
- Four target-correlation errors of radius `eta` should transfer the CHSH bound
  to `|CHSH(target)| <= 2+4*eta`. At the preceding directions this gives the
  modern finite-setting lower bound `(sqrt(2)-1)/2 <= eta`.

## Updated Assumptions

- Select the CHSH generalization because it materially reuses and strengthens
  the abstract bounded-response API while retaining a small dependency cone.
  Label it explicitly as a modern theorem, not as Bell's equation (15) or any
  numbered statement in the 1964 paper.
- Use `DeterministicLocalModel` only as the fixed-measure factorized-response
  interface. The CHSH result will assume real effective responses bounded by
  one a.e.; it will not assert that those effective responses are raw binary
  deterministic outcomes.
- Keep normalization, each fixed response's a.e. measurability, each fixed
  response's a.e. bound, and target reproduction/error assumptions separate.
  Local dependence remains in the two response arities, and measurement-setting
  independence remains in the one stored measure.
- Derive the scalar CHSH inequality first, then its general-measure integral
  theorem, then the target four-error transfer. Quantum objects and geometry
  must not enter the abstract leaf.
- Define one new explicit unit direction in a geometry integration leaf. Derive
  every singlet value through the existing finite-matrix theorem and explicit
  inner products before proving the violation, lower bound, and no-model
  corollary.
- Defer the paper's equations (4)–(11), nonlocal illustration, stochastic-kernel
  reduction, and higher-dimensional embedding with the exact obligations above.
  Their omission does not narrow the completed minimum or robustness cores.

## Big Picture Objective

Add a reusable bounded-response CHSH inequality, its four-error target form,
and a fully calculated four-direction singlet violation as a clearly labeled
modern generalization. Audit a sharp finite model and preserve a precise list
of paper illustrations that remain deferred rather than introducing expensive
or misleading partial formalizations.

## Detailed Implementation Plan

- Add `Bell.Inequality.CHSH` as an abstract public leaf with:
  - a generic `chshCombination` definition;
  - `bounded_response_chsh_pointwise`;
  - `bounded_response_chsh`, using four fixed a.e. measurable/bounded response
    functions and one probability measure; and
  - `target_chsh_of_four_errors`, with the exact coefficient `4*eta`.
- Add `Bell.Geometry.CHSHViolation` as the public integration leaf with:
  - the fourth direction `chshBobPrime` and its unit norm/inner products;
  - four singlet-correlation values derived through
    `singlet_spin_correlation`;
  - the exact CHSH value, strict violation, and negated CHSH bound;
  - the finite four-error lower bound `(sqrt(2)-1)/2 <= eta`; and
  - finite/global no-bounded-local-model corollaries whose assumptions remain
    explicit.
- Add non-exported `Bell.Audit.CHSH` checking the public root, a sharp
  normalized one-point binary model, binary-to-bounded specialization,
  directions/values, theorem signatures, and `#print axioms` results.
- Re-export only the two stable public leaves from `Bell.lean` after their
  focused builds pass. Keep the audit leaf diagnostic.
- Fold exact declaration names, the modern-generalization label, source
  deferments, build/scan evidence, and the next Stage 9 work back into
  `goal-1/0-plan.md`.

Expected files:

```text
formal/Bell/Inequality/CHSH.lean
formal/Bell/Geometry/CHSHViolation.lean
formal/Bell/Audit/CHSH.lean
formal/Bell.lean
goal-1/8-EXAMPLES.md
goal-1/0-plan.md
```

## Build Structure

- `Bell.Inequality.CHSH` is the low-dependency public theorem leaf. It imports
  only the bounded-response and correlation layers plus local proof tactics.
- `Bell.Geometry.CHSHViolation` is the first leaf joining CHSH to explicit
  Euclidean directions and the independently calculated singlet correlation.
  It imports narrow geometry, reproduction, CHSH, and singlet leaves rather
  than the public umbrella.
- `Bell.Audit.CHSH` is diagnostic and imports the public root to verify exports.
  Its finite saturation example and axiom probes are not public API.
- Existing high-fanout hidden-variable, quantum, original-inequality, and
  robustness proof leaves will not be edited. `Bell.lean` is changed only after
  focused leaf builds pass.

Intended build sequence:

```text
cd formal
lake build Bell.Inequality.CHSH
lake build Bell.Geometry.CHSHViolation
lake build Bell.Audit.CHSH Bell
lake build
```

## Boundary Checks

- Inspect `bounded_response_chsh_pointwise`: it must prove the scalar bound
  from four absolute-value hypotheses rather than assume a CHSH inequality.
- Confirm `Bell.Inequality.CHSH` has no quantum, geometry, singlet,
  perfect-anticorrelation, reproduction, or binary premise/import.
- Combine only the four fixed a.e. bounds needed by the integral theorem. Do
  not form `almost everywhere omega, forall setting`.
- Inspect `target_chsh_of_four_errors`: its premises must be four correlation
  errors, not the desired target CHSH conclusion or a disguised robust bound.
- Derive the new direction's unit norm and all four singlet values through the
  coordinate geometry and `singlet_spin_correlation`. Do not define the target
  as `-inner` or assume `2*sqrt(2)`.
- State the exact no-model result only for correlation reproduction and bounded
  effective responses. Do not call it reproduction of all quantum statistics
  or a theorem about signaling, spacetime, or Lorentz invariance.
- Keep CHSH labeled modern. Do not map it to equations (4)–(11) or imply those
  deferred paper examples were proved.
- Scan for proof holes, unexplained axioms, target-as-premise shortcuts,
  quantum imports in the abstract leaf, common-null-set changes,
  setting-indexed hidden measures, and physical-interpretation claims.

## Completion Requirements

- [ ] A public scalar theorem proves the bounded CHSH inequality directly.
- [ ] A public arbitrary-probability-measure CHSH theorem has normalization and
  all four fixed response measurability/boundedness assumptions explicit.
- [ ] A public target-agnostic theorem transfers exactly four correlation errors
  to `|CHSH(target)| <= 2+4*eta`.
- [ ] Lean proves the fourth direction unit, computes all four singlet values
  from the matrix-derived correlation, and proves an exact strict CHSH
  violation.
- [ ] A compiled theorem proves `(sqrt(2)-1)/2 <= eta` from four fixed singlet
  correlation error bounds.
- [ ] Finite and global no-model corollaries preserve normalization,
  measurability, boundedness, fixed-measure locality, and correlation
  reproduction as distinct assumptions.
- [ ] A non-exported audit checks a sharp finite model, public exports,
  signatures, numerical boundaries, and all headline theorem axioms.
- [ ] Every deferred equation-(4)–(11), nonlocal, stochastic, and
  higher-dimensional illustration has an exact reason; none is reported as
  formalized.
- [ ] Focused leaf, adjacent public/audit, and full builds succeed.
- [ ] Proof-hole, axiom, import-boundary, binary/perfect-anticorrelation,
  target-shortcut, quantifier, fixed-measure, paper-claim, physical-claim, and
  whitespace scans pass with documentation-only/audit-only hits classified.
- [ ] Exact failures, corrections, declarations, builds, scans, axiom outputs,
  and remaining uncertainty are recorded here and folded into `0-plan.md`.

## Stage Results

- In progress. Fill only from checked Stage 8 evidence.
