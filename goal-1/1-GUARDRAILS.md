# 1-GUARDRAILS

## Current Facts

- Stage started and completed on 2026-07-17.
- The repository was clean at stage start and contained no Lean toolchain,
  Lake package, Lean file, test, or prior stage record.
- The primary scan is `bell-1964/bell-1964.pdf`, SHA-256
  `bb889c2f4909269f58d65662e232df2f5c7a5217829b388ac5a5eb9416d1d9b6`.
- `pdfinfo` reports six unencrypted pages. The printed page range is 195–200.
- The transcription is `bell-1964/bell-1964.md`. All six scan pages were
  visually inspected at high resolution against it.
- Numbered equations (1)–(22), the unnumbered algebra between them, Sections
  V–VI, and the references relevant to the claims were checked against the
  scan. The transcription accurately records the mathematical notation except
  where it intentionally repairs the printed typo in (9), now disclosed in a
  transcription note.
- The transcription formerly linked to six absent JPEG files. It now links to
  the actual six-page PDF instead.
- Stage 1 is documentary and diagnostic. It proves no Lean theorem and claims
  no machine-checked mathematical result.

## Updated Assumptions

### Assumptions that still look valid

- An arbitrary probability measure is a cleaner generalization of Bell's
  density notation `rho(lambda) d lambda`.
- Abstract settings should remain polymorphic; only the quantum layer needs
  unit vectors in real three-space.
- Separate response functions encode the deterministic remote-setting
  independence used in Bell's proof, while one fixed hidden-variable measure
  encodes measurement-setting independence.
- The exact Bell inequality should be proved before the quantum calculation,
  and the quantum calculation should not import or assume the inequality.
- A robust bounded-response theorem is likely a cleaner reusable basis for the
  paper's smoothed non-approximation argument.

### Assumptions revised by the source audit

- Equation (9) is not literally transcribed in normalized notation. The scan's
  second line has `B(a,b)`, a typographical error; the intended left side is
  `B(b,lambda)`.
- The instruction “rotate towards” in the construction around (6), and again
  in the later nonlocal illustration, is not valid for all angles. For an
  obtuse original angle `theta`, the required
  `theta' = (pi/2) * (1 - cos theta)` exceeds `theta`, so the direction must
  move away from the reference vector. Only existence of a direction with the
  prescribed angle should be formalized.
- Bell's approximation conclusion must not be summarized as excluding every
  approximation topology. The displayed argument concerns a uniform bound on
  independently averaged correlations, plus a uniform averaging error.

### Assumptions requiring compiled or formal tests later

- Whether a custom sign type or real-valued responses with a binary predicate
  yields the best public API.
- The exact mathlib representation of complex two-qubit states, Pauli
  observables, tensor products, and expectations.
- The availability and usability of sphere-neighborhood probability measures
  for a literal angular-smearing instantiation.
- The best theorem factorization for deriving setting-wise a.e. perfect
  anticorrelation from an extremal expectation.

## Big Picture Objective

Establish a page-checked source baseline, an exact claim inventory, explicit
logical and quantifier boundaries, and verification rules before any Lean
implementation begins.

## Detailed Implementation Plan

- Render and visually inspect all six PDF pages against the Markdown source.
- Map every numbered equation and Sections V–VI to its role, correction status,
  and intended formal disposition.
- Review every preliminary correction in `0-plan.md` and record evidence.
- State the project's quantifier vocabulary and the forbidden a.e. inference.
- Separate verified mathematical targets, optional mathematical examples, and
  historical/physical interpretations.
- Record stage-specific and future Lean audit commands.
- Repair only source-document issues discovered during the audit; do not add a
  Lean toolchain, declarations, or proofs.

## Source and Claim Map

“Checked” below means checked against the printed scan and audited at the
paper-mathematics level. It does not mean formally proved in Lean.

| Locus | Page | Scan-checked content | Formal disposition |
| --- | ---: | --- | --- |
| Sec. I | 195 | Locality is described as remote operations not affecting a result; the paper announces incompatibility with exact quantum statistics. | Historical motivation. Do not treat the prose as a complete formal definition of relativistic locality. |
| Sec. II before (1) | 195 | Singlet perfect anticorrelation plus remote-setting independence motivates predetermination. | Determinism is an explicit core model assumption. A separate EPR-style derivation would require additional interpretative premises and is outside the Bell core. |
| (1) | 196 | `A(a,lambda)=±1`, `B(b,lambda)=±1`. | Binary deterministic response functions. Local response arity must remain visible. |
| (2) | 196 | `P(a,b)=integral rho A(a)B(b)`. | Define correlation over an arbitrary fixed probability measure. Add measurability and integrability hypotheses; do not require a density. |
| (3) | 196 | Singlet prediction `-(a dot b)`. | Derive independently from explicit finite-dimensional quantum objects. |
| (4) | 196 | Single-particle outcome `sign (lambda dot a')`. | Optional example. Make sign total and isolate the zero set. |
| (5) | 196 | Hemisphere average `1-2 theta'/pi`. | Optional sphere-geometry theorem; requires a normalized surface measure and angle range. |
| (6) | 196 | Choose `theta'` so `1-2 theta'/pi=cos theta`. | The scalar relation is consistent for `theta,theta'` in `[0,pi]`; the accompanying “towards” prescription fails for obtuse `theta`. Formalize existence, not that prose direction. |
| (7) | 196 | The constructed mean is `cos theta`. | Optional consequence of (5)–(6). |
| (8) | 197 | Diagonal anticorrelation, reversed-setting correlation, and orthogonal zero correlation. | Optional finite constraints used to explain why a few qualitative predictions do not suffice. |
| (9) | 197 | Uniform-sphere sign responses. The scan prints malformed `B(a,b)` on the second left side. | Correct to `B(b,lambda)` with an explicit editorial note. Make sign-at-zero total and prove it is expectation-irrelevant. |
| (10) | 197 | `P(a,b)=-1+(2/pi) theta`. | Optional checked target for the sphere model, including `theta=0,pi/2,pi` endpoints. |
| (11) | 197 | Isotropic product-state mixture gives `-(1/3)(a dot b)`. | Optional quantum example; not needed by the core theorem. |
| Unnumbered after (11) | 197 | A remote-setting-dependent response can reproduce (3), using the same prescribed-angle relation. | Optional nonlocal counterexample. The second “towards” instruction has the same obtuse-angle defect as (6). |
| (12) | 197 | `integral rho=1`. | Probability normalization, preferably `[IsProbabilityMeasure mu]`, must be explicit. |
| (13) | 197 | Extremal diagonal correlation implies `A(a)=-B(a)` outside a null set. | Prove for each fixed setting. Requires binary range, measurability/integrability, and normalization. Do not exchange the setting and a.e. quantifiers. |
| (14) | 197 | Substitute perfect anticorrelation to rewrite `P(a,b)` as `-E[A(a)A(b)]`. | For a fixed pair, use the a.e. relation at setting `b`; for (15), relations at the finitely many needed settings suffice. |
| Unnumbered derivation | 198 | Algebraic difference identity and pointwise absolute-value estimate. | Prove first pointwise for sign-valued responses, then integrate. Track which null sets are combined. |
| (15) | 198 | `1+P(b,c) >= abs(P(a,b)-P(a,c))`. | Central abstract theorem, with no quantum or continuity assumptions. |
| Stationarity prose | 198 | Claims a generic first-order change and no stationary minimum. | Heuristic unless regularity and nonzero first variation are added. Do not expose as a theorem from (1)–(2) alone. |
| (16) | 198 | Uniform `epsilon` bound between independently averaged model and quantum correlations. | Later robustness theorem. Define averaging kernels/measures and all uniform quantifiers. |
| (17) | 198 | Uniform `delta` error between averaged and point quantum dot products. | Explicit approximation hypothesis or separately proved geometric bound. |
| (18) | 198 | Triangle inequality gives total error `epsilon+delta`. | Elementary derived bound. |
| (19) | 198 | Independent averages factor into `E_lambda[Abar(a)Bbar(b)]`. | Requires fixed hidden-variable measure, independent setting averages, measurability/integrability, and a Fubini/Tonelli justification. |
| (20) | 198 | Averaged responses lie in `[-1,1]`. | Prove from normalized averaging measures and binary/bounded original responses. |
| (21) | 198 | Near-diagonal anticorrelation bounds `E[Abar(b)Bbar(b)+1]`. | The integrand is nonnegative because of (20); record that fact explicitly when removing the absolute value from (18). |
| Unnumbered robust algebra | 198–199 | Adds cancelling cross terms and bounds the difference by two nonnegative integrals. | Prove as a reusable bounded-response lemma; commutativity of real multiplication supplies the cancellation. |
| (22) | 199 | `4(epsilon+delta)` is bounded below by the three-direction expression. | Formalize with an explicit uniform-error predicate and exact constants. |
| Example after (22) | 199 | Dot products `a·c=0`, `a·b=b·c=1/sqrt(2)` give `4(epsilon+delta)>=sqrt(2)-1`. | Construct explicit unit vectors and derive `epsilon >= (sqrt(2)-1)/4-delta`; positivity needs `delta < (sqrt(2)-1)/4`. |
| Sec. V | 199 | Embed a two-dimensional singlet sector into higher-dimensional systems, extending observables by zero. | Optional generalization. State support in the selected subspace and note that extended operators also have outcome `0` off it. |
| Sec. VI | 199 | Concludes remote influence, instantaneous propagation, and non-Lorentz-invariance; discusses timing of setting choices. | Historical/physical interpretation only. These conclusions require spacetime, causal, intervention, and signaling premises absent from (1)–(22). |
| References | 200 | Sources [1]–[7]. | Bibliographic context only; no imported mathematical authority. |

## Quantifier and Equality Conventions

Future theorem statements and documentation must use these terms consistently:

1. **Pointwise in hidden variables:** `forall omega, f omega = g omega`.
   This is stronger than needed for most integral arguments.
2. **Setting-wise almost everywhere:**
   `forall s, almost_everywhere omega, f s omega = g s omega`.
   The exceptional null set may depend on `s`.
3. **In expectation:** an equality or inequality between integrals, such as
   `correlation model a b = -1`. This alone does not imply a pointwise result;
   an extremal-expectation lemma plus range and normalization assumptions is
   required.
4. **Uniform over settings:** `forall a b, abs (P a b - Q a b) <= epsilon`.
   This is stronger than pointwise convergence or an `L^p` error statement and
   is the level used in (16)–(18).

The stronger statement
`almost_everywhere omega, forall s, f s omega = g s omega` is called
**simultaneous a.e. over settings**. It does not follow from setting-wise a.e.
when the setting type is uncountable. For the fixed Bell triple, finitely many
setting-wise a.e. facts can be intersected safely.

All public results must also say whether “binary” is pointwise or a.e. The first
API experiment should prefer pointwise binary response functions and derive
a.e. consequences explicitly, unless compiled ergonomics favor a sign codomain.

## Explicit Assumption Registry

The following must never be compressed into “local realism”:

- **Determinism:** responses assign definite outcomes given a local setting and
  hidden variable.
- **Binary outcomes:** response values are exactly `-1` or `+1` (or a sign type
  with that real interpretation).
- **Local response dependence:** Alice's response has no Bob setting argument,
  and Bob's has no Alice setting argument.
- **Measurement-setting independence:** the hidden-variable probability measure
  is one fixed measure, not selected by `(a,b)`.
- **Normalization:** the hidden-variable measure has total mass one.
- **Perfect anticorrelation:** an exact, setting-wise a.e. relationship between
  the two responses, or a separately proved consequence of exact diagonal
  correlation.
- **Quantum reproduction:** a distinct equality between the model correlation
  and a quantum expectation, for specified settings or uniformly.

Local response dependence in this deterministic model is not by itself a full
formalization of relativistic locality. Measurement-setting independence is
logically independent of the response arities and must remain separately
documented even if represented structurally by a fixed measure.

## Verified-Core Boundary

### Required mathematical core

- General probability-space model and exact Bell inequality, corresponding to
  (1)–(2) and (12)–(15).
- Independent finite-dimensional derivation of (3).
- Explicit unit directions and contradiction.

### Required later if practical

- Robust uniform-error lower bound corresponding to (16)–(22).
- Literal angular averaging only if its measure-theoretic cost is justified;
  otherwise retain a clean bounded-response theorem and document the missing
  instantiation precisely.

### Optional mathematical leaves

- Examples (4)–(11), the explicitly nonlocal response, stochastic reductions,
  CHSH corollaries, and the higher-dimensional embedding in Section V.

### Prose-only unless separately formalized

- EPR's philosophical derivation of predetermination.
- Claims of influence, controllable signals, instantaneous propagation, or
  Lorentz non-invariance in Section VI.
- Experimental feasibility and historical judgments.

## No-Cheating Checks

- Do not add Lean declarations during this documentary stage.
- Do not call a scan comparison a formal proof.
- Do not normalize a printed formula silently; preserve an editorial note.
- Do not replace Bell's general hidden-variable distribution with only a finite
  sample space in the final theorem.
- Do not let a setting-indexed measure masquerade as measurement-setting
  independence.
- Do not give `A` the remote setting `b` or `B` the remote setting `a` in a
  theorem advertised as local.
- Do not convert `forall s, AE omega` to `AE omega, forall s`.
- Do not assume `P(a,a)=-1` and advertise perfect anticorrelation as pointwise.
- Do not define the singlet expectation to be `-(a dot b)` in a theorem claimed
  to calculate it.
- Do not derive Section VI's physical claims from the correlation inequality.

Future Lean scans, adapted to the source root selected in Stage 2:

```text
rg -n --glob '*.lean' '\bsorry\b|\badmit\b|^\s*axiom\b|\bunsafe\b' Bell
rg -n --glob '*.lean' 'Classical\.choice|propext|Quot\.sound' Bell
rg -n --glob '*.lean' 'Measure.*Setting|Setting.*Measure' Bell
rg -n --glob '*.lean' 'def singlet.*correlation|def quantum.*correlation' Bell
```

The second scan is diagnostic, not a ban: mathlib foundations may legitimately
use standard axioms, and `#print axioms` is authoritative. The setting/measure
and correlation scans are prompts for signature inspection, not standalone
evidence.

## Completion Requirements

- [x] A page-checked map covers equations (1)–(22), all intervening core
  algebra, Sections V–VI, and page 200 references.
- [x] Every preliminary correction is confirmed or refined below with source
  evidence; two additional mathematical/source corrections are recorded.
- [x] Quantifier levels and the forbidden a.e. quantifier exchange are explicit.
- [x] Determinism, local response dependence, measurement-setting independence,
  normalization, binary range, perfect anticorrelation, and reproduction are
  separately registered.
- [x] The verified-core/optional/interpretation boundary is explicit.
- [x] Future no-cheating checks and specialized verification commands are
  recorded.
- [x] No Lean setup, declaration, or proof was added.
- [x] Documentation/source link checks and `git diff --check` pass, as recorded
  under Stage Results.

## Correction Audit Results

| Plan item | Status after page audit | Evidence and disposition |
| ---: | --- | --- |
| 1 | Confirmed | (2) and (12), pp. 196–197, use density notation. Generalize to a probability measure. |
| 2 | Confirmed | The same `rho(lambda)` appears for every `a,b` in (2); setting independence is implicit and must be named. |
| 3 | Confirmed/refined | Predetermination is motivated on p. 195, then assumed through response functions in (1). The verified Bell theorem takes it explicitly. |
| 4 | Confirmed/refined | The paragraph after (1), p. 196, excludes remote setting arguments. Call this deterministic local response dependence, not all of relativistic locality. |
| 5 | Confirmed | The text after (13), p. 197, says “except at a set ... of zero probability” for the displayed setting. No common null set over all directions is established. |
| 6 | Confirmed | The extremal inference uses (1), (2), and (12); formalization must additionally supply measurability/integrability. |
| 7 | Confirmed | Page 198 literally reads “It follows that c is another unit vector.” Treat as “If c is another unit vector.” |
| 8 | Confirmed | The paragraph after (15), p. 198, uses “in general of order” without continuity/differentiability hypotheses. Keep it heuristic. |
| 9 | Confirmed | The averaging paragraph before (16) and assertion (19), p. 198, omit measures, measurability, and interchange-of-integral hypotheses. Add them. |
| 10 | Confirmed/refined | (16) is uniform after independent local averaging. The conclusion does not name or exclude pointwise, a.e., or general `L^p` approximation. |
| 11 | Confirmed | Substitution after (22), p. 199, gives `4(epsilon+delta)>=sqrt(2)-1`; solve explicitly and state the positivity condition on `delta`. |
| 12 | Confirmed | The paragraph after (4), p. 196, explicitly leaves sign at zero undefined and invokes probability zero. Lean must use a total sign. |
| 13 | Confirmed | Section VI, p. 199, introduces signals, instantaneous propagation, and Lorentz invariance not defined in (1)–(22). Exclude from the bare theorem. |
| 14 | Confirmed/refined | Section V, p. 199, extends operators by zero outside the selected product subspace. State support and the enlarged spectrum explicitly. |
| 15 (new) | Confirmed printed typo | The scan of (9), p. 197, prints `B(a,b)` although (1), (2), its right side, and (10) require `B(b,lambda)`. The transcription correction is now disclosed. |
| 16 (new) | Confirmed geometric defect | From (6), `theta'=(pi/2)(1-cos theta)`. For example at `theta=2pi/3`, `theta'=3pi/4>theta`, contradicting “rotation towards.” Use prescribed-angle existence instead. The later nonlocal illustration repeats the defect. |

## Specialized Build and Verification Protocol

Stage 1 has no Lean build. Its focused verification is documentary:

```text
pdfinfo bell-1964/bell-1964.pdf
pdftotext -layout bell-1964/bell-1964.pdf /tmp/bell-1964-pdf.txt
rg -n '\\tag\{([1-9]|1[0-9]|2[0-2])\}' bell-1964/bell-1964.md
rg -n '^## (I|II|III|IV|V|VI)\.' bell-1964/bell-1964.md
test "$(find . -type f -name '*.lean' | wc -l)" -eq 0
git diff --check
```

Once Stage 2 establishes the package and module names, use the smallest builds
covering a stage, provisionally:

```text
lake build Bell.HiddenVariable.Basic Bell.HiddenVariable.Correlation
lake build Bell.Inequality.Original
lake build Bell.Quantum.Singlet
lake build Bell.Geometry.Violation
lake build Bell.Inequality.Robust
lake build
```

For every headline result, compile an audit command/module containing
`#print axioms <declaration>` and record its exact output in the relevant stage
file. Run `git diff --check` and a repository status review at every stage end.

## Stage Results

- Visually checked printed pages 195–200 at high-resolution renders generated
  from the repository PDF.
- Confirmed all 22 numbered equations and the robust algebra across pp. 198–199
  are represented in the Markdown.
- Added an explicit transcription note for the printed (9) typo.
- Replaced six broken local JPEG links with the existing PDF link.
- Confirmed all 14 preliminary audit items, refining their precise formal
  disposition.
- Added the (9) source typo and the obtuse-angle “rotate towards” defect as
  correction items 15 and 16.
- No Lean project or proof was created; Stage 2 remains the first implementation
  stage.
- Final verification on 2026-07-17 produced:

  - `pdfinfo bell-1964/bell-1964.pdf`: `Pages: 6`, `Encrypted: no`, page size
    `523.92 x 719.04 pts`.
  - `sha256sum bell-1964/bell-1964.pdf`:
    `bb889c2f4909269f58d65662e232df2f5c7a5217829b388ac5a5eb9416d1d9b6`.
  - Equation-tag check: exactly 22 tags, exactly one each for `(1)` through
    `(22)`.
  - Section-heading check: Sections I–VI present at transcription lines 12, 16,
    46, 122, 261, and 265 respectively.
  - Source-link check: the PDF target exists and no absent
    `images/page-*.jpg` reference remains.
  - Lean-scope check: `0 Lean files; no Lean/Lake setup`.
  - Plan check: Stage 1 is marked complete and Stage 2 remains next.
  - `git diff --check`: pass.
  - Artifact scope: `bell-1964/bell-1964.md`, `goal-1/0-plan.md`, and this stage
    record. Repository autosave commit `2f28433` captured their initial stage
    versions during verification; the final evidence append remained the only
    working-tree modification at the subsequent status check.
