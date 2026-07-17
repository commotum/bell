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

private theorem responseProduct_mem_Icc_ae
    (model : DeterministicLocalModel SettingA SettingB Ω)
    (a : SettingA) (b : SettingB)
    (hA : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hB : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b)) :
    ∀ᵐ ω ∂model.hiddenMeasure,
      model.aliceResponse a ω * model.bobResponse b ω ∈ Set.Icc (-1 : ℝ) 1 := by
  filter_upwards [responseProduct_abs_eq_one_ae model a b hA hB] with ω hω
  exact abs_le.mp (by rw [hω])

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

/-- A binary-response correlation is at least `-1`. -/
theorem neg_one_le_correlation
    (model : DeterministicLocalModel SettingA SettingB Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a : SettingA) (b : SettingB)
    (hAmeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBmeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAbin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hBbin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b)) :
    -1 ≤ correlation model a b :=
  by
    have hprod := responseProduct_integrable model a b hAmeas hBmeas hAbin hBbin
    have hle : (fun _ : Ω => (-1 : ℝ)) ≤ᵐ[model.hiddenMeasure]
        fun ω => model.aliceResponse a ω * model.bobResponse b ω :=
      (responseProduct_mem_Icc_ae model a b hAbin hBbin).mono fun _ h => h.1
    simpa [correlation] using
      (integral_mono_ae (integrable_const (-1 : ℝ)) hprod hle)

/-- A binary-response correlation is at most `1`. -/
theorem correlation_le_one
    (model : DeterministicLocalModel SettingA SettingB Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a : SettingA) (b : SettingB)
    (hAmeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBmeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAbin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hBbin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b)) :
    correlation model a b ≤ 1 := by
  have hprod := responseProduct_integrable model a b hAmeas hBmeas hAbin hBbin
  have hle : (fun ω => model.aliceResponse a ω * model.bobResponse b ω)
      ≤ᵐ[model.hiddenMeasure] fun _ : Ω => (1 : ℝ) :=
    (responseProduct_mem_Icc_ae model a b hAbin hBbin).mono fun _ h => h.2
  simpa [correlation] using
    (integral_mono_ae hprod (integrable_const (1 : ℝ)) hle)

/-- The absolute value of a binary-response correlation is at most one. -/
theorem abs_correlation_le_one
    (model : DeterministicLocalModel SettingA SettingB Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a : SettingA) (b : SettingB)
    (hAmeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBmeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAbin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hBbin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b)) :
    |correlation model a b| ≤ 1 :=
  abs_le.mpr
    ⟨neg_one_le_correlation model a b hAmeas hBmeas hAbin hBbin,
      correlation_le_one model a b hAmeas hBmeas hAbin hBbin⟩

/-- Interval-valued form of the two correlation bounds. -/
theorem correlation_mem_Icc
    (model : DeterministicLocalModel SettingA SettingB Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a : SettingA) (b : SettingB)
    (hAmeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hBmeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hAbin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hBbin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b)) :
    correlation model a b ∈ Set.Icc (-1 : ℝ) 1 :=
  ⟨neg_one_le_correlation model a b hAmeas hBmeas hAbin hBbin,
    correlation_le_one model a b hAmeas hBmeas hAbin hBbin⟩

end Bell.HiddenVariable
