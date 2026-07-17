# 7-ROBUSTNESS

## Current Facts

- Stages 1–6 are complete. The Stage 6 plan/result documents remain existing
  workspace changes and will be preserved while this stage proceeds.
- The pinned baseline command
  `cd formal && lake build Bell.Inequality.Original Bell.Geometry.Violation
  Bell` succeeds with 2,549 graph jobs.
- Bell's equation (16) is a uniform bound between an independently averaged
  local correlation and an independently averaged quantum correlation.
  Equation (17) is a second uniform bound between that averaged quantum
  correlation and the point singlet target; their triangle inequality gives
  the total radius `epsilon+delta` in equation (18).
- Equation (19) factors the averaged local correlation through response
  averages. Equation (20) gives only `abs Abar <= 1` and `abs Bbar <= 1`; the
  averaged responses are generally not binary.
- For arbitrary real responses bounded by one, Bell's displayed cancellation
  is pointwise valid and gives the expectation inequality
  `|P(a,b)-P(a,c)| <= 2+P(b,c)+P(b,b)`. This is equivalent to Bell's next line
  after using the diagonal error bound (21).
- If a bounded local correlation is uniformly within `eta` of a target `Q` at
  the four pairs `(a,b)`, `(a,c)`, `(b,b)`, and `(b,c)`, the preceding bound
  implies
  `|Q(a,b)-Q(a,c)| <= 2+Q(b,c)+Q(b,b)+4*eta`.
- At the Stage 6 singlet values this becomes
  `sqrt(2)-1 <= 4*eta`, hence
  `(sqrt(2)-1)/4 <= eta`. These calculations are independently checked at the
  paper-mathematics level but remain planning facts until the Stage 7 Lean
  leaves compile.

## Updated Assumptions

- Reuse `DeterministicLocalModel` as the factorized response interface because
  its real-valued responses already admit averages in `[-1,1]`. Introduce
  bounded-response predicates separately; do not weaken or redefine the
  existing binary predicates.
- Keep probability normalization, response measurability, a.e. boundedness,
  and uniform approximation as separate assumptions. Deterministic response
  arities and the single fixed measure continue to encode local response
  dependence and measurement-setting independence structurally.
- Define the approximation mode as a uniform pointwise-in-settings absolute
  error with an explicitly nonnegative radius. Do not describe the theorem as
  an `L^p`, almost-everywhere-in-settings, or arbitrary-topology result.
- First prove a target-agnostic robust inequality using only four fixed error
  bounds, then specialize a global uniform predicate to the calculated singlet
  correlation and the Stage 6 directions.
- Model equations (16)–(18) with a generic uniform-error triangle lemma. An
  `epsilon`/`delta` corollary may then state Bell's exact constant without
  pretending that a concrete angular averaging kernel has already been built.
- Literal equations (16)–(19) with sphere neighborhoods require setting-indexed
  probability kernels, normalization, joint setting/hidden-variable
  measurability or suitable iterated measurability, and Fubini/Tonelli. The
  current model deliberately supplies only setting-wise hidden-variable
  measurability. Formalize that construction only if the additional API and
  proof obligations remain proportionate; otherwise record the precise
  deferment after delivering the stronger clean bounded-response obstruction.

## Big Picture Objective

Formalize Bell's quantitative non-approximation core as a reusable
measure-theoretic theorem for local responses bounded in `[-1,1]`, give its
precise uniform-correlation specialization to the calculated singlet target,
check the constant `(sqrt(2)-1)/4`, and state exactly which part of Bell's
literal angular-smearing construction is or is not formalized.

## Detailed Implementation Plan

- Add a low-dependency bounded-response leaf defining pointwise and a.e.
  `abs <= 1` predicates, Alice/Bob setting-wise variants, binary-to-bounded
  bridges, and only the integrability/range facts consumed by the robust
  inequality.
- Add a target-agnostic uniform-approximation leaf defining a nonnegative
  sup-error predicate for two setting-indexed real functions and proving
  reflexivity/symmetry or triangle-addition only where consumed.
- Add `Bell.Inequality.Robust` as a theorem leaf importing only abstract
  hidden-variable modules. Prove the bounded-response integral inequality and
  a four-fixed-errors target theorem; import no quantum or Euclidean geometry.
- Add `Bell.Geometry.RobustViolation` as the integration leaf. Prove the exact
  `sqrt(2)` scale identity, the positive lower-bound constant, a finite-setting
  singlet error bound, a global uniform-error corollary, and the
  `epsilon`/`delta` form corresponding to equation (22).
- Add a non-exported `Bell.Audit.Robust` leaf checking theorem signatures,
  binary-to-bounded specialization, boundary/equality arithmetic, positivity,
  and `#print axioms` output.
- Re-export only the stable bounded, uniform, robust-inequality, and robust
  geometric leaves from `Bell.lean` after their focused builds pass.
- If literal angular smearing is deferred, document the smallest missing
  structures and hypotheses; do not expose a declaration whose premise simply
  assumes equation (19) and advertise it as a derivation of (19).

Expected files:

```text
formal/Bell/HiddenVariable/Bounded.lean
formal/Bell/Approximation/Uniform.lean
formal/Bell/Inequality/Robust.lean
formal/Bell/Geometry/RobustViolation.lean
formal/Bell/Audit/Robust.lean
formal/Bell.lean
goal-1/7-ROBUSTNESS.md
goal-1/0-plan.md
```

Intended focused build sequence:

```text
cd formal
lake build Bell.HiddenVariable.Bounded
lake build Bell.Approximation.Uniform
lake build Bell.Inequality.Robust
lake build Bell.Geometry.RobustViolation
lake build Bell.Audit.Robust Bell
lake build
```

## No-Cheating Checks

- Inspect the robust pointwise identity and integral proof; do not assume the
  displayed robust Bell bound as a theorem hypothesis.
- Confirm every integrand comparison uses both nonnegativity of
  `1+A(b)B(c)`/`1+A(b)B(b)` and `abs` bounds before dropping multiplicative
  factors.
- Keep a.e. boundedness setting-wise and combine only the finite settings used
  by each theorem. Do not construct a common null set over all directions.
- Derive the uniform target theorem from four named error inequalities and the
  abstract robust model inequality. Do not specialize to singlet geometry in
  the abstract inequality leaf.
- Derive all singlet values through the existing Stage 5/6 theorems, and derive
  the numerical constant from the explicit Stage 6 geometry. Do not define the
  target as `-inner` inside the approximation theorem.
- Inspect the global uniform theorem to confirm that its quantifier is
  `forall a b` outside any hidden-variable a.e. statement and that the radius
  is explicitly nonnegative.
- Do not claim literal angular averaging, Fubini factorization, or a sphere
  neighborhood error unless those constructions and hypotheses are actually
  defined and proved.
- Scan new Lean code for binary assumptions disguised as boundedness,
  setting-indexed hidden measures, target/bound-as-premise shortcuts, physical
  interpretation claims, proof holes, `opaque`, `unsafe`, `native_decide`, and
  unexplained axioms.

## Completion Requirements

- [ ] A public general-measure theorem proves the robust Bell inequality for
  measurable responses bounded by one, with normalization and every fixed
  setting assumption explicit.
- [ ] A public target-agnostic theorem converts four fixed correlation-error
  bounds into the exact `4*eta` robust target inequality.
- [ ] A reusable uniform-error predicate and triangle-addition lemma precisely
  model equations (16)–(18).
- [ ] A compiled singlet theorem proves
  `(sqrt(2)-1)/4 <= eta`, and a separate theorem proves this constant positive.
- [ ] A compiled `epsilon`/`delta` corollary yields
  `(sqrt(2)-1)/4-delta <= epsilon` under the explicitly stated uniform bounds.
- [ ] The documentation states whether equations (19)–(20) are represented by
  a generic bounded local model or derived from concrete angular averages, and
  lists every deferred smearing obligation without claiming it proved.
- [ ] The public theorem conclusions contain no philosophical, signaling, or
  unsupported approximation-topology claim.
- [ ] Focused builds, adjacent public/audit builds, and the default full build
  succeed.
- [ ] `#print axioms` for bounded integrability, robust inequality, uniform
  triangle, numerical lower bound, and `epsilon`/`delta` headline results
  reports only understood Lean/mathlib foundations.
- [ ] Proof-hole, target-as-premise, import-boundary, boundedness, quantifier,
  smearing-claim, interpretation, and whitespace scans pass with every
  documentation-only hit classified.
- [ ] Exact results, failures, source corrections/deferments, theorem mapping,
  and remaining uncertainty are recorded here and folded into `0-plan.md`.

## Stage Results

- In progress. Fill this section only from checked Stage 7 evidence.
