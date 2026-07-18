module

public import Bell.Approximation.Uniform
public import Bell.Geometry.Violation
public import Bell.Inequality.Robust
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum

/-!
# Quantitative singlet non-approximation

This module combines the abstract bounded-response inequality with the
calculated singlet correlation on physical unit directions. It formalizes the
uniform-error core and constants of Bell's equations (16)–(22).

The intermediate `averagedTarget` in the final theorems is abstract. This
module does not claim to construct angular-cap measures or derive the Fubini
factorization in equation (19).
-/

@[expose] public section

open MeasureTheory

namespace Bell.Geometry

open Approximation HiddenVariable Inequality Quantum

/-- The physical measurement-setting domain inside ambient real three-space. -/
def unitDirectionSet : Set Direction :=
  {d | ‖d‖ = 1}

theorem bellA_mem_unitDirectionSet : bellA ∈ unitDirectionSet := by
  simpa [unitDirectionSet] using bellA_norm

theorem bellB_mem_unitDirectionSet : bellB ∈ unitDirectionSet := by
  simpa [unitDirectionSet] using bellB_norm

theorem bellC_mem_unitDirectionSet : bellC ∈ unitDirectionSet := by
  simpa [unitDirectionSet] using bellC_norm

theorem two_mul_bellScale_eq_sqrtTwo :
    2 * bellScale = Real.sqrt 2 := by
  rw [bellScale_eq_one_div_sqrt_two]
  field_simp [sqrtTwo_ne_zero]
  nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)]

/-- Bell's quantitative uniform-error threshold is strictly positive. -/
theorem singlet_uniform_error_constant_pos :
    0 < (Real.sqrt 2 - 1) / 4 := by
  have hsqrt : 1 < Real.sqrt 2 := by
    nlinarith [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2), sqrtTwo_pos]
  exact div_pos (sub_pos.mpr hsqrt) (by norm_num)

variable {Ω : Type*} [MeasurableSpace Ω]

/-- Equation-(22) constant from four fixed singlet-correlation error bounds at
the concrete Bell directions. -/
theorem singlet_four_mul_error_lower_bound_at_bellDirections
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (η : ℝ)
    (hAaMeas : AEMeasurable (model.aliceResponse bellA) model.hiddenMeasure)
    (hAbMeas : AEMeasurable (model.aliceResponse bellB) model.hiddenMeasure)
    (hBbMeas : AEMeasurable (model.bobResponse bellB) model.hiddenMeasure)
    (hBcMeas : AEMeasurable (model.bobResponse bellC) model.hiddenMeasure)
    (hAaBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse bellA))
    (hAbBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse bellB))
    (hBbBound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse bellB))
    (hBcBound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse bellC))
    (hAB : |correlation model bellA bellB - singletCorrelation bellA bellB| ≤ η)
    (hAC : |correlation model bellA bellC - singletCorrelation bellA bellC| ≤ η)
    (hBC : |correlation model bellB bellC - singletCorrelation bellB bellC| ≤ η)
    (hBB : |correlation model bellB bellB - singletCorrelation bellB bellB| ≤ η) :
    Real.sqrt 2 - 1 ≤ 4 * η := by
  have htarget := target_bell_robust_of_four_errors model singletCorrelation η
    bellA bellB bellC hAaMeas hAbMeas hBbMeas hBcMeas
      hAaBound hAbBound hBbBound hBcBound hAB hAC hBC hBB
  rw [singletCorrelation_bellA_bellB, singletCorrelation_bellA_bellC,
    singletCorrelation_bellB_bellC, singletCorrelation_bellB_bellB] at htarget
  have hscaleAbs : |-bellScale - 0| = bellScale := by
    simpa using abs_of_pos bellScale_pos
  rw [hscaleAbs] at htarget
  rw [← two_mul_bellScale_eq_sqrtTwo]
  linarith

/-- Four fixed errors with one common radius at Bell's directions force the
threshold `(sqrt(2)-1)/4`. -/
theorem singlet_error_lower_bound_at_bellDirections
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (η : ℝ)
    (hAaMeas : AEMeasurable (model.aliceResponse bellA) model.hiddenMeasure)
    (hAbMeas : AEMeasurable (model.aliceResponse bellB) model.hiddenMeasure)
    (hBbMeas : AEMeasurable (model.bobResponse bellB) model.hiddenMeasure)
    (hBcMeas : AEMeasurable (model.bobResponse bellC) model.hiddenMeasure)
    (hAaBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse bellA))
    (hAbBound : IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse bellB))
    (hBbBound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse bellB))
    (hBcBound : IsAEBoundedByOne model.hiddenMeasure (model.bobResponse bellC))
    (hAB : |correlation model bellA bellB - singletCorrelation bellA bellB| ≤ η)
    (hAC : |correlation model bellA bellC - singletCorrelation bellA bellC| ≤ η)
    (hBC : |correlation model bellB bellC - singletCorrelation bellB bellC| ≤ η)
    (hBB : |correlation model bellB bellB - singletCorrelation bellB bellB| ≤ η) :
    (Real.sqrt 2 - 1) / 4 ≤ η := by
  have hfour := singlet_four_mul_error_lower_bound_at_bellDirections model η
    hAaMeas hAbMeas hBbMeas hBcMeas hAaBound hAbBound hBbBound hBcBound
      hAB hAC hBC hBB
  linarith

/-- A bounded local correlation uniformly close to the singlet target on all
unit directions has error at least `(sqrt(2)-1)/4`.

Measurability and boundedness are also quantified only on unit directions; the
ambient nonunit vectors are irrelevant. -/
theorem singlet_uniform_error_lower_bound_on_unitDirections
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (η : ℝ)
    (hAliceMeas : ∀ a ∈ unitDirectionSet,
      AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBobMeas : ∀ b ∈ unitDirectionSet,
      AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAliceBound : ∀ a ∈ unitDirectionSet,
      IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse a))
    (hBobBound : ∀ b ∈ unitDirectionSet,
      IsAEBoundedByOne model.hiddenMeasure (model.bobResponse b))
    (hApprox : UniformlyWithinOn unitDirectionSet unitDirectionSet
      (correlation model) singletCorrelation η) :
    (Real.sqrt 2 - 1) / 4 ≤ η := by
  exact singlet_error_lower_bound_at_bellDirections model η
    (hAliceMeas bellA bellA_mem_unitDirectionSet)
    (hAliceMeas bellB bellB_mem_unitDirectionSet)
    (hBobMeas bellB bellB_mem_unitDirectionSet)
    (hBobMeas bellC bellC_mem_unitDirectionSet)
    (hAliceBound bellA bellA_mem_unitDirectionSet)
    (hAliceBound bellB bellB_mem_unitDirectionSet)
    (hBobBound bellB bellB_mem_unitDirectionSet)
    (hBobBound bellC bellC_mem_unitDirectionSet)
    (hApprox.bound bellA_mem_unitDirectionSet bellB_mem_unitDirectionSet)
    (hApprox.bound bellA_mem_unitDirectionSet bellC_mem_unitDirectionSet)
    (hApprox.bound bellB_mem_unitDirectionSet bellC_mem_unitDirectionSet)
    (hApprox.bound bellB_mem_unitDirectionSet bellB_mem_unitDirectionSet)

/-- Bell's direction-specialized consequence of equation (22): errors `ε` and
`δ` from equations (16)–(17) add, and their total obeys the paper's numerical
bound.

The general vector form of equation (22) is not a separate declaration. The
intermediate target is arbitrary; constructing it by angular averaging and
proving equation (19) are separate obligations. -/
theorem bell1964_four_mul_total_error_lower_bound
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (averagedTarget : Direction → Direction → ℝ)
    (ε δ : ℝ)
    (hAliceMeas : ∀ a ∈ unitDirectionSet,
      AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBobMeas : ∀ b ∈ unitDirectionSet,
      AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAliceBound : ∀ a ∈ unitDirectionSet,
      IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse a))
    (hBobBound : ∀ b ∈ unitDirectionSet,
      IsAEBoundedByOne model.hiddenMeasure (model.bobResponse b))
    (h16 : UniformlyWithinOn unitDirectionSet unitDirectionSet
      (correlation model) averagedTarget ε)
    (h17 : UniformlyWithinOn unitDirectionSet unitDirectionSet
      averagedTarget singletCorrelation δ) :
    Real.sqrt 2 - 1 ≤ 4 * (ε + δ) := by
  have h18 := h16.trans_add h17
  have hlower := singlet_uniform_error_lower_bound_on_unitDirections
    model (ε + δ) hAliceMeas hBobMeas hAliceBound hBobBound h18
  linarith

/-- Bell's quantitative conclusion
`(sqrt(2)-1)/4 - δ <= ε` from the two explicit uniform-error hypotheses. -/
theorem bell1964_epsilon_lower_bound_of_uniform_averaging_errors
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (averagedTarget : Direction → Direction → ℝ)
    (ε δ : ℝ)
    (hAliceMeas : ∀ a ∈ unitDirectionSet,
      AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBobMeas : ∀ b ∈ unitDirectionSet,
      AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAliceBound : ∀ a ∈ unitDirectionSet,
      IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse a))
    (hBobBound : ∀ b ∈ unitDirectionSet,
      IsAEBoundedByOne model.hiddenMeasure (model.bobResponse b))
    (h16 : UniformlyWithinOn unitDirectionSet unitDirectionSet
      (correlation model) averagedTarget ε)
    (h17 : UniformlyWithinOn unitDirectionSet unitDirectionSet
      averagedTarget singletCorrelation δ) :
    (Real.sqrt 2 - 1) / 4 - δ ≤ ε := by
  have hfour := bell1964_four_mul_total_error_lower_bound model averagedTarget
    ε δ hAliceMeas hBobMeas hAliceBound hBobBound h16 h17
  linarith

/-- If Bell's averaging error is below the threshold, the local-versus-averaged
quantum error must be strictly positive. -/
theorem bell1964_epsilon_pos_of_uniform_averaging_errors
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (averagedTarget : Direction → Direction → ℝ)
    (ε δ : ℝ)
    (hAliceMeas : ∀ a ∈ unitDirectionSet,
      AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBobMeas : ∀ b ∈ unitDirectionSet,
      AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAliceBound : ∀ a ∈ unitDirectionSet,
      IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse a))
    (hBobBound : ∀ b ∈ unitDirectionSet,
      IsAEBoundedByOne model.hiddenMeasure (model.bobResponse b))
    (h16 : UniformlyWithinOn unitDirectionSet unitDirectionSet
      (correlation model) averagedTarget ε)
    (h17 : UniformlyWithinOn unitDirectionSet unitDirectionSet
      averagedTarget singletCorrelation δ)
    (hδ : δ < (Real.sqrt 2 - 1) / 4) :
    0 < ε := by
  have hlower := bell1964_epsilon_lower_bound_of_uniform_averaging_errors
    model averagedTarget ε δ hAliceMeas hBobMeas hAliceBound hBobBound h16 h17
  linarith

end Bell.Geometry
