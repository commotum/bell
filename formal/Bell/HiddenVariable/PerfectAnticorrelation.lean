module

public import Bell.HiddenVariable.Basic

/-!
# Perfect anticorrelation predicates

The setting-wise a.e. predicate matches the quantifier scope justified by
Bell's equation (13). It does not assert one common full-measure set for all
settings.
-/

@[expose] public section

namespace Bell.HiddenVariable

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

end Bell.HiddenVariable
