module

public import Bell.HiddenVariable.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic

/-!
# Correlations of deterministic local models

The correlation is Bell's equation (2), modernized from a density to an
arbitrary measure. Normalization, measurability, and binary range are explicit
hypotheses of the analytic results rather than fields of the raw model.
-/

@[expose] public section

open MeasureTheory

namespace Bell.HiddenVariable

variable {SettingA SettingB Ω : Type*} [MeasurableSpace Ω]

/-- Expected product of the two local responses at fixed settings. -/
noncomputable def correlation
    (model : DeterministicLocalModel SettingA SettingB Ω)
    (a : SettingA) (b : SettingB) : ℝ :=
  ∫ ω, model.aliceResponse a ω * model.bobResponse b ω ∂model.hiddenMeasure

private theorem responseProduct_abs_eq_one_ae
    (model : DeterministicLocalModel SettingA SettingB Ω)
    (a : SettingA) (b : SettingB)
    (hA : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hB : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b)) :
    ∀ᵐ ω ∂model.hiddenMeasure,
      |model.aliceResponse a ω * model.bobResponse b ω| = 1 := by
  filter_upwards [hA, hB] with ω hAω hBω
  rw [abs_mul, hAω.abs_eq_one, hBω.abs_eq_one, one_mul]

/-- At fixed settings, measurable binary responses have an integrable product
under a normalized hidden-variable measure. -/
theorem responseProduct_integrable
    (model : DeterministicLocalModel SettingA SettingB Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a : SettingA) (b : SettingB)
    (hAmeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBmeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAbin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hBbin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b)) :
    Integrable
      (fun ω => model.aliceResponse a ω * model.bobResponse b ω)
      model.hiddenMeasure := by
  apply Integrable.of_bound (hAmeas.mul hBmeas).aestronglyMeasurable 1
  filter_upwards [responseProduct_abs_eq_one_ae model a b hAbin hBbin] with ω hω
  rw [Real.norm_eq_abs, hω]

/-- The absolute value of a binary-response correlation is at most one. -/
theorem abs_correlation_le_one
    (model : DeterministicLocalModel SettingA SettingB Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a : SettingA) (b : SettingB)
    (hAmeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBmeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAbin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hBbin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b)) :
    |correlation model a b| ≤ 1 := by
  have hbound : ∀ᵐ ω ∂model.hiddenMeasure,
      ‖model.aliceResponse a ω * model.bobResponse b ω‖ ≤ (1 : ℝ) := by
    filter_upwards [responseProduct_abs_eq_one_ae model a b hAbin hBbin] with ω hω
    rw [Real.norm_eq_abs, hω]
  have _ := responseProduct_integrable model a b hAmeas hBmeas hAbin hBbin
  simpa [correlation, Real.norm_eq_abs] using
    (norm_integral_le_of_norm_le_const (μ := model.hiddenMeasure) hbound)

theorem neg_one_le_correlation
    (model : DeterministicLocalModel SettingA SettingB Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a : SettingA) (b : SettingB)
    (hAmeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBmeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAbin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hBbin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b)) :
    -1 ≤ correlation model a b :=
  (abs_le.mp <| abs_correlation_le_one model a b hAmeas hBmeas hAbin hBbin).1

theorem correlation_le_one
    (model : DeterministicLocalModel SettingA SettingB Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a : SettingA) (b : SettingB)
    (hAmeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBmeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAbin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hBbin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b)) :
    correlation model a b ≤ 1 :=
  (abs_le.mp <| abs_correlation_le_one model a b hAmeas hBmeas hAbin hBbin).2

end Bell.HiddenVariable
