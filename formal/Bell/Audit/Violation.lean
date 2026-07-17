module

import Bell
import Mathlib.Tactic.NormNum

/-!
# Stage 6 geometric-violation audit

This non-exported leaf checks the public root, concrete coordinates, physical
unit-direction certificates, exact singlet values, theorem signatures, and
axioms of the Stage 6 headline results.
-/

set_option linter.privateModule false

open MeasureTheory

namespace Bell.Audit.Violation

open Geometry HiddenVariable Quantum

-- The explicit coordinates are `a=(1,0,0)`, `b=(r,r,0)`, `c=(0,1,0)`.
example : bellA 0 = 1 := by simp [bellA]
example : bellA 1 = 0 := by simp [bellA]
example : bellA 2 = 0 := by simp [bellA]
example : bellB 0 = bellScale := by simp [bellA, bellB, bellC]
example : bellB 1 = bellScale := by simp [bellA, bellB, bellC]
example : bellB 2 = 0 := by simp [bellA, bellB, bellC]
example : bellC 0 = 0 := by simp [bellC]
example : bellC 1 = 1 := by simp [bellC]
example : bellC 2 = 0 := by simp [bellC]

-- Unit norms certify that all three directional Pauli observables square to I.
example : spinObservable bellA ^ 2 = 1 :=
  spinObservable_sq_eq_one_of_norm_eq_one bellA bellA_norm

example : spinObservable bellB ^ 2 = 1 :=
  spinObservable_sq_eq_one_of_norm_eq_one bellB bellB_norm

example : spinObservable bellC ^ 2 = 1 :=
  spinObservable_sq_eq_one_of_norm_eq_one bellC bellC_norm

-- The exact quantum values are public consequences of the matrix calculation.
example : singletCorrelation bellA bellB = -bellScale :=
  singletCorrelation_bellA_bellB

example : singletCorrelation bellA bellC = 0 :=
  singletCorrelation_bellA_bellC

example : singletCorrelation bellB bellB = -1 :=
  singletCorrelation_bellB_bellB

example : singletCorrelation bellB bellC = -bellScale :=
  singletCorrelation_bellB_bellC

#check bellA_norm
#check bellB_norm
#check bellC_norm
#check bellA_inner_bellC
#check bellA_inner_bellB
#check bellA_inner_bellB_eq_one_div_sqrt_two
#check bellB_inner_bellC
#check bellB_inner_bellC_eq_one_div_sqrt_two
#check singlet_bell_original_strict_violation
#check singlet_violates_bell_original
#check singletCorrelations_incompatible_with_perfectAnticorrelationAt_bellB
#check singletCorrelations_incompatible_with_deterministicLocalModel_at_bellDirections
#check no_deterministicLocalModel_reproduces_singletCorrelations_at_bellDirections
#check no_deterministicLocalModel_reproduces_singletCorrelation

#print axioms bellA_norm
#print axioms bellB_norm
#print axioms bellC_norm
#print axioms bellA_inner_bellC
#print axioms bellA_inner_bellB
#print axioms bellB_inner_bellC
#print axioms singlet_bell_original_strict_violation
#print axioms singlet_violates_bell_original
#print axioms singletCorrelations_incompatible_with_perfectAnticorrelationAt_bellB
#print axioms singletCorrelations_incompatible_with_deterministicLocalModel_at_bellDirections
#print axioms no_deterministicLocalModel_reproduces_singletCorrelations_at_bellDirections
#print axioms no_deterministicLocalModel_reproduces_singletCorrelation

end Bell.Audit.Violation
