module

import Bell
import Mathlib.MeasureTheory.Measure.Dirac
import Mathlib.Tactic.NormNum

/-!
# Stage 8 CHSH audit

This non-exported leaf checks the public root, a normalized one-point model
that sharply saturates CHSH with a nonbinary response, binary specialization,
explicit directions and singlet values, theorem signatures, and axioms.
-/

set_option linter.privateModule false

open MeasureTheory

namespace Bell.Audit.CHSH

open Geometry HiddenVariable Inequality Quantum

section SharpOnePointModel

/-- Alice always returns one; Bob returns one at `false` and zero at `true`.
The latter is a bounded effective response, not a binary raw outcome. -/
noncomputable def sharpCHSHModel :
    DeterministicLocalModel Bool Bool Unit where
  hiddenMeasure := Measure.dirac ()
  aliceResponse := fun _ _ => 1
  bobResponse := fun setting _ => if setting then 0 else 1

noncomputable instance : IsProbabilityMeasure sharpCHSHModel.hiddenMeasure := by
  change IsProbabilityMeasure (Measure.dirac ())
  infer_instance

theorem sharpCHSHModel_aliceMeasurable :
    AliceAEMeasurable sharpCHSHModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem sharpCHSHModel_bobMeasurable :
    BobAEMeasurable sharpCHSHModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem sharpCHSHModel_aliceBounded :
    AliceBoundedByOne sharpCHSHModel := by
  intro setting ω
  norm_num [sharpCHSHModel]

theorem sharpCHSHModel_bobBounded :
    BobBoundedByOne sharpCHSHModel := by
  intro setting ω
  cases setting <;> norm_num [sharpCHSHModel]

theorem sharpCHSHModel_not_bobBinary :
    ¬BobBinary sharpCHSHModel := by
  intro h
  have hvalue := h true ()
  norm_num [sharpCHSHModel, IsBinaryOutcome] at hvalue

theorem sharpCHSHModel_correlation (a b : Bool) :
    correlation sharpCHSHModel a b = if b then 0 else 1 := by
  simp [correlation, sharpCHSHModel]

theorem sharpCHSHModel_chsh :
    chshCombination (correlation sharpCHSHModel)
      false true false true = 2 := by
  norm_num [chshCombination, sharpCHSHModel_correlation]

example :
    |chshCombination (correlation sharpCHSHModel)
      false true false true| ≤ 2 :=
  bounded_response_chsh sharpCHSHModel false true false true
    (sharpCHSHModel_aliceMeasurable false)
    (sharpCHSHModel_aliceMeasurable true)
    (sharpCHSHModel_bobMeasurable false)
    (sharpCHSHModel_bobMeasurable true)
    (sharpCHSHModel_aliceBounded.ae false)
    (sharpCHSHModel_aliceBounded.ae true)
    (sharpCHSHModel_bobBounded.ae false)
    (sharpCHSHModel_bobBounded.ae true)

end SharpOnePointModel

-- Binary models enter the bounded CHSH theorem through an explicit bridge.
example {SettingA SettingB Ω : Type*} [MeasurableSpace Ω]
    {model : DeterministicLocalModel SettingA SettingB Ω}
    (h : AliceAEBinary model) : AliceAEBoundedByOne model :=
  h.boundedByOne

-- The fourth physical direction is unit and gives the advertised exact value.
example : ‖chshBobMinus‖ = 1 := chshBobMinus_norm
example :
    chshCombination singletCorrelation bellA bellC bellB chshBobMinus =
      -4 * bellScale :=
  singlet_chsh_combination
example :
    |chshCombination singletCorrelation bellA bellC bellB chshBobMinus| =
      2 * Real.sqrt 2 :=
  singlet_chsh_abs_value_eq_two_mul_sqrtTwo

example : 0 < (Real.sqrt 2 - 1) / 2 := by
  have hsqrt : 1 < Real.sqrt 2 := by
    nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2), sqrtTwo_pos]
  positivity

#check chshCombination
#check bounded_response_chsh_pointwise
#check bounded_response_chsh
#check target_chsh_of_four_errors
#check chshBobMinus
#check chshBobMinus_norm
#check singlet_chsh_combination
#check singlet_chsh_abs_value_eq_two_mul_sqrtTwo
#check singlet_chsh_strict_violation
#check singlet_violates_chsh
#check singlet_chsh_error_lower_bound_at_directions
#check singletCorrelations_incompatible_with_boundedLocalModel_at_chshDirections
#check no_boundedLocalModel_reproduces_singletCorrelation_via_chsh

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

end Bell.Audit.CHSH
