module

public import Bell.HiddenVariable.Correlation
import Mathlib.MeasureTheory.Integral.Bochner.Basic

/-!
# Perfect anticorrelation predicates

The setting-wise a.e. predicate matches the quantifier scope justified by
Bell's equation (13). It does not assert one common full-measure set for all
settings.
-/

@[expose] public section

namespace Bell.HiddenVariable

open MeasureTheory

variable {SettingType Ω : Type*} [MeasurableSpace Ω]

/-- Exact anticorrelation at one setting and every hidden-variable value. -/
def PointwisePerfectAnticorrelationAt
    (model : DeterministicLocalModel SettingType SettingType Ω)
    (setting : SettingType) : Prop :=
  ∀ ω, model.aliceResponse setting ω = -model.bobResponse setting ω

/-- Anticorrelation at one fixed setting, almost everywhere. -/
def PerfectAnticorrelationAt
    (model : DeterministicLocalModel SettingType SettingType Ω)
    (setting : SettingType) : Prop :=
  model.aliceResponse setting =ᵐ[model.hiddenMeasure]
    fun ω => -model.bobResponse setting ω

/-- Pointwise perfect anticorrelation at every setting. -/
def PointwisePerfectAnticorrelation
    (model : DeterministicLocalModel SettingType SettingType Ω) : Prop :=
  ∀ setting, PointwisePerfectAnticorrelationAt model setting

/-- Perfect anticorrelation setting by setting: `∀ setting, ∀ᵐ ω, ...`.

This definition deliberately does not exchange those quantifiers. -/
def PerfectAnticorrelation
    (model : DeterministicLocalModel SettingType SettingType Ω) : Prop :=
  ∀ setting, PerfectAnticorrelationAt model setting

theorem PointwisePerfectAnticorrelationAt.ae
    {model : DeterministicLocalModel SettingType SettingType Ω}
    {setting : SettingType}
    (h : PointwisePerfectAnticorrelationAt model setting) :
    PerfectAnticorrelationAt model setting :=
  Filter.Eventually.of_forall h

theorem PointwisePerfectAnticorrelation.ae
    {model : DeterministicLocalModel SettingType SettingType Ω}
    (h : PointwisePerfectAnticorrelation model) :
    PerfectAnticorrelation model :=
  fun setting => (h setting).ae

/-- Bell's equation (13) at one fixed setting: an extremal correlation of `-1`
forces perfect anticorrelation almost everywhere.

Normalization, measurability, and binary range are independent hypotheses. -/
theorem perfectAnticorrelationAt_of_correlation_eq_neg_one
    (model : DeterministicLocalModel SettingType SettingType Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (setting : SettingType)
    (hAmeas : AEMeasurable (model.aliceResponse setting) model.hiddenMeasure)
    (hBmeas : AEMeasurable (model.bobResponse setting) model.hiddenMeasure)
    (hAbin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse setting))
    (hBbin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse setting))
    (hcorr : correlation model setting setting = -1) :
    PerfectAnticorrelationAt model setting := by
  let defect : Ω → ℝ := fun ω =>
    model.aliceResponse setting ω * model.bobResponse setting ω + 1
  have hprod := responseProduct_integrable model setting setting
    hAmeas hBmeas hAbin hBbin
  have hdefectInt : Integrable defect model.hiddenMeasure := by
    exact hprod.add (integrable_const (1 : ℝ))
  have hdefectNonneg : 0 ≤ᵐ[model.hiddenMeasure] defect := by
    filter_upwards [hAbin, hBbin] with ω hAω hBω
    rcases hAω with hAω | hAω <;>
      rcases hBω with hBω | hBω <;>
      norm_num [defect, hAω, hBω]
  have hdefectIntegral : ∫ ω, defect ω ∂model.hiddenMeasure = 0 := by
    calc
      ∫ ω, defect ω ∂model.hiddenMeasure =
          (∫ ω, model.aliceResponse setting ω * model.bobResponse setting ω
            ∂model.hiddenMeasure) +
          ∫ _ : Ω, (1 : ℝ) ∂model.hiddenMeasure := by
            exact integral_add hprod (integrable_const (1 : ℝ))
      _ = correlation model setting setting + 1 := by simp [correlation]
      _ = 0 := by rw [hcorr]; norm_num
  have hdefectZero : defect =ᵐ[model.hiddenMeasure] 0 :=
    (integral_eq_zero_iff_of_nonneg_ae hdefectNonneg hdefectInt).mp hdefectIntegral
  filter_upwards [hdefectZero, hAbin, hBbin] with ω hzero hAω hBω
  rcases hAω with hAω | hAω <;> rcases hBω with hBω | hBω
  · norm_num [defect, hAω, hBω] at hzero
  · norm_num [hAω, hBω]
  · norm_num [hAω, hBω]
  · norm_num [defect, hAω, hBω] at hzero

/-- Bell's equation (14), using perfect anticorrelation at Bob's setting. -/
theorem correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt
    (model : DeterministicLocalModel SettingType SettingType Ω)
    (aliceSetting bobSetting : SettingType)
    (hanti : PerfectAnticorrelationAt model bobSetting) :
    correlation model aliceSetting bobSetting =
      -∫ ω, model.aliceResponse aliceSetting ω * model.aliceResponse bobSetting ω
        ∂model.hiddenMeasure := by
  rw [correlation]
  calc
    (∫ ω, model.aliceResponse aliceSetting ω * model.bobResponse bobSetting ω
        ∂model.hiddenMeasure) =
        ∫ ω, -(model.aliceResponse aliceSetting ω * model.aliceResponse bobSetting ω)
          ∂model.hiddenMeasure := by
      apply integral_congr_ae
      filter_upwards [hanti] with ω hω
      have hb : model.bobResponse bobSetting ω =
          -model.aliceResponse bobSetting ω := by
        linarith
      rw [hb]
      ring
    _ = -∫ ω, model.aliceResponse aliceSetting ω * model.aliceResponse bobSetting ω
          ∂model.hiddenMeasure := integral_neg _

end Bell.HiddenVariable
