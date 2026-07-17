module

public import Bell.HiddenVariable.Correlation

/-!
# Reproduction of a target correlation

These predicates state only equality between a hidden-variable correlation and
an independently supplied target correlation. They do not bundle probability
normalization, response measurability, binary outcomes, perfect
anticorrelation, or any physical interpretation.
-/

@[expose] public section

namespace Bell.HiddenVariable

variable {SettingA SettingB Ω : Type*} [MeasurableSpace Ω]

/-- A model reproduces a target correlation at one specified setting pair. -/
def ReproducesCorrelationAt
    (model : DeterministicLocalModel SettingA SettingB Ω)
    (target : SettingA → SettingB → ℝ) (a : SettingA) (b : SettingB) : Prop :=
  correlation model a b = target a b

/-- A model reproduces a target correlation at every setting pair.

This is a pointwise-in-settings family of expectation equalities; it makes no
claim about common hidden-variable null sets. -/
def ReproducesCorrelation
    (model : DeterministicLocalModel SettingA SettingB Ω)
    (target : SettingA → SettingB → ℝ) : Prop :=
  ∀ a b, ReproducesCorrelationAt model target a b

theorem ReproducesCorrelation.at
    {model : DeterministicLocalModel SettingA SettingB Ω}
    {target : SettingA → SettingB → ℝ}
    (h : ReproducesCorrelation model target) (a : SettingA) (b : SettingB) :
    ReproducesCorrelationAt model target a b :=
  h a b

end Bell.HiddenVariable
