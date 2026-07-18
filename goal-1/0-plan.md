# Bell 1964 Lean Library Plan (`BELL1964`)

## Status

- Scaffold created 2026-07-17.
- Stages 1 (`1-GUARDRAILS`) through 8 (`8-EXAMPLES`) completed
  2026-07-17. Stage 9 (`9-RELEASE-AUDIT`) is the next incomplete stage.
- This document is the authoritative strategy, paper map, preliminary correction
  log, dependency plan, and proposed theorem outline.
- The pinned project now exports a general-measure deterministic local-model
  API, correlation and range theorems, distinct pointwise/a.e.
  perfect-anticorrelation predicates, the fixed-setting extremal-correlation
  bridge, equation (14), Bell's original inequality, correlation-reproduction
  predicates, the independently calculated finite-dimensional singlet
  correlation, explicit unit directions, and the finite-setting contradiction.
- Stage 3 added `Bell.HiddenVariable.Basic`, `Correlation`, and
  `PerfectAnticorrelation`, all re-exported by `Bell.lean`, plus the non-exported
  `Bell.Audit.LocalModel` verification leaf. Exact results and audit evidence
  are in `goal-1/3-LOCAL-MODEL.md`.
- Stage 4 added `Bell.Inequality.Original`, extended
  `Bell.HiddenVariable.PerfectAnticorrelation`, re-exported the stable theorem
  leaf from `Bell.lean`, and added the non-exported
  `Bell.Audit.OriginalInequality`. Exact results are in
  `goal-1/4-BELL-BOUND.md`.
- Stage 5 added `Bell.Quantum.Basic`, `Pauli`, and `Singlet`, re-exported the
  stable singlet leaf from `Bell.lean`, and added the non-exported
  `Bell.Audit.Singlet`. Its explicit Pauli/Kronecker calculation proves equation
  (3) without importing the hidden-variable inequality. Exact results are in
  `goal-1/5-SINGLET.md`.
- Stage 6 added `Bell.HiddenVariable.Reproduction`,
  `Bell.Geometry.BellDirections`, and `Bell.Geometry.Violation`, re-exported
  the stable surface from `Bell.lean`, and added the non-exported
  `Bell.Audit.Violation`. It proves exact unit-vector geometry, the numerical
  singlet violation, and finite/global correlation non-reproduction theorems.
  Exact results are in `goal-1/6-VIOLATION.md`.
- Stage 7 added `Bell.HiddenVariable.Bounded`,
  `Bell.Approximation.Uniform`, `Bell.Inequality.Robust`, and
  `Bell.Geometry.RobustViolation`, re-exported their stable surface from
  `Bell.lean`, and added the non-exported `Bell.Audit.Robust`. It proves the
  bounded-response defect inequality, the exact four-error transfer, the
  positive singlet uniform-error threshold `(sqrt(2)-1)/4`, and Bell's
  `epsilon`/`delta` lower bound on explicit unit-setting domains. Exact results
  and the literal-smearing deferment are in `goal-1/7-ROBUSTNESS.md`.
- Stage 8 added `Bell.Inequality.CHSH` and
  `Bell.Geometry.CHSHViolation`, re-exported their stable surface from
  `Bell.lean`, and added the non-exported `Bell.Audit.CHSH`. It proves the
  bounded-response CHSH inequality, the exact four-error transfer, a calculated
  four-direction singlet value `2 * sqrt 2`, the finite error threshold
  `(sqrt 2 - 1) / 2`, and finite/global correlation non-reproduction results.
  It labels CHSH as a modern generalization and records exact deferments for the
  paper's optional examples. Exact results are in `goal-1/8-EXAMPLES.md`.
- For a fixed triple, checked direct algebra shows equation (15) needs perfect
  anticorrelation only at `b`; requiring it at `c` as well would be stronger
  than necessary. The public direct theorem uses this minimal fixed-`b`
  premise, and its corollary derives it from the single diagonal correlation
  `P(b,b) = -1`.

## Big-Picture Objective

Turn J. S. Bell's 1964 paper *On the Einstein Podolsky Rosen Paradox* into a
correct, reusable Lean 4 library. The verified core will separate:

1. an abstract Bell inequality for deterministic local hidden-variable models;
2. a finite-dimensional calculation of the spin-singlet correlation;
3. an explicit choice of unit measurement directions that violates the bound.

The later library should also formalize Bell's robust non-approximation argument
if it can be stated cleanly, and selected examples or generalizations when they
improve the API. Physical and philosophical interpretations will remain prose
unless their concepts receive independent formal definitions.

## Non-Negotiable Constraints and No-Cheating Rules

- Pin Lean and mathlib versions and make every checked declaration compile.
- Use no `sorry`, `admit`, `unsafe` proof escape, fabricated theorem, or
  unexplained project-specific axiom.
- Do not encode the desired correlation or contradiction as a hypothesis in a
  theorem advertised as deriving it.
- Independently check the paper's mathematics; treat it as a source, not a
  formal specification.
- Record every material correction, strengthened hypothesis, weakened
  conclusion, convention choice, and unresolved issue in this plan and later
  permanent documentation.
- Keep locality, deterministic responses, measurement-setting independence,
  probability normalization, binary outcome range, perfect anticorrelation,
  and reproduction of quantum statistics as separately visible assumptions.
- State whether each equality or bound is pointwise, almost everywhere, in
  expectation, or uniform in settings.
- Never turn `forall setting, almost everywhere hidden-variable` into
  `almost everywhere hidden-variable, forall setting` without a justified
  countability or measurability argument.
- Audit all measurability, integrability, null-set, sign-at-zero, absolute-value,
  normalization, tensor/inner-product, and unit-vector obligations.
- Keep the abstract inequality, quantum calculation, concrete violation, and
  interpretation in separate modules and theorem layers.
- A finite/discrete theorem may precede the measure-theoretic result, but it
  cannot silently replace the paper's general probability-space formulation.
- Green builds count only when they exercise the declarations and requirements
  claimed for the current stage.
- The paper's claims about influence, signaling speed, and Lorentz invariance
  are not consequences of the bare mathematical theorem and must not be exposed
  as verified conclusions without additional formal premises.

## Current Facts

### Repository facts

- The source transcription is `bell-1964/bell-1964.md`; the six-page scan is
  `bell-1964/bell-1964.pdf` (printed pp. 195–200, with SHA-256 recorded in
  `goal-1/1-GUARDRAILS.md`).
- Stage 1 visually checked every page, equations (1)–(22), the intervening core
  algebra, and Sections V–VI against the scan. Its authoritative source map,
  correction evidence, quantifier conventions, scope boundaries, and audit
  commands are in `goal-1/1-GUARDRAILS.md`.
- The Lean project is under `formal/`, pinned to Lean `v4.31.0` and mathlib
  commit `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`. Its public `Bell` root
  re-exports five hidden-variable modules, the target-agnostic uniform-error
  leaf, the original, robust, and CHSH inequality leaves, the separate quantum
  singlet leaf, and the exact, robust, and CHSH geometric integration layers.
  Nine
  non-exported audit leaves cover dependency probes, the local-model API, the
  abstract inequalities, quantum conventions/calculation, the concrete
  violations, robustness, and CHSH.
- `BUILD-PLAN.md` is a generic Lean workflow that later stages should specialize.
- The existing Python/uv starter files are unrelated to the intended Lean
  library and should not be deleted or repurposed without an explicit decision.
- Stage 1 repaired the transcription's broken scan links and disclosed its
  normalization of the printed typo in equation (9).

### Mathematical facts provisionally accepted for planning

- Bell's deterministic model uses responses with values in `{−1, +1}` and a
  normalized hidden-variable distribution independent of measurement settings.
- Locality is represented at the response-function level by Alice's response
  depending on `(a, lambda)` but not `b`, and Bob's on `(b, lambda)` but not `a`.
- For fixed settings, perfect anticorrelation can be an almost-everywhere
  equality `A a = -B a`; a correlation of `-1` implies this only after binary
  range, measurability/integrability, and probability normalization are used.
- For the relevant fixed settings, Bell's original inequality is
  `|P(a,b) - P(a,c)| <= 1 + P(b,c)`.
- The spin-singlet prediction is now checked as
  `singletCorrelation a b = -(inner Real a b)` from explicit finite matrices
  and a normalized state. The algebraic theorem holds for arbitrary real
  three-vectors; Bell's physical measurement settings are unit vectors.
- `bellA=e0`, `bellC=e1`, and
  `bellB=(e0+e1)/sqrt(2)` are now proved unit vectors with
  `bellA dot bellC=0` and
  `bellA dot bellB=bellB dot bellC=1/sqrt(2)`. Their directional Pauli
  observables are audited to square to the identity.
- The calculated singlet values at `(a,b)`, `(a,c)`, `(b,c)`, and `(b,b)` are
  respectively `-1/sqrt(2)`, `0`, `-1/sqrt(2)`, and `-1`. Equation (15) would
  require `1/sqrt(2) <= 1-1/sqrt(2)`, while Lean proves the strict reverse.
- The minimal finite no-go theorem uses only Alice measurability/binary range
  at `a,b`, Bob measurability/binary range at `b,c`, normalization, and four
  correlation-reproduction equalities. Reproduction at `(b,b)` derives the
  fixed-`b` a.e. perfect anticorrelation; no global common null set is formed.
- Stage 7 confirms that Bell's averaged responses in
  equations (19)–(20) are real-valued and bounded by one, not binary. Direct
  algebra for such responses gives the reusable defect inequality
  `|P(a,b)-P(a,c)| <= 2+P(b,c)+P(b,b)`. The public arbitrary-probability-measure
  theorem assumes only the four relevant response functions are a.e.
  measurable and a.e. bounded by one. Combining four correlation errors of
  radius `eta` with the Stage 6 directions now proves
  `4*eta >= sqrt(2)-1` and `(sqrt(2)-1)/4 <= eta` in Lean.
- Because `Direction` is the ambient real three-space rather than a unit-sphere
  subtype, Stage 7's `UniformlyWithinOn` predicate exposes both setting domains
  and the robust singlet theorems use `unitDirectionSet`. Quantifying over every
  ambient vector would be a stronger algebraic convenience, not Bell's claim.
- Bell does not specify unique angular-cap weights. A literal isolated-point
  smearing theorem would need parameterized local probability measures plus an
  atomlessness or surface-absolute-continuity premise; arbitrary supported
  measures include Dirac masses and do not remove isolated exceptions.
- Stages 3–8 now check the structural local-model facts, correlation integral,
  response-product integrability and range, correlation-`-1` implication,
  equation (14), Bell inequality, Pauli/involution properties, singlet
  normalization, equation (3), exact direction geometry, and the concrete
  contradiction, plus the bounded-response robust inequality and exact uniform
  singlet non-approximation constant. Stage 8 additionally proves the
  bounded-response CHSH inequality for four fixed responses on one normalized
  hidden measure, transfers four target errors to the bound `2 + 4 * eta`, and
  calculates an explicit singlet CHSH value with absolute value
  `2 * sqrt 2`.
- At the four proved unit directions, Lean derives the CHSH error obstruction
  `(sqrt 2 - 1) / 2 <= eta` and rules out a bounded local model reproducing
  those four singlet correlations. The global no-model theorem is a convenient
  stronger corollary whose premise reproduces the target on every pair of
  ambient `Direction` values; the finite theorem assumes only the four proved
  unit-setting pairs used by the CHSH contradiction.
- CHSH is recorded as a modern, post-1964 generalization rather than mapped to
  a numbered claim of Bell's paper. Bell's sphere-sign, single-particle,
  mixed-state, nonlocal, stochastic-kernel, and higher-dimensional
  illustrations are explicitly deferred with their additional obligations in
  `goal-1/8-EXAMPLES.md`.

### Assumptions and open design hypotheses

- The general hidden-variable layer uses one stored `Measure Omega`, with
  `[IsProbabilityMeasure model.hiddenMeasure]` kept separate in analytic
  theorems; it does not require a density `rho`.
- Responses are real-valued functions with separately named
  binary-range predicates. This keeps the `±1` premise visible and avoids
  coercion overhead in integrals; a sign type remains a possible later adapter.
- Measurement-setting independence is represented by one fixed
  stored measure for every pair of settings. If conditional/distribution-valued
  models are later added, independence must become an explicit property.
- Measurement settings for the abstract inequality remain polymorphic. The
  quantum layer uses `Direction = EuclideanSpace Real (Fin 3)`; unit length is
  kept outside the raw type and is proved separately for Stage 6's concrete
  vectors.
- The quantum layer uses complex functions and matrices indexed by `Fin 2` and
  `Fin 2 × Fin 2`, with ordered matrix Kronecker products. Algebraic
  `TensorProduct` remains unnecessary for the coordinate calculation.
- `singletCorrelation` is the real part of a separately defined matrix
  expectation. The formula `-inner Real a b` appears only in proved theorems,
  not in the definition or a premise.
- `ReproducesCorrelationAt` and `ReproducesCorrelation` assert only equality of
  correlation expectations at one or all setting pairs. They deliberately do
  not claim reproduction of complete joint laws or all quantum statistics.
- Bell's smearing argument is factored through the checked general robust
  inequality for responses in `[-1,1]`. A literal angular-average
  instantiation remains optional and would require additional center-indexed
  probability measures, support, joint measurability/product integrability,
  Fubini, and uniform geometric-error proofs.
- The Stage 8 CHSH theorem applies to a.e. measurable bounded effective
  responses and requires neither binary range nor perfect anticorrelation. Its
  singlet integration leaf calculates all four target values through
  `singlet_spin_correlation`; the value `2 * sqrt 2` is a proved conclusion,
  not a premise.

## Success Metrics and Final Verification

The original objective is complete only when all of the following hold:

- A pinned Lean/mathlib package builds from a clean checkout with documented
  commands.
- Public definitions expose deterministic local responses, a fixed normalized
  hidden-variable measure, binary outcomes, correlations, perfect
  anticorrelation, and reproduction predicates without conflating them.
- A reusable measure-theoretic Bell inequality is proved; any finite/discrete
  version is connected to it or clearly labeled as a preliminary specialization.
- The singlet correlation is calculated from independently defined
  finite-dimensional quantum objects.
- Explicit proved unit vectors instantiate the quantum formula and yield a
  formal contradiction with the local-model inequality.
- The approximation claim is either formalized with a precise topology,
  constants, and averaging assumptions, or documented as deferred with exact
  unresolved proof obligations. It cannot be reported as complete merely from
  the exact contradiction.
- Every main paper claim in scope is mapped to a Lean declaration or to a
  documented correction/deferment.
- Documentation distinguishes formal theorems from physical interpretation.
- `lake build` succeeds; focused example/test modules succeed; source scans find
  no proof holes or unauthorized axioms; `#print axioms` on the main results is
  recorded and contains only understood Lean/mathlib foundations.
- `git diff --check` succeeds and the final correction log, dependency notes,
  declaration map, and reproducibility instructions agree with the code.

## Paper Map and Intended Formal Treatment

| Paper location | Mathematical content | Planned treatment |
|---|---|---|
| Sec. II, (1), p. 196 | Deterministic binary responses `A(a,lambda)`, `B(b,lambda)` | Stage 3: `DeterministicLocalModel`, `IsBinaryValued`, `AliceBinary`, `BobBinary`; locality visible in response arity |
| Sec. II, (2), p. 196; (12), p. 197 | Correlation under normalized `rho` | Stage 3: fixed arbitrary `Measure`, separate `IsProbabilityMeasure`, and Bochner `correlation`; Stage 6: generic `ReproducesCorrelationAt`/`ReproducesCorrelation`; no density required |
| Sec. II, (3), p. 196 | Singlet correlation `-a dot b` | `singlet_spin_expectation_coordinates`, `singlet_spin_expectation`, and real `singlet_spin_correlation`, derived from explicit Pauli matrices, Kronecker observable, and normalized singlet ket |
| Sec. III, (4)–(7), p. 196 | Single-particle sign model | Explicitly deferred in Stage 8. A faithful theorem needs normalized hemisphere surface measure, a total sign convention, a null equator proof, a spherical-lune probability calculation, and prescribed-angle existence. Equation (6) requires `theta'=(pi/2)*(1-cos theta)`; the printed “rotate towards” instruction fails for some obtuse angles. |
| Sec. III, (8)–(10), p. 197 | Uniform-sphere local example and linear-in-angle correlation | Explicitly deferred in Stage 8. The printed equation-(9) response is corrected to `B(b,lambda)=-sign(b dot lambda)`. A proof still needs normalized sphere measure, total binary responses, null equators, and the lune probability `theta/pi`; `Real.sign` is zero on the boundary. |
| Sec. III, (11), p. 197 | Isotropic mixture correlation `-(1/3)a dot b` | Explicitly deferred in Stage 8. The ensemble must be specified. Bell's literal uniform ensemble of product states polarized along opposite directions requires a sphere second-moment proof. A six-axis antiparallel ensemble realizes the same correlation, but that correlation alone does not establish full rotational invariance of the state. |
| Sec. III, final paragraph, p. 197 | Nonlocal construction reproducing the correlation | Explicitly deferred one-sided parameter-nonlocal illustration: Alice's response uses Bob's setting. It repeats the prescribed-angle/sign-boundary obligations and is not an operational-signaling theorem. |
| Sec. IV, (13), p. 197 | Perfect anticorrelation from correlation `-1` | `perfectAnticorrelationAt_of_correlation_eq_neg_one`, fixed-setting a.e.; audited with a null exception that prevents pointwise strengthening |
| Sec. IV, (14), p. 197 | Rewrite using perfect anticorrelation | `correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt` |
| Sec. IV, (15), pp. 197–198 | Original Bell inequality | `bell_original_of_perfectAnticorrelationAt` and the diagonal-correlation corollary; general arbitrary probability measure, no quantum premise. Stage 6 separately gives `singlet_violates_bell_original` and the finite no-model corollary. |
| Sec. IV, (16)–(17), p. 198 | Local-to-averaged and averaged-to-point singlet uniform errors | Hypotheses `h16` and `h17` use `UniformlyWithinOn unitDirectionSet unitDirectionSet`; the intermediate `averagedTarget` is abstract and represents the averaged quantum correlation |
| Sec. IV, (18), p. 198 | Addition of the two uniform error radii | `UniformlyWithinOn.trans_add` |
| Sec. IV, (19)–(20), p. 198 | Factorization through averaged responses bounded by one | `IsBoundedByOne`/`IsAEBoundedByOne`, their setting-wise variants, and `bounded_response_bell_robust` formalize the post-factorization bounded-response argument. A concrete cap-measure construction and Fubini derivation of (19) are explicitly deferred. |
| Sec. IV, unnumbered robust algebra and (21)–(22), pp. 198–199 | Diagonal defect and quantitative non-approximation bound | `bounded_response_bell_pointwise`, `target_bell_robust_of_four_errors`, `bell1964_four_mul_total_error_lower_bound`, and the two `bell1964_epsilon_*_of_uniform_averaging_errors` conclusions; the role of (21) is incorporated through the `(b,b)` error hypothesis |
| Example after (22), p. 199 | `a dot c=0`, `a dot b=b dot c=1/sqrt(2)` | `bellA`, `bellB`, `bellC`, their norm/inner-product theorems, and exact singlet values. Stage 6 reuses this later paper example as a modern explicit instantiation of (3)+(15); Stage 7 derives the equation-(22) constant in `singlet_four_mul_error_lower_bound_at_bellDirections`, `singlet_error_lower_bound_at_bellDirections`, and `singlet_uniform_error_lower_bound_on_unitDirections`. |
| Sec. V, p. 199 | Higher-dimensional embedding/generalization | Explicitly deferred in Stage 8. A faithful result needs isometric qubit embeddings, embedded-state support, and support-restricted binary observables: zero extension squares to a subspace projection, not the ambient identity. |
| Sec. VI, p. 199 | Nonlocal influence, instantaneous signaling, Lorentz claim | Prose interpretation only absent additional physical definitions/premises |
| Modern generalization (not in Bell 1964) | Bounded-response CHSH inequality and four-direction singlet violation | Stage 8: `bounded_response_chsh`, `target_chsh_of_four_errors`, `singlet_violates_chsh`, `singlet_chsh_error_lower_bound_at_directions`, and finite/global bounded-local-model correlation non-reproduction corollaries. |

## Preliminary Audit and Correction Log

Stage 1 confirmed or refined every entry below against the scan and paper-level
mathematics. Detailed source evidence is in `goal-1/1-GUARDRAILS.md`; Stages
3–8 have since discharged the entries belonging to the exact, robust, and CHSH
mathematical core, while optional examples and literal angular averaging remain
pending as identified below.

1. **Probability distribution versus density.** The notation `rho(lambda)
   d lambda` presumes a density. The reusable theorem should use an arbitrary
   probability measure; a density becomes an optional specialization.
2. **Measurement-setting independence is implicit.** Equation (2) uses the same
   `rho` for all settings. The library will name this assumption instead of
   hiding it inside a phrase such as “local realism.”
3. **Determinism is an explicit model assumption.** Bell motivates it using EPR
   perfect predictability and locality, but that prose argument contains
   counterfactual/physical premises not formalized by (1)-(2). The core theorem
   assumes deterministic response functions directly.
4. **Locality is encoded but should be named.** Separate arities for `A` and `B`
   rule out remote-setting dependence. This is parameter independence for a
   deterministic model, not a complete formalization of relativistic locality.
5. **Almost-everywhere scope.** Equation (13) follows for each fixed setting up
   to a null set. For uncountably many settings this does not give one common
   full-measure set. The Bell proof for a fixed finite tuple can combine the
   finitely many required exceptional sets.
6. **Equation (13) needs hypotheses.** Deriving anticorrelation from expectation
   `-1` uses binary outcomes, normalization, and measurability/integrability.
   These will appear in the theorem signature.
7. **Likely prose typo before (15).** “It follows that c is another unit vector”
   should read “If c is another unit vector.” No mathematical content depends on
   the printed wording.
8. **Stationarity discussion is heuristic as written.** The “in general of
   order” claim assumes regularity/nonconstancy not stated in the paper. The
   library will rely on the exact finite-setting inequality, not advertise that
   heuristic as a theorem without precise analytic assumptions.
9. **Averaging obligations in (16)-(20).** Independent setting averages require
   setting-space probability measures, joint measurability or suitable iterated
   integrability, and a Fubini argument to reach (19). None is explicit in the
   paper; any formal smearing theorem must add them.
10. **Meaning of “not arbitrarily closely approximated.”** The paper proves a
    positive obstruction for a particular uniform approximation criterion after
    local independent averaging, with angular averaging error `delta`; it does
    not by itself exclude every pointwise, almost-everywhere, or `L^p` notion of
    approximation. The formal theorem and documentation will name the topology
    and quantifiers.
11. **Quantitative conclusion.** Equation (22) with Bell's directions yields
    `epsilon >= (sqrt(2)-1)/4 - delta`, not merely the qualitative phrase
    “cannot be arbitrarily small.” Positivity requires a stated upper bound on
    `delta`.
12. **Sign at zero.** The examples in (4) and (9) leave zero undefined and appeal
    to a probability-zero set. Lean definitions must be total, choose a value at
    zero, and separately prove that the choice does not affect the expectation.
13. **Physical conclusion exceeds the proved mathematics.** A failure of the
    deterministic setting-independent local factorization does not alone prove
    controllable superluminal signaling or failure of Lorentz invariance. Those
    sentences remain historical interpretation.
14. **Higher-dimensional generalization needs care.** Extending Pauli operators
    by zero changes their outcome spectrum outside the chosen subspace. The
    state support and exact theorem statement must be explicit if Section V is
    formalized.
15. **Printed equation (9) has a malformed left side.** The scan prints
    `B(a,b)` while (1), (2), the right side of (9), and (10) require
    `B(b,lambda)`. The transcription uses the intended form and now labels the
    correction explicitly.
16. **The “rotate towards” prescription fails for obtuse angles.** Equation (6)
    requires `theta'=(pi/2)(1-cos theta)`, which is greater than `theta` for
    some obtuse `theta` (for example `2pi/3`). The optional examples should
    choose a vector having the prescribed angle rather than assert a rotation
    towards the reference vector. The nonlocal illustration repeats the issue.
17. **A.e. binary range is a documented modern weakening.** Bell's equation (1)
    is pointwise. The library exposes that exact pointwise predicate and proves
    it implies the setting-wise a.e. predicate used by the integration theorems.
    This changes no paper consequence because null-set modifications do not
    affect the correlation, but the two notions remain distinct in the API.
18. **Equation (15) needs anticorrelation only at `b` for a fixed triple.**
    Rewriting all three correlations through equation (14) suggests relations
    at both `b` and `c`, but the mixed Alice/Bob pointwise algebra proves the
    displayed inequality from `PerfectAnticorrelationAt model b` alone. The
    direct theorem uses this weaker premise, and the diagonal corollary assumes
    only `P(b,b) = -1`. This is a checked assumption minimization, not a change
    to the inequality's conclusion.
19. **Equation (3) separates an algebraic identity from physical unit
    directions.** Bell uses dimensionless Pauli spin components and unit
    measurement vectors. The checked matrix identity
    `singletCorrelation a b = -inner Real a b` is homogeneous and holds for
    arbitrary real three-vectors. Unit length is needed to obtain
    `(spinObservable a)^2 = I` and hence the `±1` measurement interpretation,
    not to prove the correlation polynomial. The library exposes the stronger
    algebraic theorem and keeps unit hypotheses for physical instantiations.
20. **Correlation reproduction is not complete-statistics reproduction.** The
    Stage 6 predicates equate the model correlation expectation with an
    arbitrary target at one or all setting pairs. This is exactly what the Bell
    proof consumes, but it does not by itself equate outcome marginals or joint
    probability laws. Declarations and documentation therefore say
    “correlation reproduction,” not “reproduction of all quantum statistics.”
21. **The explicit direction triple occurs after equation (22).** Bell gives
    the inner products while evaluating the robustness bound, not as a
    displayed exact-contradiction step immediately after (15). Reusing the same
    unit triple to instantiate the independently proved equation (15) and
    equation (3) is mathematically valid, but the library records it as a
    modern explicit instantiation rather than a literal transcription of that
    paragraph.
22. **Averaged responses are bounded, not binary.** Equations (19)–(20)
    generally produce values in `[-1,1]`, so equation (15) cannot simply be
    reused after averaging. The checked pointwise algebra retains the essential
    diagonal-defect term and proves
    `|P(a,b)-P(a,c)| <= 2+P(b,c)+P(b,b)` without perfect anticorrelation. The
    compiled theorem permits setting-wise a.e. bounds, a sufficient modern
    weakening of Bell's displayed pointwise equation (20).
23. **Uniform settings must be physically scoped.** The library's `Direction`
    type is all of real three-space and the algebraic singlet correlation is
    unbounded there. Bell's uniform comparison concerns measurement
    directions, so the Stage 7 theorem quantifies over `unitDirectionSet`
    through `UniformlyWithinOn`, rather than silently claiming a bound on all
    ambient vectors.
24. **Angular weights and isolated exceptions are underspecified.** Bell gives
    angular neighborhoods but no unique probability weights. A literal
    equation-(19) theorem needs center-indexed normalized local setting
    measures, their independent product and independence from the one fixed
    hidden measure, joint measurability or product integrability, and
    Fubini/Tonelli. Arbitrary cap-supported measures may be Dirac; removing
    isolated failures additionally requires atomlessness or suitable surface
    absolute continuity. Stage 7 therefore proves the clean post-factorization
    obstruction and records the concrete smearing construction as deferred.
25. **The averaged target carries the singlet sign.** In the Stage 7
    `epsilon`/`delta` theorems, `averagedTarget` denotes the averaged quantum
    correlation—under Bell's convention, the negative averaged dot product.
    It must not be read as the positive averaged dot product. The theorem is
    uniform pointwise in unit settings and makes no `L^p`, setting-a.e., or
    arbitrary-topology claim.
26. **“Isotropic mixture of product states” does not uniquely specify equation
    (11).** The coefficient `-1/3` follows from a particular isotropic ensemble,
    such as uniformly averaging product states polarized along `p` and `-p`.
    A future formalization must define the one-particle density states and their
    mixture, then derive the sphere second moment. A finite six-axis
    antiparallel ensemble gives the same two-point correlation, but that fact
    alone does not prove that the mixed state is fully rotationally invariant;
    isotropy as informal prose is not a complete mathematical definition.
27. **CHSH is a modern generalization, not a claim of the 1964 paper.** Its
    bounded-response form removes the perfect-anticorrelation premise and gives
    a reusable four-setting inequality. Stage 8 labels it as a later theorem
    rather than assigning it to equations (1)–(22), calculates the singlet value
    at four unit directions, and proves the finite common-radius four-error
    obstruction
    `(sqrt 2 - 1) / 2 <= eta` without assuming binary responses or perfect
    anticorrelation.
28. **A stochastic-local reduction needs conditional factorization.** Local
    marginals alone do not imply
    `P(x,y | a,b,lambda) = P_A(x | a,lambda) * P_B(y | b,lambda)`. Under that
    explicit factorization, binary conditional biases are bounded by one and
    can feed the Stage 7/8 inequalities. Turning this bias argument into a
    deterministic random-seed construction additionally requires product
    probability spaces, measurability, Fubini, and a proof that correlations are
    preserved; no such reduction is claimed merely by renaming bounded response
    functions.

## Dependency and Module Notes

The project uses Lean `v4.31.0` and exact mathlib commit
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`. The retained diagnostic leaves
now include:

- `Bell.Audit.ProbabilityApi`, using probability-measure and Bochner-integral
  APIs, including a.e. conjunction and integral congruence;
- `Bell.Audit.GeometryApi`, using `EuclideanSpace ℝ (Fin 3)`, coordinate
  vectors, finite inner-product sums, norms, and `Real.sqrt`;
- `Bell.Audit.QuantumApi`, using finite complex kets/matrices, conjugate
  transpose, Hermitian predicates, trace, matrix Kronecker products, and a raw
  pure-state expectation;
- `Bell.Audit.LocalModel` and `Bell.Audit.OriginalInequality`, covering the
  general hidden-variable API, finite models, null exceptions, and abstract
  Bell bound; and
- `Bell.Audit.Singlet`, covering state coordinates, normalization, Pauli
  handedness, genuine complex conjugation, tensor order, direct axis
  correlations, and Stage 5 axiom output; and
- `Bell.Audit.Violation`, covering concrete coordinates and geometry,
  unit-observable involutions, exact singlet values, no-model theorem
  signatures, and Stage 6 axiom output; and
- `Bell.Audit.Robust`, covering a genuinely nonbinary bounded model, sharp
  robust algebra, uniform-error composition, unit-setting domains, public
  signatures, and Stage 7 axiom output; and
- `Bell.Audit.CHSH`, covering a normalized one-point bounded/nonbinary model
  saturating the CHSH bound, a representative Alice binary-to-bounded bridge,
  explicit directions and values, public signatures, and Stage 8 axiom output.

Relevant mathlib areas used or retained for later implementation include:

- `Mathlib/MeasureTheory/Measure/ProbabilityMeasure` and integration APIs for
  probability normalization, a.e. reasoning, and bounded integrability;
- `Mathlib/Analysis/InnerProductSpace/PiL2` for real three-vectors, norms, and
  dot/inner products;
- `Mathlib/Data/Matrix/*`, complex numbers, conjugate transpose, and finite sums
  for Pauli matrices and expectations;
- available tensor/Kronecker-product or finite Hilbert-space APIs for two-qubit
  operators and the singlet state;
- `Real.sqrt`, positivity, and normalization lemmas for explicit directions;
- sphere and Haar/surface probability APIs only if the optional examples or
  angular-smearing instantiation justify their dependency cost.

Current implemented layering, with later optional leaves shown explicitly:

```text
Bell/
  HiddenVariable/Basic.lean
  HiddenVariable/Correlation.lean
  HiddenVariable/PerfectAnticorrelation.lean
  HiddenVariable/Reproduction.lean
  HiddenVariable/Bounded.lean
  Approximation/Uniform.lean
  Inequality/Original.lean
  Inequality/Robust.lean
  Inequality/CHSH.lean
  Quantum/Basic.lean
  Quantum/Pauli.lean
  Quantum/Singlet.lean
  Geometry/BellDirections.lean
  Geometry/Violation.lean
  Geometry/RobustViolation.lean
  Geometry/CHSHViolation.lean
  Audit/ProbabilityApi.lean         # diagnostic; not re-exported
  Audit/GeometryApi.lean            # diagnostic; not re-exported
  Audit/QuantumApi.lean             # diagnostic; not re-exported
  Audit/LocalModel.lean             # diagnostic; not re-exported
  Audit/OriginalInequality.lean     # diagnostic; not re-exported
  Audit/Singlet.lean                # diagnostic; not re-exported
  Audit/Violation.lean              # diagnostic; not re-exported
  Audit/Robust.lean                 # diagnostic; not re-exported
  Audit/CHSH.lean                   # diagnostic; not re-exported
  Examples/SphereModel.lean         # explicitly deferred optional leaf
  PaperMap.lean                     # planned release documentation
  AxiomAudit.lean                   # planned consolidated release audit
  Bell.lean
```

Low-dependency abstract probability modules must not import quantum matrix or
Euclidean geometry modules. Heavy quantum calculations and optional examples
should remain leaf modules. The umbrella module should only re-export the stable
public surface.

## Proposed Declaration Outline

Implemented declarations below are labeled by stage; later names and exact
signatures remain provisional until checked against mathlib conventions.

- `IsBinaryOutcome`, `IsBinaryValued`, and `IsAEBinaryValued`: actual Stage 3
  declarations for one value, pointwise range, and a.e. range.
- `DeterministicLocalModel SettingA SettingB Omega`: actual Stage 3 structure
  with response functions and one fixed hidden-variable measure; normalization,
  measurability, and binary range are not bundled.
- `correlation model a b`: actual Stage 3 expectation of the response product.
- `ReproducesCorrelationAt` and `ReproducesCorrelation`: actual Stage 6
  target-agnostic predicates for correlation equality at one or all setting
  pairs; they import no quantum definition.
- `PointwisePerfectAnticorrelationAt` and `PerfectAnticorrelationAt`: actual
  Stage 3 pointwise and fixed-setting a.e. equality predicates.
- `responseProduct_integrable` and `correlation_mem_Icc`: actual Stage 3
  analytic results under explicit fixed-setting assumptions.
- `perfectAnticorrelationAt_of_correlation_eq_neg_one`: actual Stage 4 theorem
  deriving the fixed-setting a.e. relation under explicit normalization,
  measurability, and binary hypotheses.
- `correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt`: actual
  Stage 4 equation (14) rewrite at one Bob setting.
- `bell_original_of_perfectAnticorrelationAt`: actual Stage 4 theorem proving
  `abs (P a b - P a c) <= 1 + P b c` from the minimal fixed-`b`
  anticorrelation and fixed-setting analytic hypotheses.
- `bell_original_of_diagonal_correlation_eq_neg_one`: actual Stage 4 corollary
  deriving the fixed-`b` relation from `P(b,b) = -1`.
- `bell_original_finite`: optional finite/discrete specialization used as an
  explanatory bridge, not the final general result.
- `QubitKet`, `QubitOperator`, `TwoQubitKet`, `TwoQubitOperator`, `ketInner`,
  `pureExpectation`, and `IsNormalizedKet`: actual Stage 5 finite coordinate
  vocabulary.
- `pauliX`, `pauliY`, `pauliZ`, and `spinObservable`: actual Stage 5 explicit
  matrices and directional observable; `spinObservable_isHermitian` and the
  square/involution theorems verify its observable conventions.
- `singletState`, `twoSpinObservable`, `singletSpinExpectation`, and
  `singletCorrelation`: actual Stage 5 state, product observable, and computed
  expectation/correlation definitions.
- `singlet_spin_expectation_coordinates`, `singlet_spin_expectation`, and
  `singlet_spin_correlation`: actual Stage 5 derivations of the full complex
  coordinate expectation and `singletCorrelation a b = -inner Real a b` for
  arbitrary real three-vectors.
- `bellA`, `bellB`, `bellC`, and `bellScale`: actual Stage 6 explicit directions
  and scale, with proved unit norms, exact dot products, square-root facts, and
  the strict scalar inequality used by the violation.
- `singletCorrelation_bellA_bellB`, `singletCorrelation_bellA_bellC`,
  `singletCorrelation_bellB_bellB`, and
  `singletCorrelation_bellB_bellC`: actual Stage 6 values derived through the
  Stage 5 matrix correlation theorem.
- `singlet_bell_original_strict_violation` and
  `singlet_violates_bell_original`: actual Stage 6 premise-free numerical
  reversal and negated equation-(15) bound.
- `singletCorrelations_incompatible_with_perfectAnticorrelationAt_bellB`:
  actual Stage 6 direct assumption-separated bridge.
- `singletCorrelations_incompatible_with_deterministicLocalModel_at_bellDirections`,
  `no_deterministicLocalModel_reproduces_singletCorrelations_at_bellDirections`,
  and `no_deterministicLocalModel_reproduces_singletCorrelation`: actual
  Stage 6 finite and global correlation non-reproduction results.
- `IsBoundedByOne`, `IsAEBoundedByOne`, their Alice/Bob setting-wise variants,
  and binary-to-bounded bridges: actual Stage 7 bounded effective-response API.
- `boundedProduct_integrable`, `bounded_response_bell_pointwise`, and
  `bounded_response_bell_robust`: actual Stage 7 integrability, scalar, and
  arbitrary-probability-measure robust inequalities for responses bounded by
  one.
- `UniformlyWithinOn` and `UniformlyWithinOn.trans_add`: actual Stage 7 uniform
  absolute-error predicate on explicit setting domains and exact radius
  addition.
- `target_bell_robust_of_four_errors`: actual Stage 7 target-agnostic transfer
  from four fixed errors to the coefficient `4*eta`.
- `unitDirectionSet`, `singlet_uniform_error_constant_pos`,
  `singlet_four_mul_error_lower_bound_at_bellDirections`,
  `singlet_error_lower_bound_at_bellDirections`, and
  `singlet_uniform_error_lower_bound_on_unitDirections`: actual Stage 7
  physical-domain and numerical singlet lower bounds.
- `bell1964_four_mul_total_error_lower_bound`,
  `bell1964_epsilon_lower_bound_of_uniform_averaging_errors`, and
  `bell1964_epsilon_pos_of_uniform_averaging_errors`: actual Stage 7 abstract
  equation-(16)–(22) triangle, solved lower bound, and positivity result.
- `chshCombination`, `bounded_response_chsh_pointwise`, and
  `bounded_response_chsh`: actual Stage 8 target-agnostic CHSH expression,
  scalar inequality, and arbitrary-probability-measure bounded-response theorem
  for four fixed responses.
- `target_chsh_of_four_errors`: actual Stage 8 transfer from four fixed
  correlation errors to `|CHSH(target)| <= 2 + 4 * epsilon`.
- `chshBobMinus`, its unit-norm/inner-product theorems,
  `singlet_chsh_combination`, `singlet_chsh_abs_value_eq_two_mul_sqrtTwo`,
  `singlet_chsh_strict_violation`, and `singlet_violates_chsh`: actual Stage 8
  explicit geometry and matrix-derived singlet CHSH calculation.
- `singlet_chsh_error_lower_bound_at_directions`,
  `singletCorrelations_incompatible_with_boundedLocalModel_at_chshDirections`,
  and `no_boundedLocalModel_reproduces_singletCorrelation_via_chsh`: actual
  Stage 8 finite error obstruction and finite/global correlation
  non-reproduction results for bounded local responses.
- `angular_average_factorization` and
  `bell1964_smoothed_nonapproximation`: deferred names for a possible optional
  instantiation of Bell's literal averaging construction; no such declaration
  is currently implemented or claimed.

The final `PaperMap` documentation should associate equations (1)-(22) with
these declarations and distinguish exact matches, modern reformulations,
corrections, optional illustrations, and non-formalized interpretation.

## Stages

### 1-GUARDRAILS — Complete (2026-07-17)

#### Big Picture Objective

Establish the source baseline, exact claim inventory, scope boundaries, and
audit conventions before writing Lean code.

#### Detailed Implementation Plan

- Compare the Markdown transcription against all six PDF page scans for every
  equation and symbol used by the core proof.
- Turn the preliminary paper map and correction log above into versioned
  project documentation, adding page/equation references and unresolved items.
- Specify four quantifier levels used throughout: pointwise, setting-wise a.e.,
  expectation, and uniform over settings.
- Define the boundary between verified mathematics and historical/physical
  interpretation.
- Specialize the generic `BUILD-PLAN.md` commands in the stage record without
  yet implementing mathematical declarations.

#### Completion Requirements

- A page-checked source/claim map covers equations (1)-(22) and Sections V-VI.
- Every preliminary correction is confirmed, revised, or marked unresolved
  with evidence.
- The stage record lists forbidden shortcuts and exact future audit scans.
- Documentation explicitly states that deterministic local factorization and
  measurement-setting independence are assumptions, not one vague doctrine.
- `git diff --check` passes and no Lean proof is claimed at this stage.

Completion evidence and exact audit results are recorded in
`goal-1/1-GUARDRAILS.md`.

### 2-BOOTSTRAP — Complete (2026-07-17)

#### Big Picture Objective

Create the smallest pinned Lean 4/mathlib package and validate the APIs needed
for the planned representations.

#### Detailed Implementation Plan

- Select and record compatible pinned Lean and mathlib revisions.
- Add the minimal Lake package, toolchain file, root namespace/module, and CI or
  reproducible build instructions appropriate to this repository.
- Run narrow compile probes for probability measures/integration, a.e. syntax,
  Euclidean three-space, matrices/complex inner products, tensor or Kronecker
  products, and `Real.sqrt` arithmetic.
- Decide the binary-outcome representation and the two-qubit representation
  from compiled evidence; document rejected alternatives and dependency costs.
- Establish module layering and naming conventions.

#### Completion Requirements

- `lean --version` and `lake --version` report the recorded pinned toolchain.
- A clean `lake build` succeeds with only minimal non-substantive modules.
- Every proposed core dependency has a compiling import/API probe or a recorded
  replacement plan.
- The chosen representations keep abstract probability code independent of the
  quantum layer.
- Proof-hole and project-axiom scans are clean; `git diff --check` passes.

Completion evidence, exact pins, representation decisions, build output, and
audit results are recorded in `goal-1/2-BOOTSTRAP.md`.

### 3-LOCAL-MODEL — Complete (2026-07-17)

#### Big Picture Objective

Define a reusable deterministic local hidden-variable model and its correlation
without silently bundling logically distinct assumptions.

#### Detailed Implementation Plan

- Define response functions, a fixed probability measure, binary-range
  predicates, measurability/integrability lemmas, and the correlation.
- Make locality evident from function dependencies and provide named predicates
  or documentation that explain exactly what is encoded.
- Represent measurement-setting independence explicitly enough that a consumer
  cannot accidentally use a setting-indexed hidden-variable distribution.
- Define pointwise and setting-wise-a.e. perfect anticorrelation separately.
- Add finite/discrete examples only when they validate the API and connect
  cleanly to the general measure formulation.

#### Completion Requirements

- Each assumption named in the objective is independently visible in public
  theorem signatures or structures.
- Correlations are proved measurable/integrable and bounded in `[-1,1]` under
  the stated hypotheses.
- Tests/examples cover a finite hidden-variable space and a general measure
  signature.
- No theorem changes a.e. quantifier order; dedicated negative/documentation
  checks show the distinction.
- Focused module builds, `lake build`, proof-hole/axiom scans, and
  `git diff --check` pass.

Completion evidence, public declaration inventory, finite/general examples,
quantifier audit, build results, and exact axiom output are recorded in
`goal-1/3-LOCAL-MODEL.md`.

### 4-BELL-BOUND — Complete (2026-07-17)

#### Big Picture Objective

Prove Bell's exact abstract inequality and the precise bridge from perfect
correlation to setting-wise almost-everywhere anticorrelation.

#### Detailed Implementation Plan

- Prove that binary product expectation `-1` forces product `-1` a.e., using
  normalization and nonnegativity explicitly.
- Convert that result to `A s = -B s` a.e. for one fixed setting.
- Combine only the finitely many null sets needed for a fixed triple.
- Prove the pointwise algebraic bound and integrate it to obtain equation (15).
- Offer a theorem taking perfect anticorrelation directly and a corollary taking
  exact diagonal correlations, so assumption flow remains visible.

#### Completion Requirements

- The public theorem proves
  `abs (P a b - P a c) <= 1 + P b c` with no quantum assumptions.
- A declaration-by-declaration note maps equations (12)-(15) to Lean.
- Tests instantiate nontrivial finite models and boundary/equality cases.
- Inspection confirms that no global common null set or hidden continuity
  premise was introduced.
- `#print axioms` for main results is recorded and understood; focused/full
  builds, hole/shortcut scans, and `git diff --check` pass.

Completion evidence, exact theorem signatures, finite and adversarial models,
failure-driven corrections, import/quantifier scans, and axiom output are
recorded in `goal-1/4-BELL-BOUND.md`.

### 5-SINGLET — Complete (2026-07-17)

#### Big Picture Objective

Derive the singlet-state correlation from explicit finite-dimensional quantum
objects in a module independent of the hidden-variable inequality.

#### Detailed Implementation Plan

- Define Pauli matrices, directional spin observables, the two-qubit space, and
  a normalized singlet state or density matrix using the selected mathlib APIs.
- Prove Hermitian/normalization facts needed by the expectation calculation.
- Calculate the tensor-product observable expectation componentwise or through
  reusable Pauli identities.
- Translate the coordinate expression to the real Euclidean inner product.
- Keep unit-vector restrictions explicit and document whether the algebraic
  identity itself holds for arbitrary real vectors.

#### Completion Requirements

- `singlet_spin_correlation` derives `-(a dot b)` and does not assume that
  formula or import the Bell inequality.
- Basis, complex-conjugation, tensor ordering, and inner-product conventions are
  documented and covered by simple basis-direction checks.
- The singlet state normalization and observable definitions compile without
  unexplained axioms.
- Focused quantum builds, full build, `#print axioms`, proof-hole scans, and
  `git diff --check` pass.

Completion evidence, exact conventions, declaration inventory, direct basis
checks, dependency scans, failure-driven corrections, and axiom output are
recorded in `goal-1/5-SINGLET.md`.

### 6-VIOLATION — Complete (2026-07-17)

#### Big Picture Objective

Construct explicit unit measurement directions and combine the independent
abstract and quantum results into a formal contradiction.

#### Detailed Implementation Plan

- Define concrete vectors `a`, `b`, and `c` in real three-space.
- Prove their norms, dot products, and all `sqrt(2)` positivity/nonzero facts.
- Rewrite the abstract Bell inequality using the singlet correlation theorem.
- Close the resulting real-arithmetic contradiction.
- Expose both a numerical violation lemma and a no-model corollary whose
  assumptions enumerate locality/determinism, setting independence,
  normalization, and reproduction.

#### Completion Requirements

- Lean proves the directions are unit vectors and have exactly the advertised
  inner products.
- A theorem shows the singlet predictions violate equation (15).
- A separate corollary states that no model satisfying the enumerated
  assumptions reproduces the required finite set of correlations.
- No philosophical/signaling conclusion is embedded in either statement.
- Focused/full builds, `#print axioms`, hole/shortcut scans, and
  `git diff --check` pass.

Completion evidence, exact theorem signatures, assumption-flow audit,
direction/source clarification, build output, scan classifications, and axiom
results are recorded in `goal-1/6-VIOLATION.md`.

### 7-ROBUSTNESS — Complete (2026-07-17)

#### Big Picture Objective

State and, if practical, prove the paper's quantitative non-approximation result
with a precise approximation notion and all averaging hypotheses exposed.

#### Detailed Implementation Plan

- First prove the algebraic/integral robust inequality for response functions
  bounded in `[-1,1]`.
- Derive the explicit error lower bound at Bell's three directions.
- Decide whether the core result should use a direct uniform correlation error
  or Bell's independently smoothed responses; prove the clean general theorem
  first.
- If formalizing angular smearing, define setting-space neighborhood probability
  measures and discharge measurability, product/iterated integration, Fubini,
  and the uniform `delta` approximation obligation.
- State exactly which pointwise, uniform, or averaged approximation modes are
  and are not ruled out.

#### Completion Requirements

- Either a compiled theorem gives an explicit positive uniform error lower
  bound, or a documented deferment identifies the smallest unresolved mathlib
  or mathematical obligation and does not claim completion of this scope item.
- Any theorem corresponding to (16)-(22) includes normalization,
  bounded-response, independence, measurability, and uniform quantifiers.
- Constants are checked at the explicit directions, including the condition on
  `delta` needed for positivity.
- Documentation does not generalize the result to unsupported approximation
  topologies.
- Relevant focused/full builds, axiom/hole scans, and `git diff --check` pass.

Completion evidence, exact theorem signatures, equation mapping, assumption
and quantifier audits, angular-smearing deferment, build/scan results, and axiom
output are recorded in `goal-1/7-ROBUSTNESS.md`.

### 8-EXAMPLES — Complete (2026-07-17)

#### Big Picture Objective

Add only those illustrations and modern generalizations that materially improve
understanding or reuse of the verified core.

#### Detailed Implementation Plan

- Evaluate the value of a finite/discrete explanatory model, Bell's uniform
  sphere sign model, the single-particle model, a stochastic-model reduction,
  CHSH-style corollaries, and the higher-dimensional embedding.
- Prioritize small corollaries over expensive measure-geometry developments.
- For every sign model, make the function total and prove zero-boundary sets are
  null before ignoring their chosen value in expectations.
- For every generalization, state the logical bridge to the core and avoid
  presenting a special case as a stronger result.

#### Completion Requirements

- Each included example has a documented consumer or explanatory purpose and
  compiles in a leaf module.
- Formulae corresponding to (4)-(11), if included, are independently checked at
  endpoints and exceptional sets.
- Deferred illustrations are listed with reasons; none blocks the minimum core.
- Added generalizations preserve explicit assumption boundaries.
- Focused/full builds, axiom/hole scans, and `git diff --check` pass.

Completion evidence, exact theorem signatures, source/API selection, deferment
obligations, assumption-flow audit, build failures and corrections, scan
classifications, and axiom output are recorded in `goal-1/8-EXAMPLES.md`.

### 9-RELEASE-AUDIT

#### Big Picture Objective

Turn the checked development into a reusable, reproducible library with a
complete paper/declaration map and final axiom/correction audit.

#### Detailed Implementation Plan

- Stabilize public names, module exports, docstrings, examples, and README usage.
- Complete the equation-to-declaration map and correction/unresolved log.
- Add theorem-level documentation distinguishing exact paper results, modern
  reformulations, stronger/weaker variants, and excluded interpretations.
- Run clean-checkout and incremental builds, all examples/tests, proof-hole and
  forbidden-shortcut scans, and `#print axioms` for each main result.
- Record pinned versions, commands, outputs, known limitations, and next work.

#### Completion Requirements

- The minimum core—the abstract inequality, derived singlet correlation, and
  explicit contradiction—is public, documented, and reproducibly built.
- The approximation result is either complete or precisely marked unresolved;
  the overall report does not blur that distinction.
- No `sorry`, `admit`, unexplained axiom, accidental `unsafe`, or unreviewed
  project-specific assumption remains.
- The final axiom audit is recorded for every headline theorem and contains only
  understood foundations.
- A clean `lake build`, all focused verification, documentation/link checks,
  `git diff --check`, and repository status review pass.
