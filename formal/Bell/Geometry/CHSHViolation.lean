module

public import Bell.Geometry.BellDirections
public import Bell.HiddenVariable.Reproduction
public import Bell.Inequality.CHSH
public import Bell.Quantum.Singlet
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# A singlet violation of CHSH

This module gives a modern four-setting corollary of the verified Bell library;
CHSH is not a numbered theorem in Bell's 1964 paper. The target correlations
are derived from the explicit finite-matrix singlet calculation at four proved
unit vectors. No signaling or spacetime conclusion is stated.
-/

@[expose] public section

open MeasureTheory

namespace Bell.Geometry

open HiddenVariable Inequality Quantum

/-- The anti-diagonal Bob direction `(bellA - bellC) / sqrt(2)`. -/
noncomputable def chshBobMinus : Direction :=
  bellScale • (bellA - bellC)

theorem bellA_inner_chshBobMinus :
    inner ℝ bellA chshBobMinus = bellScale := by
  rw [direction_inner_eq_sum]
  simp [bellA, bellC, chshBobMinus]

theorem bellC_inner_chshBobMinus :
    inner ℝ bellC chshBobMinus = -bellScale := by
  rw [direction_inner_eq_sum]
  simp [bellA, bellC, chshBobMinus]

theorem chshBobMinus_inner_self :
    inner ℝ chshBobMinus chshBobMinus = 1 := by
  rw [direction_inner_eq_sum]
  simp [Fin.sum_univ_three, bellA, bellC, chshBobMinus]
  nlinarith [bellScale_sq]

/-- The anti-diagonal CHSH direction is a unit vector. -/
theorem chshBobMinus_norm : ‖chshBobMinus‖ = 1 := by
  have hsq : ‖chshBobMinus‖ ^ 2 = (1 : ℝ) := by
    rw [← real_inner_self_eq_norm_sq]
    exact chshBobMinus_inner_self
  nlinarith [norm_nonneg chshBobMinus]

theorem singletCorrelation_bellA_chshBobMinus :
    singletCorrelation bellA chshBobMinus = -bellScale := by
  rw [singlet_spin_correlation, bellA_inner_chshBobMinus]

theorem singletCorrelation_bellC_chshBobMinus :
    singletCorrelation bellC chshBobMinus = bellScale := by
  rw [singlet_spin_correlation, bellC_inner_chshBobMinus]
  ring

private theorem singletCorrelation_bellA_bellB_for_chsh :
    singletCorrelation bellA bellB = -bellScale := by
  rw [singlet_spin_correlation, bellA_inner_bellB]

private theorem bellC_inner_bellB :
    inner ℝ bellC bellB = bellScale := by
  rw [real_inner_comm]
  exact bellB_inner_bellC

private theorem singletCorrelation_bellC_bellB_for_chsh :
    singletCorrelation bellC bellB = -bellScale := by
  rw [singlet_spin_correlation, bellC_inner_bellB]

/-- The signed singlet CHSH combination at the explicit directions. -/
theorem singlet_chsh_combination :
    chshCombination singletCorrelation bellA bellC bellB chshBobMinus =
      -4 * bellScale := by
  simp only [chshCombination, singletCorrelation_bellA_bellB_for_chsh,
    singletCorrelation_bellA_chshBobMinus,
    singletCorrelation_bellC_bellB_for_chsh,
    singletCorrelation_bellC_chshBobMinus]
  ring

/-- The absolute singlet CHSH value is `4 / sqrt(2)`. -/
theorem singlet_chsh_abs_value :
    |chshCombination singletCorrelation bellA bellC bellB chshBobMinus| =
      4 * bellScale := by
  rw [singlet_chsh_combination, abs_of_nonpos]
  · ring
  · linarith [bellScale_pos]

private theorem four_mul_bellScale_eq_two_mul_sqrtTwo :
    4 * bellScale = 2 * Real.sqrt 2 := by
  nlinarith [bellScale_sq,
    Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2), bellScale_pos, sqrtTwo_pos]

/-- Standard numerical form of the singlet CHSH value, `2 * sqrt(2)`. -/
theorem singlet_chsh_abs_value_eq_two_mul_sqrtTwo :
    |chshCombination singletCorrelation bellA bellC bellB chshBobMinus| =
      2 * Real.sqrt 2 := by
  rw [singlet_chsh_abs_value, four_mul_bellScale_eq_two_mul_sqrtTwo]

/-- The independently calculated singlet correlations strictly violate CHSH. -/
theorem singlet_chsh_strict_violation :
    2 < |chshCombination singletCorrelation bellA bellC bellB chshBobMinus| := by
  rw [singlet_chsh_abs_value]
  linarith [one_sub_bellScale_lt_bellScale]

/-- The calculated four singlet correlations violate the CHSH bound. -/
theorem singlet_violates_chsh :
    ¬ |chshCombination singletCorrelation bellA bellC bellB chshBobMinus| ≤ 2 :=
  not_le_of_gt singlet_chsh_strict_violation

variable {Ω : Type*} [MeasurableSpace Ω]

/-- Four fixed approximation errors at the CHSH directions force the modern
lower bound `(sqrt(2) - 1) / 2` for this argument. -/
theorem singlet_chsh_error_lower_bound_at_directions
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (η : ℝ)
    (hAaMeas : AEMeasurable (model.aliceResponse bellA) model.hiddenMeasure)
    (hAcMeas : AEMeasurable (model.aliceResponse bellC) model.hiddenMeasure)
    (hBbMeas : AEMeasurable (model.bobResponse bellB) model.hiddenMeasure)
    (hBdMeas : AEMeasurable (model.bobResponse chshBobMinus)
      model.hiddenMeasure)
    (hAaBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse bellA))
    (hAcBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse bellC))
    (hBbBound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse bellB))
    (hBdBound : IsAEBoundedByOne model.hiddenMeasure
      (model.bobResponse chshBobMinus))
    (hAB : |correlation model bellA bellB - singletCorrelation bellA bellB| ≤ η)
    (hAD : |correlation model bellA chshBobMinus -
      singletCorrelation bellA chshBobMinus| ≤ η)
    (hCB : |correlation model bellC bellB - singletCorrelation bellC bellB| ≤ η)
    (hCD : |correlation model bellC chshBobMinus -
      singletCorrelation bellC chshBobMinus| ≤ η) :
    (Real.sqrt 2 - 1) / 2 ≤ η := by
  have htarget := target_chsh_of_four_errors model singletCorrelation η
    bellA bellC bellB chshBobMinus hAaMeas hAcMeas hBbMeas hBdMeas
      hAaBound hAcBound hBbBound hBdBound hAB hAD hCB hCD
  rw [singlet_chsh_abs_value_eq_two_mul_sqrtTwo] at htarget
  linarith

/-- Four singlet-correlation equalities at the CHSH directions are incompatible
with any normalized factorized bounded-response model.

The response arities encode local setting dependence, and the single stored
measure encodes measurement-setting independence. Normalization, fixed-setting
measurability, boundedness, and correlation reproduction remain separate
hypotheses. -/
theorem singletCorrelations_incompatible_with_boundedLocalModel_at_chshDirections
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (hAaMeas : AEMeasurable (model.aliceResponse bellA) model.hiddenMeasure)
    (hAcMeas : AEMeasurable (model.aliceResponse bellC) model.hiddenMeasure)
    (hBbMeas : AEMeasurable (model.bobResponse bellB) model.hiddenMeasure)
    (hBdMeas : AEMeasurable (model.bobResponse chshBobMinus)
      model.hiddenMeasure)
    (hAaBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse bellA))
    (hAcBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse bellC))
    (hBbBound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse bellB))
    (hBdBound : IsAEBoundedByOne model.hiddenMeasure
      (model.bobResponse chshBobMinus))
    (hAB : ReproducesCorrelationAt model singletCorrelation bellA bellB)
    (hAD : ReproducesCorrelationAt model singletCorrelation bellA chshBobMinus)
    (hCB : ReproducesCorrelationAt model singletCorrelation bellC bellB)
    (hCD : ReproducesCorrelationAt model singletCorrelation bellC chshBobMinus) :
    False := by
  have hbound := bounded_response_chsh model bellA bellC bellB chshBobMinus
    hAaMeas hAcMeas hBbMeas hBdMeas hAaBound hAcBound hBbBound hBdBound
  simp only [chshCombination] at hbound
  rw [hAB, hAD, hCB, hCD] at hbound
  exact singlet_violates_chsh (by simpa [chshCombination] using hbound)

/-- Singlet-correlation reproduction on every pair of ambient `Direction`
values is impossible for a normalized factorized model with setting-wise
measurable bounded responses.

This is a stronger convenience corollary. The preceding finite theorem uses
only the four correlations at the proved unit directions needed by the
physical CHSH contradiction. -/
theorem no_boundedLocalModel_reproduces_singletCorrelation_via_chsh
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (hAliceMeas : AliceAEMeasurable model)
    (hBobMeas : BobAEMeasurable model)
    (hAliceBound : AliceAEBoundedByOne model)
    (hBobBound : BobAEBoundedByOne model)
    (hreproduces : ReproducesCorrelation model singletCorrelation) :
    False := by
  exact singletCorrelations_incompatible_with_boundedLocalModel_at_chshDirections
    model (hAliceMeas bellA) (hAliceMeas bellC) (hBobMeas bellB)
      (hBobMeas chshBobMinus) (hAliceBound bellA) (hAliceBound bellC)
      (hBobBound bellB) (hBobBound chshBobMinus)
      (hreproduces.at bellA bellB) (hreproduces.at bellA chshBobMinus)
      (hreproduces.at bellC bellB) (hreproduces.at bellC chshBobMinus)

end Bell.Geometry
