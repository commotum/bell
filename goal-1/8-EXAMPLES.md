# 8-EXAMPLES

## Current Facts

- Stages 1–8 are complete. The Stage 7 bounded-response and uniform-robustness
  leaves and the Stage 8 CHSH leaves are public; their diagnostic audit leaves
  remain non-exported.
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
  example the literal uniform mixture of oppositely polarized directions,
  which needs a derived sphere second-moment calculation. A finite six-axis
  antiparallel ensemble can realize the same correlation, but that alone does
  not establish full rotational invariance of the mixed state.
- The paper's final Section III construction deliberately violates local
  response arity and repeats the equation-(6) prescribed-angle issue. It is an
  optional countermodel, not a premise or consumer of the verified core.
- A full stochastic-local reduction requires local conditional laws (as
  kernels or explicit Bernoulli parameters), conditional factorization,
  conditional means, joint measurability, and the product/Fubini or equivalent
  finite-law argument. The
  existing bounded-response theorem already covers the resulting effective
  response functions once those facts are supplied, so a superficial renamed
  structure would not constitute the reduction.
- Section V's higher-dimensional extension requires explicit subspace
  embeddings and state support. Extending spin operators by zero produces a
  zero eigenvalue off the selected subspace, so it does not preserve a global
  binary-outcome interpretation without a support-restricted theorem.
- The modern CHSH theorem has a direct public consumer and needs none of that
  measure geometry. For real scalars bounded by one,
  `|x*(y+y')+x'*(y-y')| <= 2`; integrating gives
  `|P(a,b)+P(a,b')+P(a',b)-P(a',b')| <= 2` for one fixed normalized hidden
  measure and four setting-specific a.e. measurability/boundedness hypotheses.
  The scalar and general-measure statements now compile with only
  `[propext, Classical.choice, Quot.sound]`.
- With `a=bellA`, `a'=bellC`, `b=bellB`, and
  `b'=bellScale • (bellA-bellC)`, the calculated singlet values are
  `-bellScale`, `-bellScale`, `-bellScale`, and `bellScale`. The CHSH
  combination is therefore `-4*bellScale`, with absolute value `2*sqrt(2)>2`.
  These geometry and matrix-derived claims compile in the Stage 8 integration
  leaf.
- Four target-correlation errors of radius `eta` transfer the CHSH bound
  to `|CHSH(target)| <= 2+4*eta`. At the preceding directions this gives the
  modern finite-setting lower bound `(sqrt(2)-1)/2 <= eta`.

## Updated Assumptions

- Select the CHSH generalization because it materially reuses and strengthens
  the abstract bounded-response API while retaining a small dependency cone.
  Label it explicitly as a modern theorem, not as Bell's equation (15) or any
  numbered statement in the 1964 paper.
- Use `DeterministicLocalModel` only as the fixed-measure factorized-response
  interface. The CHSH result assumes real effective responses bounded by one
  a.e.; it does not assert that those effective responses are raw binary
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
  - `target_chsh_of_four_errors`, with coefficient `4*eta` from the four error
    terms.
- Add `Bell.Geometry.CHSHViolation` as the public integration leaf with:
  - the fourth direction `chshBobMinus` and its unit norm/inner products;
  - four singlet-correlation values derived through
    `singlet_spin_correlation`;
  - the exact CHSH value, strict violation, and negated CHSH bound;
  - the finite four-error lower bound `(sqrt(2)-1)/2 <= eta`; and
  - finite/global no-bounded-local-model corollaries whose assumptions remain
    explicit.
- Add non-exported `Bell.Audit.CHSH` checking the public root, a sharp
  normalized one-point bounded/nonbinary model, a representative Alice
  binary-to-bounded bridge, directions/values, theorem signatures, and
  `#print axioms` results.
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

- [x] A public scalar theorem proves the bounded CHSH inequality directly.
- [x] A public arbitrary-probability-measure CHSH theorem has normalization and
  all four fixed response measurability/boundedness assumptions explicit.
- [x] A public target-agnostic theorem transfers exactly four correlation errors
  to `|CHSH(target)| <= 2+4*eta`.
- [x] Lean proves the fourth direction unit, computes all four singlet values
  from the matrix-derived correlation, and proves an exact strict CHSH
  violation.
- [x] A compiled theorem proves `(sqrt(2)-1)/2 <= eta` from four fixed singlet
  correlation error bounds.
- [x] Finite and global no-model corollaries preserve local response arities,
  one fixed setting-independent measure, normalization, measurability,
  boundedness, and correlation reproduction as distinct assumptions.
- [x] A non-exported audit checks a sharp finite model, public exports,
  signatures, numerical boundaries, and all headline theorem axioms.
- [x] Every deferred equation-(4)–(11), nonlocal, stochastic, and
  higher-dimensional illustration has an exact reason; none is reported as
  formalized.
- [x] Focused leaf, adjacent public/audit, and full builds succeed.
- [x] Proof-hole, axiom, import-boundary, binary/perfect-anticorrelation,
  target-shortcut, quantifier, fixed-measure, paper-claim, physical-claim, and
  whitespace scans pass with documentation-only/audit-only hits classified.
- [x] Exact failures, corrections, declarations, builds, scans, axiom outputs,
  and remaining uncertainty are recorded here and folded into `0-plan.md`.

## Stage Results

Stage 8 completed on 2026-07-17.

### Implemented public and diagnostic surface

- `Bell.Inequality.CHSH` is the low-dependency public theorem leaf. It adds:
  - `chshCombination`, a target-agnostic signed four-correlation sum;
  - `bounded_response_chsh_pointwise`, the scalar theorem
    `|A0*B0+A0*B1+A1*B0-A1*B1| <= 2` from four `abs <= 1` assumptions;
  - `bounded_response_chsh`, the arbitrary-probability-measure theorem with
    four fixed a.e. measurability and four fixed a.e. boundedness assumptions;
    and
  - `target_chsh_of_four_errors`, which proves the exact target bound
    `|CHSH(target)| <= 2+4*epsilon` from four correlation errors.
- `Bell.Geometry.CHSHViolation` is the public integration leaf. It adds
  `chshBobMinus=bellScale • (bellA-bellC)`, its exact inner products, self inner
  product, and unit norm. It derives the new and reused singlet values through
  `singlet_spin_correlation`, proves the signed combination `-4*bellScale`,
  proves its absolute value is `2*sqrt(2)>2`, and exposes
  `singlet_violates_chsh`.
- `singlet_chsh_error_lower_bound_at_directions` proves the modern finite
  four-error obstruction `(sqrt(2)-1)/2 <= eta`.
- `singletCorrelations_incompatible_with_boundedLocalModel_at_chshDirections`
  is the finite assumption-separated bridge.
  `no_boundedLocalModel_reproduces_singletCorrelation_via_chsh` is its global
  setting-wise corollary. The finite theorem uses exactly four proved unit
  direction pairs and is the finite physical statement used by the
  contradiction. The global
  theorem assumes reproduction for every pair of ambient `Direction` values
  and is a stronger convenience corollary. Both concern correlation
  reproduction only.
- `Bell.Audit.CHSH` is diagnostic and is not re-exported. Its normalized Dirac
  one-point model makes Alice's responses `1`, Bob's first response `1`, and
  Bob's second response `0`. It proves that the Bob response is nonbinary and
  that the CHSH combination is exactly `2`, so both sharpness and the genuine
  bounded-response generality are exercised. The audit also checks a
  representative Alice binary-to-bounded bridge, direction norm, exact quantum
  value, positivity, signatures, and axioms.
- `Bell.lean` remains a thin umbrella and now re-exports the two stable CHSH
  leaves. It does not export `Bell.Audit.CHSH`.

This is a modern generalization. No declaration above is assigned to a numbered
equation of Bell's paper, and no CHSH constant is presented as Bell's own
equation-(16)–(22) approximation constant.

### Assumption and calculation audit

- `bounded_response_chsh_pointwise` rewrites the scalar expression as
  `A0*(B0+B1)+A1*(B0-B1)`. It proves
  `|B0+B1|+|B0-B1| <= 2` by the four sign cases and uses the two Alice bounds;
  the desired inequality is not a premise.
- `bounded_response_chsh` constructs exactly four integrable response products,
  intersects exactly four a.e. bound events, moves the finite sum through the
  integral with named integrability evidence, and uses normalization only to
  integrate the constant `2`. It never constructs one null set valid for all
  settings.
- The abstract leaf permits different Alice and Bob setting types. It imports
  no reproduction, original/robust inequality, quantum, geometry, or public
  umbrella module and has no binary or perfect-anticorrelation identifier.
- The target transfer derives the local CHSH bound internally and uses both
  sides of the four absolute-error assumptions. It needs no separate
  `0 <= epsilon` premise because any error hypothesis already entails it.
- The new direction is proved unit from its coordinate self inner product.
  All four target values are obtained from the finite-matrix theorem
  `singlet_spin_correlation` and explicit inner products; the target is never
  defined as `-inner`, and `2*sqrt(2)` is a conclusion rather than a premise.
- The no-model declarations keep one stored measure, local response arities,
  probability normalization, setting-wise measurability/boundedness, and
  correlation reproduction distinct. They do not claim complete joint-law
  reproduction, signaling, or any spacetime conclusion.

### Checked source decisions and deferments

- Equations (4)–(5) are mathematically correct for normalized uniform surface
  measure on the appropriate hemisphere, after proving the zero great-circle
  boundary null. The negative region is a spherical lune of relative measure
  `theta'/pi`. They are deferred because mathlib exposes sphere measures but no
  ready lune-area/sign-correlation theorem; a faithful proof needs rotational
  symmetry, normalization, and boundary-null infrastructure.
- Equation (6) requires
  `theta'=(pi/2)*(1-cos theta)`. A unit vector at that prescribed angle exists,
  but Bell's phrase “rotate towards” is false for obtuse `theta` where
  `theta'>theta`. Equations (6)–(7) remain deferred with that correction.
- Equations (8)–(10) are correct after correcting the printed response to
  `B(b,lambda)=-sign(b dot lambda)`. Equation (10) has endpoint values
  `-1`, `0`, and `1` at angles `0`, `pi/2`, and `pi`. Its uniform-sphere proof
  requires the same lune-area and null-equator work. `Real.sign` itself is not
  a binary outcome at zero, so it cannot bypass that obligation.
- Equation (11)'s `-(1/3) a dot b` is correct for a specified uniform ensemble
  of oppositely polarized product states. The paper's phrase “isotropic mixture
  of product states” alone does not specify this ensemble. Bell's literal
  continuous ensemble needs the sphere second moment. A separately defined
  six-axis antiparallel ensemble can realize the same correlation, but proving
  only that formula would not prove full state isotropy. Stable mixture
  semantics and either derivation remain deferred.
- The final Section III illustration is parameter-nonlocal because Alice's
  response uses Bob's setting. It repeats the prescribed-angle and sign-zero
  obligations and is deferred; this says nothing by itself about operational
  signaling.
- A genuine stochastic-local reduction needs binary conditional laws, local
  conditional distributions (kernels or explicit Bernoulli parameters), the
  factorization
  `P(x,y|a,b,lambda)=P_A(x|a,lambda)*P_B(y|b,lambda)`, and the associated
  measurability/integration argument. Local marginals alone are insufficient.
  The biases then lie in `[-1,1]` and feed the existing
  bounded theorem. Merely postulating their product correlation would not
  prove the reduction, so no renamed wrapper was added.
- Section V needs isometric qubit embeddings, an embedded singlet, subspace
  support, and extended operators. Zero extension adds a zero eigenvalue off
  the selected subspace, so a binary-outcome statement must be support
  restricted. This optional generalization remains deferred.
- The existing diagnostic two-point model was not promoted to public API
  because it already checks the general measure surface and has no independent
  public consumer. The CHSH audit's sharp one-point model supplies the needed
  explanatory example without expanding the stable API.

### Build, failure, scan, and axiom evidence

The construction and final builds succeeded:

```text
cd formal
lake build Bell.Inequality.CHSH             # 2,512 jobs
lake build Bell.Geometry.CHSHViolation      # 2,547 jobs
lake build Bell                             # 2,555 jobs
lake build Bell.Audit.CHSH Bell              # 2,556 jobs
lake build Bell.Inequality.CHSH Bell.Geometry.CHSHViolation \
  Bell.Audit.CHSH Bell                       # 2,556 jobs
lake build                                  # 2,555 jobs
```

The first audit build exposed an unsimplified diagnostic arithmetic goal
`1+1=2`; changing that audit proof from `simp` to `norm_num` closed it. The
same build reported one long `#print axioms` line, which was split. No public
theorem or assumption changed. Earlier scratch exploration also showed that
rewriting nested Bochner integrals through anonymous function addition was
syntactically brittle; the final proof names the four integrands and their
integrability evidence explicitly.

Every Stage 8 `#print axioms` result reports exactly:

```text
[propext, Classical.choice, Quot.sound]
```

The Lean-source proof-hole/escape scan found no `sorry`, `admit`, declaration
`axiom`, `unsafe`, `opaque`, or `native_decide`. Goal-document hits are only
guardrail templates, audit prose, and words used in ordinary English. The
abstract import and premise scans were empty. Target-shortcut and common-null-set
scans were empty. The fixed-measure scan found ordinary uses of the model's one
stored measure plus the diagnostic Dirac definition; it found no
setting-indexed measure. Geometry scans show the explicit inner-product and
`singlet_spin_correlation` derivations. The only physical-word hit is the
geometry module's explicit disclaimer that it draws no signaling or spacetime
conclusion. The only paper-scope hits label CHSH as modern and not a numbered
1964 theorem. The public-root scan finds `Inequality.CHSH` and
`Geometry.CHSHViolation` but not `Audit.CHSH`. `git diff --check` passed.

The exact final scan surface was:

```text
rg -n --glob '*.lean' '\bsorry\b|\badmit\b|^[[:space:]]*axiom\b|\bunsafe\b|\bopaque\b|\bnative_decide\b' formal/Bell
rg -n '\bsorry\b|\badmit\b|^[[:space:]]*axiom\b|\bunsafe\b|\bopaque\b|\bnative_decide\b' goal-1
rg -n '^(public )?import Bell\.(Quantum|Geometry|HiddenVariable\.Reproduction|Inequality\.(Original|Robust))|^(public )?import Bell$' formal/Bell/Inequality/CHSH.lean
rg -n 'IsAEBinaryValued|AliceAEBinary|BobAEBinary|PerfectAnticorrelationAt|ReproducesCorrelation|singletCorrelation|Bell\.Quantum|Bell\.Geometry' formal/Bell/Inequality/CHSH.lean
rg -n 'def singletCorrelation|axiom.*singlet|h(CHSH|Chsh|Violation|TargetBound|Tsirelson)|target.*-inner|target.*Real\.sqrt' formal/Bell/Inequality/CHSH.lean formal/Bell/Geometry/CHSHViolation.lean
rg -n '∀ᵐ[^\n]*∀|∀[^\n]*∀ᵐ|iInter|ae_all_iff|Eventually\.all' formal/Bell/Inequality/CHSH.lean formal/Bell/Geometry/CHSHViolation.lean
rg -n 'hiddenMeasure[[:space:]]*:=[^\n]*(a₀|a₁|b₀|b₁|bellA|bellC|bellB|chshBobMinus)|hiddenMeasure[[:space:]]*:[^\n]*→|Setting[AB][^\n]*→[^\n]*Measure|Measure[^\n]*Setting[AB]' formal/Bell/Inequality/CHSH.lean formal/Bell/Geometry/CHSHViolation.lean formal/Bell/Audit/CHSH.lean
rg -n 'Measure\.dirac' formal/Bell/Audit/CHSH.lean
rg -n 'direction_inner_eq_sum|singlet_spin_correlation|chshBobMinus_norm|singlet_chsh_abs_value_eq_two_mul_sqrtTwo' formal/Bell/Geometry/CHSHViolation.lean
rg -ni '1964 paper|Bell.?s 1964|numbered theorem|modern (generalization|four-setting)' formal/Bell/Inequality/CHSH.lean formal/Bell/Geometry/CHSHViolation.lean
rg -ni 'signaling|spacetime|Lorentz|superluminal' formal/Bell/Inequality/CHSH.lean formal/Bell/Geometry/CHSHViolation.lean
rg -n 'Bell\.(Inequality\.CHSH|Geometry\.CHSHViolation|Audit\.CHSH)' formal/Bell.lean
rg -n 'Audit\.CHSH' formal/Bell.lean
git diff --check
git status --short
```

The Lean-source, abstract-import, abstract-premise, target-shortcut, a.e.-order,
setting-indexed-measure, and public-root audit-import scans exited `1` with no
hits. The goal-folder scan exited `0` only on guardrails, command templates,
prior audit reports, and ordinary English such as “admit averages”; it exposed
no Lean declaration. The Dirac scan found only the audit model's two diagnostic
lines. The geometry scan found the expected coordinate-inner-product and
`singlet_spin_correlation` proof steps. The paper-scope scan found only the
explicit modern/not-1964 labels, the physical-scope scan found only the explicit
negative disclaimer, and the positive root scan found exactly the two public
CHSH imports. `git diff --check` exited `0`. At this verification point,
`git status --short` listed only the two documentation fold-back files,
`goal-1/0-plan.md` and `goal-1/8-EXAMPLES.md`.

Stage 9 (`9-RELEASE-AUDIT`) is the next incomplete stage. The preceding
deferments remain explicit optional future work rather than hidden Stage 8
obligations.
