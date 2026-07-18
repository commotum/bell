module

import Bell

/-!
# Bell 1964 paper map

This compiled documentation leaf maps J. S. Bell's 1964 paper *On the Einstein
Podolsky Rosen Paradox* to the public `Bell` declarations. It is not imported by
the public root and adds no mathematical axiom or named theorem.

## Status legend

- **Formalized**: the stated mathematical content is proved in Lean.
- **Modernized**: Lean proves an equivalent or reusable version with explicit
  assumptions or a harmless null-set weakening.
- **Partial / post-factorization**: Lean proves a downstream implication while
  an earlier construction remains an explicit hypothesis.
- **Source-audited, deferred**: the paper claim was checked, but the additional
  measure, geometry, or quantum infrastructure is not implemented.
- **Interpretation only**: the statement is not a theorem of the mathematical
  model without further physical definitions and premises.
- **Modern extension**: a useful result not stated in Bell's 1964 paper.

## Assumptions and quantifiers

`Bell.HiddenVariable.DeterministicLocalModel` stores two real response
functions and one hidden-variable measure. Alice's response has no Bob-setting
argument and Bob's has no Alice-setting argument. The measure has no setting
argument. These arities encode the deterministic factorization and fixed
hidden-ensemble assumptions used in this library; they are not a formal theory
of relativistic locality or of random setting variables.

Probability normalization is the separate typeclass premise
`MeasureTheory.IsProbabilityMeasure model.hiddenMeasure`. Binary range,
measurability, perfect anticorrelation, bounded range, and correlation
reproduction are also separate predicates or theorem hypotheses.

The paper states pointwise binary outcomes. The analytic theorems allow binary
or bounded responses almost everywhere at each fixed setting. A statement of
the form `forall setting, almost everywhere omega` is never exchanged for one
common full-measure set over all settings. `correlation` is an expectation.
`ReproducesCorrelationAt` equates one expectation and does not equate complete
joint laws or all quantum statistics. Uniform results name their setting
domains explicitly and use `unitDirectionSet` for physical directions.

## Section II: formulation

### Before equation (1)

**Interpretation only.** Bell's EPR discussion motivates predetermination from
perfect prediction and locality. The Lean core does not formalize that
counterfactual physical inference; it starts by assuming deterministic response
functions.

### Equation (1)

**Formalized and modernized.** `DeterministicLocalModel`, `IsBinaryOutcome`,
`IsBinaryValued`, `IsAEBinaryValued`, and the Alice/Bob predicates expose the
response arities and binary premises. Pointwise predicates match the paper;
the a.e. predicates are the documented null-set weakening used by integration.

### Equation (2)

**Formalized and modernized.** `correlation` is the Bochner integral of the
response product against one arbitrary measure. A density `rho` is unnecessary.
Normalization is not bundled. `ReproducesCorrelationAt` and
`ReproducesCorrelation` separately express target-correlation equality.

### Equation (3)

**Formalized by calculation.** `singletState`, `twoSpinObservable`, and
`singletSpinExpectation` are explicit finite-coordinate objects.
`singletState_normalized`, `singlet_spin_expectation_coordinates`,
`singlet_spin_expectation`, and `singlet_spin_correlation` prove the correlation
`-inner Real a b`. The polynomial identity holds for arbitrary vectors.
Hermiticity and `spinObservable_sq_eq_one_of_norm_eq_one` certify the algebraic
binary-observable convention at unit directions; no spectral measurement or
joint-law API is claimed.

## Section III: illustrations

### Equation (4)

**Source-audited, deferred.** A faithful single-particle sign model needs a
total binary sign convention and a normalized hemisphere surface measure.

### Equation (5)

**Source-audited, deferred.** Its expectation needs a null-equator theorem and
the normalized area of a spherical lune.

### Equation (6)

**Source-audited, corrected, deferred.** The scalar relation requires
`theta' = (pi / 2) * (1 - cos theta)`. A vector at that angle exists, but the
paper's instruction to rotate “towards” the polarization fails for some obtuse
angles because `theta'` can exceed `theta`.

### Equation (7)

**Source-audited, deferred.** It follows from (5) and the corrected
prescribed-angle construction once the measure geometry is supplied.

### Equation (8)

**Source-audited, deferred.** The advertised equal/opposite and orthogonal
values are endpoint consequences of the sphere-sign model in (9)–(10).

### Equation (9)

**Source-audited, corrected, deferred.** The scan's second left-hand side
`B(a,b)` is a typo; the response required by (1), (2), and (10) is
`B(b,lambda) = -sign (b dot lambda)`. A total binary value must be chosen on
the equator and proved irrelevant using a null-boundary result.

### Equation (10)

**Source-audited, deferred.** The formula has values `-1`, `0`, and `1` at
angles `0`, `pi/2`, and `pi`. Its proof needs normalized sphere measure and the
lune probability `theta / pi`; `Real.sign` alone is zero at the boundary and is
not a binary response there.

### Equation (11)

**Source-audited, deferred.** The coefficient `-1/3` needs a specified ensemble
of antiparallel product states and a sphere second-moment calculation. A finite
six-axis ensemble has the same correlation, but that equality alone does not
prove rotational invariance of the mixed state.

### Final nonlocal illustration

**Corrected and deferred.** Alice's constructed response uses Bob's setting, so
the example intentionally violates the local response arity. It repeats the
angle and sign-boundary obligations above. This parameter dependence is not by
itself a theorem about operational signaling.

## Section IV: contradiction and approximation

### Equation (12)

**Represented as a premise.** The typeclass
`IsProbabilityMeasure model.hiddenMeasure` supplies measure normalization; it
is deliberately not a field of the raw model.

### Unnumbered lower bound before equation (13)

**Formalized.** `neg_one_le_correlation` proves `-1 <= correlation` from fixed
normalization, a.e. measurability, and a.e. binary range.

### Equation (13)

**Formalized at one fixed setting, almost everywhere.**
`perfectAnticorrelationAt_of_correlation_eq_neg_one` makes normalization,
measurability, binary range, and diagonal correlation `-1` explicit. The
conclusion is not pointwise and does not provide a common null set for all
settings.

### Equation (14)

**Formalized.**
`correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt` performs the
fixed-setting a.e. rewrite.

### Equation (15) and its unnumbered algebra

**Formalized and assumption-minimized.**
`bell_original_of_perfectAnticorrelationAt` proves the arbitrary-probability-
measure inequality. For a fixed triple, anticorrelation is needed only at `b`.
`bell_original_of_diagonal_correlation_eq_neg_one` derives that premise from
the one diagonal correlation. The theorem contains no quantum or geometry
premise.

`singlet_violates_bell_original` and the finite no-model declarations combine
the independently calculated target with proved unit directions. The global
corollary assumes reproduction on every ambient `Direction` pair and is a
stronger convenience statement; the finite theorem is the physically scoped
contradiction.

### Stationarity paragraph after equation (15)

**Heuristic, not formalized.** “In general of order” requires regularity and
nonconstancy assumptions absent from the paper. The exact finite-setting
inequality and contradiction do not use this heuristic.

### Equation (16)

**Partial: abstract hypothesis.** The `h16` premise of the `bell1964_*`
theorems is a `UniformlyWithinOn` comparison between `correlation model` and an
arbitrary `averagedTarget` on pairs of unit directions. No angular-cap average
is constructed.

### Equation (17)

**Partial: abstract hypothesis.** The `h17` premise compares `averagedTarget`
with `singletCorrelation`. Here `averagedTarget` represents the negative
averaged dot product, so the absolute-value statement is sign-equivalent to the
paper's displayed positive-dot formula. The geometric averaging estimate is
not derived.

### Equation (18)

**Formalized.** `UniformlyWithinOn.trans_add` is the exact uniform triangle
step, retaining both unit-setting domains and adding the two radii.

### Equation (19)

**Derivation deferred.** `correlation model` with bounded effective responses
is the post-factorization endpoint consumed by the robust theorem. The library
does not define center-indexed angular measures or prove joint measurability,
product integrability, independence of the two setting averages, or Fubini.

### Equation (20)

**Assumed endpoint, not derived from averaging.** `IsBoundedByOne` and
`IsAEBoundedByOne` state pointwise and a.e. bounds. Binary-to-bounded bridges do
not construct an angular average.

### Equation (21)

**Encoded, with no standalone declaration.** Its diagonal defect enters through
the `(b,b)` target error in `target_bell_robust_of_four_errors` and through the
`correlation model b b` term in `bounded_response_bell_robust`.

### Robust unnumbered algebra

**Formalized post-factorization.** `bounded_response_bell_pointwise` and
`bounded_response_bell_robust` prove the scalar and arbitrary-measure bounds for
four a.e.-measurable responses bounded by one. No binary or perfect-
anticorrelation premise is used.

### Equation (22)

**Partial modern reformulation.** `target_bell_robust_of_four_errors` is the
general target-agnostic four-error transfer. No declaration states the paper's
full variable-direction right-hand side verbatim.
`bell1964_four_mul_total_error_lower_bound` composes (16)–(18) and already
specializes to the paper's subsequent directions, proving
`sqrt 2 - 1 <= 4 * (epsilon + delta)`.

### Direction example after equation (22)

**Formalized.** `bellA`, `bellB`, and `bellC` have proved norm one and the stated
inner products. `singlet_error_lower_bound_at_bellDirections` proves the
common-radius threshold `(sqrt 2 - 1) / 4`.
`singlet_uniform_error_lower_bound_on_unitDirections` proves the corresponding
uniform post-factorization obstruction. The `bell1964_epsilon_*` theorems prove
`(sqrt 2 - 1) / 4 - delta <= epsilon` and positivity when `delta` is below the
threshold.

### Final Section IV conclusion

The exact correlation non-reproduction theorem is **formalized**. The uniform
post-factorization obstruction is **formalized** with its topology, unit
domains, and constants explicit. The literal angular-smearing instantiation is
**deferred**. Nothing here excludes arbitrary pointwise, setting-a.e., `L^p`,
or other approximation notions.

## Sections V and VI

### Section V

**Source-audited, deferred.** A faithful higher-dimensional theorem needs
isometric qubit embeddings, an embedded singlet, state support, and
support-restricted measurement semantics. Extending Pauli operators by zero
squares to a subspace projection and introduces a zero outcome off that
subspace; it is not an ambient binary observable.

### Section VI

**Interpretation only.** The library proves no result about controllable
signals, instantaneous propagation, Lorentz invariance, or timing of settings.
Those conclusions require physical and operational definitions absent from the
mathematical model.

## Modern CHSH extension

**Modern extension, not in Bell 1964.** `bounded_response_chsh` proves CHSH for
four fixed a.e.-measurable responses bounded by one on one normalized hidden
measure. `singlet_chsh_abs_value_eq_two_mul_sqrtTwo` calculates the value at
four proved unit directions. `singlet_violates_chsh`, the error lower bound,
and the finite/global correlation non-reproduction declarations are downstream
consequences. No perfect-anticorrelation premise is used.

## Consolidated correction and scope log

1. A general probability measure replaces the paper's density notation.
2. The one fixed measure makes setting independence structural for this model;
   it is not a theorem about random setting variables.
3. Deterministic responses are assumed, not derived from a formalized EPR
   argument.
4. Response arities encode parameter independence, not all relativistic
   locality concepts.
5. Equation (13) is fixed-setting a.e.; no uncountable common null set is used.
6. Its derivation requires normalization, measurability, and binary range.
7. The prose before (15) should read “If `c` is another unit vector.”
8. The stationarity paragraph is heuristic without added regularity.
9. Equations (16)–(20) omit averaging-measure, measurability, and Fubini
   obligations.
10. “Not arbitrarily closely approximated” is restricted to the named uniform
    post-factorization criterion, not every approximation topology.
11. The quantitative result is
    `epsilon >= (sqrt 2 - 1) / 4 - delta`; positivity needs a strict bound on
    `delta`.
12. Sign functions must be total, and their zero boundaries must be proved
    null before a chosen value is ignored.
13. The bare no-model theorem proves no signaling or Lorentz conclusion.
14. Zero extension in Section V is not globally binary off the chosen subspace.
15. The printed second left-hand side in (9) is corrected to `B(b,lambda)`.
16. The “rotate towards” instruction fails at some obtuse angles; only the
    prescribed-angle equation is retained.
17. A.e. binary range is a documented modern weakening of pointwise (1).
18. The fixed-triple proof of (15) needs anticorrelation only at `b`.
19. The singlet polynomial holds for arbitrary vectors; unit length supplies
    the physical binary-observable interpretation.
20. Reproduction predicates equate correlations, not complete statistics.
21. Bell states the chosen inner products after (22); their exact-contradiction
    use is a modern explicit instantiation.
22. Averaged responses are bounded, not binary, so the robust inequality has a
    diagonal defect instead of reusing (15).
23. Uniform physical claims use `unitDirectionSet`, not ambient real space.
24. Arbitrary cap-supported measures can be Dirac; removing isolated failures
    needs atomlessness or surface absolute continuity as well as support.
25. `averagedTarget` carries the negative singlet sign.
26. Equation (11) needs a specified product-state ensemble and second moment.
27. CHSH is a post-1964 modern extension.
28. A stochastic-local reduction needs conditional factorization; a random-
    seed determinization additionally needs product measures and Fubini.
-/

-- These checks make declaration renames or missing exports fail this leaf.
#check Bell.HiddenVariable.DeterministicLocalModel
#check Bell.HiddenVariable.IsBinaryValued
#check Bell.HiddenVariable.IsAEBinaryValued
#check Bell.HiddenVariable.correlation
#check Bell.HiddenVariable.neg_one_le_correlation
#check Bell.HiddenVariable.ReproducesCorrelationAt
#check Bell.HiddenVariable.ReproducesCorrelation
#check Bell.Quantum.spinObservable_isHermitian
#check Bell.Quantum.spinObservable_sq_eq_one_of_norm_eq_one
#check Bell.Quantum.singletState_normalized
#check Bell.Quantum.singlet_spin_expectation_coordinates
#check Bell.Quantum.singlet_spin_expectation
#check Bell.Quantum.singlet_spin_correlation
#check Bell.HiddenVariable.perfectAnticorrelationAt_of_correlation_eq_neg_one
#check Bell.HiddenVariable.correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt
#check Bell.Inequality.bell_original_of_perfectAnticorrelationAt
#check Bell.Inequality.bell_original_of_diagonal_correlation_eq_neg_one
#check Bell.Geometry.bellA_norm
#check Bell.Geometry.bellB_norm
#check Bell.Geometry.bellC_norm
#check Bell.Geometry.singlet_violates_bell_original
#check Bell.Geometry.no_deterministicLocalModel_reproduces_singletCorrelations_at_bellDirections
#check Bell.Geometry.no_deterministicLocalModel_reproduces_singletCorrelation
#check Bell.HiddenVariable.IsAEBoundedByOne
#check Bell.Approximation.UniformlyWithinOn
#check Bell.Approximation.UniformlyWithinOn.trans_add
#check Bell.Inequality.bounded_response_bell_pointwise
#check Bell.Inequality.bounded_response_bell_robust
#check Bell.Inequality.target_bell_robust_of_four_errors
#check Bell.Geometry.singlet_uniform_error_lower_bound_on_unitDirections
#check Bell.Geometry.bell1964_four_mul_total_error_lower_bound
#check Bell.Geometry.bell1964_epsilon_lower_bound_of_uniform_averaging_errors
#check Bell.Geometry.bell1964_epsilon_pos_of_uniform_averaging_errors
#check Bell.Inequality.bounded_response_chsh_pointwise
#check Bell.Inequality.bounded_response_chsh
#check Bell.Inequality.target_chsh_of_four_errors
#check Bell.Geometry.chshBobMinus_norm
#check Bell.Geometry.singlet_chsh_abs_value_eq_two_mul_sqrtTwo
#check Bell.Geometry.singlet_violates_chsh
#check Bell.Geometry.singlet_chsh_error_lower_bound_at_directions
#check Bell.Geometry.singletCorrelations_incompatible_with_boundedLocalModel_at_chshDirections
#check Bell.Geometry.no_boundedLocalModel_reproduces_singletCorrelation_via_chsh

-- This is the minimal README example, compiled rather than merely displayed.
open Bell.Geometry Bell.Quantum

example :
    ¬ |singletCorrelation bellA bellB - singletCorrelation bellA bellC| ≤
      1 + singletCorrelation bellB bellC :=
  singlet_violates_bell_original
