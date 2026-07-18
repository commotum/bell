# Bell 1964 in Lean 4

This repository contains a pinned, reusable Lean 4 formalization and audit of
J. S. Bell's 1964 paper *On the Einstein Podolsky Rosen Paradox*.

The verified mathematical core separates and then connects:

1. a general measure-theoretic Bell inequality for deterministic local
   hidden-variable response functions;
2. an independent finite-dimensional calculation of the spin-singlet
   correlation from explicit Pauli matrices and a normalized two-qubit state;
3. proved unit measurement directions whose calculated correlations violate
   Bell's inequality.

The library also contains a bounded-response robustness theorem, a precise
uniform post-factorization non-approximation bound, and a modern CHSH extension.
It does not formalize Bell's philosophical claims as mathematical conclusions.

## What the assumptions mean

The raw structure `Bell.HiddenVariable.DeterministicLocalModel` contains two
real response functions and one hidden-variable measure. It deliberately does
not bundle the following assumptions:

- **Deterministic responses:** each response is a function of its local setting
  and the hidden variable.
- **Local response dependence:** Alice's function has no Bob-setting argument,
  and Bob's has no Alice-setting argument.
- **Measurement-setting independence for this model class:** the one stored
  hidden-variable measure has no setting argument.
- **Normalization:** supplied separately by
  `[IsProbabilityMeasure model.hiddenMeasure]`.
- **Binary or bounded outcomes:** expressed by pointwise and setting-wise
  almost-everywhere predicates.
- **Perfect anticorrelation:** pointwise and fixed-setting a.e. forms are
  distinct.
- **Target reproduction:** `ReproducesCorrelationAt` and
  `ReproducesCorrelation` equate correlation expectations only, not complete
  joint probability laws or all quantum statistics.

The fixed-measure and response-arity design is the precise mathematical
local-model assumption used here. It is not a bundled doctrine called “local
realism,” a theorem about random measurement settings, or a formal definition
of relativistic locality.

## Public module map

| Modules | Role |
|---|---|
| `Bell.HiddenVariable.Basic`, `Correlation` | Raw fixed-measure response model, binary/measurability predicates, correlation integral, integrability, and `[-1,1]` range |
| `Bell.HiddenVariable.PerfectAnticorrelation` | Pointwise versus fixed-setting a.e. anticorrelation, equation (13), and equation (14) |
| `Bell.HiddenVariable.Reproduction` | Target-agnostic correlation-reproduction predicates |
| `Bell.HiddenVariable.Bounded` | Pointwise/a.e. `[-1,1]` effective responses and binary-to-bounded bridges |
| `Bell.Approximation.Uniform` | Uniform absolute error on explicit products of setting domains |
| `Bell.Inequality.Original` | Bell's equation (15) for an arbitrary probability measure |
| `Bell.Inequality.Robust` | Post-factorization bounded-response inequality and four-error target transfer |
| `Bell.Inequality.CHSH` | Modern bounded-response CHSH inequality and four-error transfer |
| `Bell.Quantum.Basic`, `Pauli`, `Singlet` | Explicit finite kets/matrices, Pauli observables, normalized singlet, and calculated correlation |
| `Bell.Geometry.BellDirections`, `Violation` | Unit directions, exact numerical violation, and finite/global correlation no-go theorems |
| `Bell.Geometry.RobustViolation` | Unit-domain uniform obstruction and Bell's quantitative `epsilon`/`delta` consequence |
| `Bell.Geometry.CHSHViolation` | Four unit directions, calculated value `2 * sqrt 2`, CHSH violation, and error/no-go results |

Import `Bell` for the stable public surface. Modules under `Bell.Audit` and the
release-check leaves `Bell.PaperMap` and `Bell.AxiomAudit` are diagnostic and
are not re-exported.

## Headline results

- `bell_original_of_perfectAnticorrelationAt` proves
  `|P(a,b) - P(a,c)| <= 1 + P(b,c)` from explicit fixed-setting analytic,
  binary, normalization, and a.e. anticorrelation premises.
- `perfectAnticorrelationAt_of_correlation_eq_neg_one` derives the required
  fixed-setting a.e. relation from diagonal correlation `-1` with its binary,
  measurability, and normalization assumptions visible.
- `singlet_spin_correlation` proves
  `singletCorrelation a b = -inner Real a b` by finite matrix calculation.
  The identity holds for arbitrary real three-vectors; unit length is required
  for the binary spin-observable interpretation.
- `singlet_violates_bell_original` proves the strict numerical reversal at
  `bellA`, `bellB`, and `bellC`.
- `no_deterministicLocalModel_reproduces_singletCorrelations_at_bellDirections`
  rules out a model satisfying exactly the finite assumptions consumed by that
  contradiction.
- `singlet_uniform_error_lower_bound_on_unitDirections` proves that a bounded
  local correlation uniformly approximating the singlet correlation on unit
  directions has error at least `(sqrt 2 - 1) / 4`.
- `bell1964_epsilon_lower_bound_of_uniform_averaging_errors` proves
  `(sqrt 2 - 1) / 4 - delta <= epsilon` from the two explicit uniform-error
  hypotheses corresponding to equations (16)–(18).
- `bounded_response_chsh` is a modern four-setting theorem requiring neither
  binary outcomes nor perfect anticorrelation.
- `singlet_chsh_abs_value_eq_two_mul_sqrtTwo` and `singlet_violates_chsh`
  calculate and violate the CHSH bound at four proved unit directions.

The global no-model corollaries quantify over every pair of ambient
`Direction` values and are stronger convenience results. The finite theorems at
the displayed unit directions are the physically scoped contradictions.

## Minimal Lean usage

This snippet is mirrored by a compiled example in `Bell.PaperMap`:

```lean
import Bell

open Bell.Geometry Bell.Quantum

#check Bell.Inequality.bell_original_of_perfectAnticorrelationAt
#check Bell.Quantum.singlet_spin_correlation

example :
    ¬ |singletCorrelation bellA bellB - singletCorrelation bellA bellC| ≤
      1 + singletCorrelation bellB bellC :=
  singlet_violates_bell_original
```

## Pinned environment and builds

- Lean: `v4.31.0`
- Lake: `5.0.0`
- mathlib: `fabf563a7c95a166b8d7b6efca11c8b4dc9d911f` (`v4.31.0`)

From a repository checkout with `elan` installed:

```text
cd formal
lake env lean --version
lake --version
lake exe cache get
lake build
lake build Bell.PaperMap Bell.AxiomAudit Bell
```

The committed `lean-toolchain`, `lakefile.toml`, and `lake-manifest.json` pin the
environment. `lake update` is not part of the reproducible build procedure and
is unnecessary for a normal checkout.

To replay every diagnostic leaf:

```text
cd formal
lake build Bell.Audit.ProbabilityApi Bell.Audit.GeometryApi Bell.Audit.QuantumApi
lake build Bell.Audit.LocalModel Bell.Audit.OriginalInequality Bell.Audit.Singlet
lake build Bell.Audit.Violation Bell.Audit.Robust Bell.Audit.CHSH
lake build Bell.PaperMap Bell.AxiomAudit
```

`Bell.AxiomAudit` issues `#print axioms` for every release-headline theorem. The
expected set is:

```text
[propext, Classical.choice, Quot.sound]
```

These are understood Lean/mathlib foundations; the project declares no custom
mathematical axiom.

## Paper map, corrections, and scope

- The [compiled paper map](formal/Bell/PaperMap.lean) classifies every equation
  (1)–(22), Sections V–VI, modern reformulations, corrections, and deferments.
- The [source transcription](bell-1964/bell-1964.md) and
  [six-page scan](bell-1964/bell-1964.pdf) are retained together.
- The [master plan and correction log](goal-1/0-plan.md) and the
  [release-audit record](goal-1/9-RELEASE-AUDIT.md) contain the detailed design
  and verification evidence.

The exact Bell inequality, matrix-derived singlet correlation, explicit
contradiction, and bounded-response uniform obstruction are formalized. The
following remain deliberately outside the proved release surface:

- the sphere/hemisphere sign models in equations (4)–(10), which require total
  sign conventions, null equators, and spherical-lune measure calculations;
- the equation-(11) mixed state, which requires a specified ensemble and a
  second-moment calculation;
- the literal angular-cap construction behind equations (16)–(20), including
  center-indexed measures, atomlessness or surface absolute continuity where
  needed, joint measurability, product integrability, and Fubini;
- a stochastic-local reduction, which first requires explicit conditional
  factorization and then additional product-measure work for random-seed
  determinization;
- Section V's higher-dimensional embedding, which requires embedded-state
  support and support-restricted binary measurement semantics; and
- Section VI's claims about influence, signaling, propagation speed, Lorentz
  invariance, and experimental timing.

Consequently, the approximation result is a uniform post-factorization theorem
on unit directions. It is not a claim about every pointwise, setting-a.e.,
`L^p`, or other approximation topology, and it does not claim the deferred
angular-smearing factorization has been constructed.

## Repository notes

The Lean package is entirely under `formal/`. The root Python/uv starter files
predate this formalization and are not dependencies of the Lean build; they are
retained rather than silently repurposed or deleted.

No license file is currently present. The repository therefore does not yet
state legal reuse terms; selecting those terms is a project-owner decision,
not part of the formal proof audit.
