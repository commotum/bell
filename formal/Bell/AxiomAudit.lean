module

import Bell

/-!
# Consolidated release axiom audit

This non-exported diagnostic leaf checks the stable public signatures and asks
Lean for the axioms of every release-headline theorem. It deliberately defines
no wrapper theorem: the output is about the actual public declarations.

The expected output contains only `propext`, `Classical.choice`, and
`Quot.sound`, the understood Lean/mathlib foundations used by this development.
No project-specific axiom is permitted.
-/

-- Public assumption and target vocabulary.
#check Bell.HiddenVariable.DeterministicLocalModel
#check Bell.HiddenVariable.IsBinaryOutcome
#check Bell.HiddenVariable.IsBinaryValued
#check Bell.HiddenVariable.IsAEBinaryValued
#check Bell.HiddenVariable.AliceAEMeasurable
#check Bell.HiddenVariable.BobAEMeasurable
#check Bell.HiddenVariable.AliceAEBinary
#check Bell.HiddenVariable.BobAEBinary
#check Bell.HiddenVariable.PointwisePerfectAnticorrelationAt
#check Bell.HiddenVariable.PerfectAnticorrelationAt
#check Bell.HiddenVariable.ReproducesCorrelationAt
#check Bell.HiddenVariable.ReproducesCorrelation
#check Bell.HiddenVariable.IsBoundedByOne
#check Bell.HiddenVariable.IsAEBoundedByOne
#check Bell.Approximation.UniformlyWithinOn
#check Bell.Quantum.Direction
#check Bell.Quantum.singletCorrelation

-- General hidden-variable analysis and Bell's equations (13)–(15).
#print axioms Bell.HiddenVariable.responseProduct_integrable
#print axioms Bell.HiddenVariable.correlation_mem_Icc
#print axioms Bell.HiddenVariable.perfectAnticorrelationAt_of_correlation_eq_neg_one
#print axioms Bell.HiddenVariable.correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt
#print axioms Bell.Inequality.bell_original_of_perfectAnticorrelationAt
#print axioms Bell.Inequality.bell_original_of_diagonal_correlation_eq_neg_one

-- Independent finite-dimensional quantum calculation.
#print axioms Bell.Quantum.spinObservable_isHermitian
#print axioms Bell.Quantum.spinObservable_sq_eq_one_of_norm_eq_one
#print axioms Bell.Quantum.singletState_normalized
#print axioms Bell.Quantum.singlet_spin_expectation_coordinates
#print axioms Bell.Quantum.singlet_spin_expectation
#print axioms Bell.Quantum.singlet_spin_correlation

-- Explicit unit geometry, exact violation, and correlation no-go results.
#print axioms Bell.Geometry.bellA_norm
#print axioms Bell.Geometry.bellB_norm
#print axioms Bell.Geometry.bellC_norm
#print axioms Bell.Geometry.singlet_bell_original_strict_violation
#print axioms Bell.Geometry.singlet_violates_bell_original
#print axioms
  Bell.Geometry.singletCorrelations_incompatible_with_deterministicLocalModel_at_bellDirections
#print axioms
  Bell.Geometry.no_deterministicLocalModel_reproduces_singletCorrelations_at_bellDirections
#print axioms Bell.Geometry.no_deterministicLocalModel_reproduces_singletCorrelation

-- Post-factorization robustness and Bell's quantitative consequence.
#print axioms Bell.HiddenVariable.boundedProduct_integrable
#print axioms Bell.Approximation.UniformlyWithinOn.trans_add
#print axioms Bell.Inequality.bounded_response_bell_pointwise
#print axioms Bell.Inequality.bounded_response_bell_robust
#print axioms Bell.Inequality.target_bell_robust_of_four_errors
#print axioms Bell.Geometry.singlet_uniform_error_constant_pos
#print axioms Bell.Geometry.singlet_uniform_error_lower_bound_on_unitDirections
#print axioms Bell.Geometry.bell1964_four_mul_total_error_lower_bound
#print axioms Bell.Geometry.bell1964_epsilon_lower_bound_of_uniform_averaging_errors
#print axioms Bell.Geometry.bell1964_epsilon_pos_of_uniform_averaging_errors

-- Modern bounded-response CHSH extension.
#print axioms Bell.Inequality.bounded_response_chsh_pointwise
#print axioms Bell.Inequality.bounded_response_chsh
#print axioms Bell.Inequality.target_chsh_of_four_errors
#print axioms Bell.Geometry.chshBobMinus_norm
#print axioms Bell.Geometry.singlet_chsh_combination
#print axioms Bell.Geometry.singlet_chsh_abs_value_eq_two_mul_sqrtTwo
#print axioms Bell.Geometry.singlet_chsh_strict_violation
#print axioms Bell.Geometry.singlet_violates_chsh
#print axioms Bell.Geometry.singlet_chsh_error_lower_bound_at_directions
#print axioms
  Bell.Geometry.singletCorrelations_incompatible_with_boundedLocalModel_at_chshDirections
#print axioms Bell.Geometry.no_boundedLocalModel_reproduces_singletCorrelation_via_chsh
