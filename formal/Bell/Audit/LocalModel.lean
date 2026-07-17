module

import Bell.HiddenVariable.Correlation
import Bell.HiddenVariable.PerfectAnticorrelation
import Mathlib.Data.ENNReal.Inv
import Mathlib.MeasureTheory.Measure.Dirac

/-!
# Local-model API audit

This non-exported module checks the general measure signature, a genuine
two-point probability model, exact boundary correlations, and the distinction
between pointwise and almost-everywhere anticorrelation.
-/

open MeasureTheory

set_option linter.privateModule false

namespace Bell.Audit.LocalModel

open HiddenVariable

section GeneralMeasure

variable {SettingA SettingB Ω : Type*} [MeasurableSpace Ω]

/-- The raw API accepts an arbitrary measure and does not require a density. -/
example (μ : Measure Ω) (A : SettingA → Ω → ℝ) (B : SettingB → Ω → ℝ) :
    DeterministicLocalModel SettingA SettingB Ω where
  hiddenMeasure := μ
  aliceResponse := A
  bobResponse := B

/-- The same fixed measure is used at every pair of settings. -/
noncomputable example (model : DeterministicLocalModel SettingA SettingB Ω)
    (a : SettingA) (b : SettingB) : ℝ :=
  correlation model a b

example (model : DeterministicLocalModel SettingA SettingB Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (hAmeas : AliceAEMeasurable model) (hBmeas : BobAEMeasurable model)
    (hAbin : AliceAEBinary model) (hBbin : BobAEBinary model)
    (a : SettingA) (b : SettingB) :
    correlation model a b ∈ Set.Icc (-1 : ℝ) 1 :=
  correlation_mem_Icc model a b (hAmeas a) (hBmeas b) (hAbin a) (hBbin b)

end GeneralMeasure

section TwoPoint

/-- Equal mixture of the two Boolean hidden-variable values. -/
noncomputable def twoPointMeasure : Measure Bool :=
  (2 : ENNReal)⁻¹ • Measure.dirac false +
    (2 : ENNReal)⁻¹ • Measure.dirac true

noncomputable instance : IsProbabilityMeasure twoPointMeasure where
  measure_univ := by
    simp only [twoPointMeasure, Measure.coe_add, Pi.add_apply,
      Measure.smul_apply, smul_eq_mul,
      Measure.dirac_apply_of_mem (Set.mem_univ false),
      Measure.dirac_apply_of_mem (Set.mem_univ true), mul_one]
    exact ENNReal.inv_two_add_inv_two

theorem twoPointMeasure_false : twoPointMeasure {false} = (2 : ENNReal)⁻¹ := by
  simp [twoPointMeasure]

theorem twoPointMeasure_true : twoPointMeasure {true} = (2 : ENNReal)⁻¹ := by
  simp [twoPointMeasure]

theorem twoPointMeasure_false_pos : 0 < twoPointMeasure {false} := by
  rw [twoPointMeasure_false]
  positivity

theorem twoPointMeasure_true_pos : 0 < twoPointMeasure {true} := by
  rw [twoPointMeasure_true]
  positivity

/-- A nonconstant finite model: Bob's response is Alice's opposite at the same
setting and hidden-variable value. -/
noncomputable def twoPointModel : DeterministicLocalModel Bool Bool Bool where
  hiddenMeasure := twoPointMeasure
  aliceResponse := fun setting ω => if setting = ω then 1 else -1
  bobResponse := fun setting ω => if setting = ω then -1 else 1

noncomputable instance : IsProbabilityMeasure twoPointModel.hiddenMeasure := by
  change IsProbabilityMeasure twoPointMeasure
  infer_instance

theorem twoPointModel_aliceBinary : AliceBinary twoPointModel := by
  intro setting ω
  by_cases h : setting = ω <;>
    simp [twoPointModel, h, IsBinaryOutcome]

theorem twoPointModel_bobBinary : BobBinary twoPointModel := by
  intro setting ω
  by_cases h : setting = ω <;>
    simp [twoPointModel, h, IsBinaryOutcome]

theorem twoPointModel_aliceAEMeasurable : AliceAEMeasurable twoPointModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem twoPointModel_bobAEMeasurable : BobAEMeasurable twoPointModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem twoPointModel_pointwisePerfect :
    PointwisePerfectAnticorrelation twoPointModel := by
  intro setting ω
  by_cases h : setting = ω <;> simp [twoPointModel, h]

theorem twoPointModel_correlation_same (setting : Bool) :
    correlation twoPointModel setting setting = -1 := by
  apply integral_eq_const
  filter_upwards with ω
  by_cases h : setting = ω <;> simp [twoPointModel, h]

theorem twoPointModel_correlation_opposite (setting : Bool) :
    correlation twoPointModel setting setting.not = 1 := by
  apply integral_eq_const
  filter_upwards with ω
  cases setting <;> cases ω <;> norm_num [twoPointModel]

end TwoPoint

section NullException

/-- A Dirac model with one zero-probability failure of anticorrelation. -/
noncomputable def nullExceptionModel : DeterministicLocalModel Unit Unit Bool where
  hiddenMeasure := Measure.dirac false
  aliceResponse := fun _ _ => 1
  bobResponse := fun _ ω => if ω then 1 else -1

theorem nullExceptionModel_ae :
    PerfectAnticorrelationAt nullExceptionModel () := by
  change (1 : Bool → ℝ) =ᵐ[Measure.dirac false]
    fun ω => -(if ω then 1 else -1)
  simpa using
    (ae_eq_dirac (a := false)
      (fun ω : Bool => -(if ω then (1 : ℝ) else -1))).symm

theorem nullExceptionModel_not_pointwise :
    ¬PointwisePerfectAnticorrelationAt nullExceptionModel () := by
  intro h
  have := h true
  norm_num [nullExceptionModel] at this

end NullException

#print axioms Bell.HiddenVariable.IsBinaryOutcome.abs_eq_one
#print axioms Bell.HiddenVariable.responseProduct_integrable
#print axioms Bell.HiddenVariable.abs_correlation_le_one
#print axioms Bell.HiddenVariable.neg_one_le_correlation
#print axioms Bell.HiddenVariable.correlation_le_one
#print axioms Bell.HiddenVariable.correlation_mem_Icc
#print axioms Bell.HiddenVariable.PointwisePerfectAnticorrelationAt.ae

end Bell.Audit.LocalModel
