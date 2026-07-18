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
  `(sqrt(2)-1)/4 <= eta`. The Stage 7 finite and uniform Lean theorems now
  compile with exactly this constant.
- `Direction` is ambient `EuclideanSpace Real (Fin 3)`, not a unit-sphere
  subtype. Bell's uniform statements range over physical unit settings, so an
  unrestricted `forall a b : Direction` predicate would be stronger and would
  compare the homogeneous singlet polynomial on nonphysical, unbounded inputs.
- Bell specifies only averaging within small angles, not a unique cap weight.
  Supported probability measures could be Dirac masses; removing isolated
  exceptions additionally requires atomless or suitably surface-continuous
  averaging.

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
  error on explicitly supplied setting sets, with an explicitly nonnegative
  radius. Instantiate both sets with the unit-direction set. Do not describe
  the theorem as an unrestricted ambient-vector, `L^p`,
  almost-everywhere-in-settings, or arbitrary-topology result.
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
  proof obligations remain proportionate. A claim that isolated points are
  removed also needs atomless or surface-absolutely-continuous kernels. Since
  Bell leaves the weights unspecified, otherwise record the precise deferment
  after delivering the clean bounded-response obstruction.

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
  sup-error predicate on explicit setting sets for two setting-indexed real
  functions and proving
  reflexivity/symmetry or triangle-addition only where consumed.
- Add `Bell.Inequality.Robust` as a theorem leaf importing only abstract
  hidden-variable modules. Prove the bounded-response integral inequality and
  a four-fixed-errors target theorem; import no quantum or Euclidean geometry.
- Add `Bell.Geometry.RobustViolation` as the integration leaf. Define the unit
  direction set and prove the Stage 6 directions belong to it. Prove the exact
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
- Inspect the uniform theorem to confirm that its quantifier is `forall a in
  unitDirections, forall b in unitDirections` outside any hidden-variable a.e.
  statement and that the radius is explicitly nonnegative.
- Do not claim literal angular averaging, Fubini factorization, or a sphere
  neighborhood error unless those constructions and hypotheses are actually
  defined and proved.
- Scan new Lean code for binary assumptions disguised as boundedness,
  setting-indexed hidden measures, target/bound-as-premise shortcuts, physical
  interpretation claims, proof holes, `opaque`, `unsafe`, `native_decide`, and
  unexplained axioms.

## Completion Requirements

- [x] A public general-measure theorem proves the robust Bell inequality for
  measurable responses bounded by one, with normalization and every fixed
  setting assumption explicit.
- [x] A public target-agnostic theorem converts four fixed correlation-error
  bounds into the exact `4*eta` robust target inequality.
- [x] A reusable uniform-error predicate and triangle-addition lemma precisely
  model equations (16)–(18), with setting domains explicit.
- [x] A compiled singlet theorem proves
  `(sqrt(2)-1)/4 <= eta`, and a separate theorem proves this constant positive.
- [x] A compiled `epsilon`/`delta` corollary yields
  `(sqrt(2)-1)/4-delta <= epsilon` under the explicitly stated uniform bounds.
- [x] The documentation states whether equations (19)–(20) are represented by
  a generic bounded local model or derived from concrete angular averages, and
  lists every deferred smearing obligation without claiming it proved.
- [x] The public theorem conclusions contain no philosophical, signaling, or
  unsupported approximation-topology claim.
- [x] Focused builds, adjacent public/audit builds, and the default full build
  succeed.
- [x] `#print axioms` for bounded integrability, robust inequality, uniform
  triangle, numerical lower bound, and `epsilon`/`delta` headline results
  reports only understood Lean/mathlib foundations.
- [x] Proof-hole, target-as-premise, import-boundary, boundedness, quantifier,
  smearing-claim, interpretation, and whitespace scans pass with every
  documentation-only hit classified.
- [x] Exact results, failures, source corrections/deferments, theorem mapping,
  and remaining uncertainty are recorded here and folded into `0-plan.md`.

## Stage Results

Stage 7 completed on 2026-07-17.

### Implemented surface and dependency structure

- `Bell.HiddenVariable.Bounded` is a low-dependency public API/proof leaf. It
  adds `IsBoundedByOne`, `IsAEBoundedByOne`, Alice/Bob setting-wise variants,
  pointwise/a.e. binary-to-bounded bridges, and
  `boundedProduct_integrable`. Pointwise and a.e. notions remain distinct.
- `Bell.Approximation.Uniform` is a target-agnostic public API leaf. Its
  `UniformlyWithinOn s t f g epsilon` records `0 <= epsilon` and a pointwise
  absolute-error bound on the explicit product domain `s × t`.
  `UniformlyWithinOn.trans_add` is the exact equation-(16)+(17) triangle step.
- `Bell.Inequality.Robust` is the abstract public theorem leaf. It imports only
  hidden-variable modules and proves:
  - `bounded_response_bell_pointwise`;
  - `bounded_response_bell_robust`, the normalized arbitrary-measure result
    `|P(a,b)-P(a,c)| <= 2+P(b,c)+P(b,b)`; and
  - `target_bell_robust_of_four_errors`, which transfers four radius-`eta`
    errors to the exact `4*eta` target inequality.
- `Bell.Geometry.RobustViolation` is the public integration leaf. It adds
  `unitDirectionSet`, membership proofs for the three Bell directions, the
  exact scale and positivity facts, finite and unit-domain singlet lower
  bounds, and the equation-(22) `epsilon`/`delta` corollaries.
- `Bell.Audit.Robust` is diagnostic and is deliberately not re-exported. It
  checks the public root, a normalized one-point model with responses
  `1/2` and `-1/2` that is provably nonbinary, a sharp scalar case, the
  binary-to-bounded bridge, exact uniform-error addition, the physical setting
  domain, theorem signatures, and axioms.
- `Bell.lean` remains a thin umbrella and now re-exports only the stable Stage 7
  leaves. The audit leaf remains outside the public root.

The focused modules were built separately before the umbrella was changed.
The high-fanout pre-existing hidden-variable, quantum, and exact-violation
leaves were not edited for this stage.

### Checked mathematical mapping

- Equations (16)–(18) are represented by two
  `UniformlyWithinOn unitDirectionSet unitDirectionSet` hypotheses and
  `trans_add`. The quantifiers are pointwise over unit settings and outside all
  hidden-variable a.e. statements.
- Equations (19)–(20) are represented at the algebraic endpoint by a fixed
  normalized factorized model with real responses bounded by one a.e. The
  averaged responses are not asserted to be binary. This stage does **not**
  derive those responses from angular kernels.
- The pointwise cancellation independently checks to
  `|Aa*Bb-Aa*Bc| <= (1+Ab*Bc)+(1+Ab*Bb)`. Both bracket factors are proved
  nonnegative from the absolute-value bounds before multiplicative absolute
  values are removed. Integration uses four fixed a.e. bounds only.
- Four target errors give
  `|Q(a,b)-Q(a,c)| <= 2+Q(b,c)+Q(b,b)+4*eta`. Substitution of the Stage 6
  matrix-derived singlet values gives `sqrt(2)-1 <= 4*eta`, hence
  `(sqrt(2)-1)/4 <= eta`.
- Taking `eta=epsilon+delta` gives
  `(sqrt(2)-1)/4-delta <= epsilon`; the separate positivity theorem assumes
  `delta < (sqrt(2)-1)/4`.
- In the two-error theorems, `averagedTarget` denotes the averaged quantum
  correlation (equivalently, the negative averaged dot product under Bell's
  convention), not the positive averaged dot product.

### Precise deferment of literal angular smearing

Bell does not specify unique weights inside an angular neighborhood. Therefore
this stage does not silently choose a cap distribution or claim equation (19)
as a proved Fubini factorization. A later literal construction would require:

- center-indexed Alice and Bob probability measures depending only on their
  respective local center settings;
- product independence of the two setting averages and independence from the
  one fixed hidden-variable measure;
- probability normalization, unit-sphere/cap support, and a proved uniform
  `delta` estimate for the calculated singlet correlation;
- joint setting/hidden-variable measurability or sufficient product
  integrability, followed by the required Fubini/Tonelli interchange;
- a proof that the averaged raw local correlation equals the correlation of
  the two bounded effective responses; and
- atomlessness or surface absolute continuity if the historical prose claim
  that isolated exceptional settings are washed out is retained. Arbitrary
  supported measures include Dirac measures and do not prove that claim.

Thus the compiled result is a uniform non-approximation theorem for any
bounded effective factorized responses on unit directions. It is not a theorem
about pointwise, setting-a.e., `L^p`, or every possible approximation topology,
and it is not a construction of Bell's unspecified angular averages.

### Verification evidence

Focused builds during construction succeeded as follows:

```text
cd formal
lake build Bell.HiddenVariable.Bounded       # 2,510 jobs
lake build Bell.Approximation.Uniform        #   765 jobs
lake build Bell.Inequality.Robust            # 2,512 jobs
lake build Bell.Geometry.RobustViolation     # 2,551 jobs
lake build Bell.Audit.Robust Bell            # 2,554 jobs
```

The final aggregate focused command

```text
lake build Bell.HiddenVariable.Bounded Bell.Approximation.Uniform \
  Bell.Inequality.Robust Bell.Geometry.RobustViolation \
  Bell.Audit.Robust Bell
```

succeeded with 2,554 jobs. The default `lake build` succeeded with 2,553 jobs.

Every Stage 7 headline `#print axioms` in `Bell.Audit.Robust` reports exactly:

```text
[propext, Classical.choice, Quot.sound]
```

These are understood Lean/mathlib foundations; no project-specific axiom was
introduced.

The final Lean proof-hole/escape scan found no `sorry`, `admit`, declaration
`axiom`, `unsafe`, `opaque`, or `native_decide`. Import-boundary scans found no
quantum, geometry, or umbrella import in `Bounded`, `Uniform`, or `Robust`.
The robust leaf contains no binary, perfect-anticorrelation, singlet, quantum,
or geometry reference. Target-shortcut and physical-interpretation scans had
no hits. The fixed-measure scan found only the stored measure in
`HiddenVariable.Basic` and ordinary uses of that same measure in the robust
integrals. The quantifier scan confirms explicit unit-set quantifiers and
setting-wise a.e. predicates. The only smearing scan hits in Lean are docstrings
that explicitly disclaim a cap construction and Fubini derivation.
`git diff --check` passed.

One audit build initially failed because the opaque uniform predicate preserved
the radius expression `1+1` rather than reducing it definitionally to `2` under
`simpa`. The diagnostic was corrected to state the exact additive radius
`(1 : Real)+1`; this changed no theorem or constant. The rebuilt audit passed.

Stage 8 (`8-EXAMPLES`) is the next incomplete stage. Literal angular averaging
remains an explicit optional future construction rather than hidden unfinished
work in this completed bounded-response stage.
