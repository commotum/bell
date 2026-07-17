module

public import Mathlib.MeasureTheory.Measure.ProbabilityMeasure

/-!
# Deterministic local hidden-variable models

This module defines only the raw response-function interface and separately
named assumptions. In particular, the structure does not bundle probability
normalization, measurability, or the binary outcome range.

The response arities encode the deterministic locality condition used in
Bell's 1964 argument: Alice's result has no Bob setting argument and Bob's
result has no Alice setting argument. The single hidden-variable measure has no
measurement-setting argument, encoding measurement-setting independence for
this model class.
-/

@[expose] public section

open MeasureTheory

namespace Bell.HiddenVariable

/-- A real outcome is binary when it is exactly `-1` or `1`. -/
def IsBinaryOutcome (x : ℝ) : Prop :=
  x = -1 ∨ x = 1

/-- Pointwise binary range for a real-valued response. -/
def IsBinaryValued {Ω : Type*} (f : Ω → ℝ) : Prop :=
  ∀ ω, IsBinaryOutcome (f ω)

/-- Almost-everywhere binary range for a real-valued response. -/
def IsAEBinaryValued {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (f : Ω → ℝ) : Prop :=
  ∀ᵐ ω ∂μ, IsBinaryOutcome (f ω)

theorem IsBinaryOutcome.abs_eq_one {x : ℝ} (hx : IsBinaryOutcome x) : |x| = 1 := by
  rcases hx with rfl | rfl <;> norm_num

theorem IsBinaryOutcome.neg_one_le {x : ℝ} (hx : IsBinaryOutcome x) : -1 ≤ x := by
  rcases hx with rfl | rfl <;> norm_num

theorem IsBinaryOutcome.le_one {x : ℝ} (hx : IsBinaryOutcome x) : x ≤ 1 := by
  rcases hx with rfl | rfl <;> norm_num

theorem IsBinaryValued.ae {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {f : Ω → ℝ} (hf : IsBinaryValued f) :
    IsAEBinaryValued μ f :=
  Filter.Eventually.of_forall hf

/-- Raw deterministic response functions with one fixed hidden-variable measure.

No proof field asserts normalization, binary range, or measurability. Those
assumptions are deliberately separate below and in theorem signatures. -/
structure DeterministicLocalModel
    (SettingA SettingB Ω : Type*) [MeasurableSpace Ω] where
  hiddenMeasure : Measure Ω
  aliceResponse : SettingA → Ω → ℝ
  bobResponse : SettingB → Ω → ℝ

variable {SettingA SettingB Ω : Type*} [MeasurableSpace Ω]

/-- Every Alice response is pointwise binary. -/
def AliceBinary
    (model : DeterministicLocalModel SettingA SettingB Ω) : Prop :=
  ∀ a, IsBinaryValued (model.aliceResponse a)

/-- Every Bob response is pointwise binary. -/
def BobBinary
    (model : DeterministicLocalModel SettingA SettingB Ω) : Prop :=
  ∀ b, IsBinaryValued (model.bobResponse b)

/-- Every Alice response is binary almost everywhere, setting by setting. -/
def AliceAEBinary
    (model : DeterministicLocalModel SettingA SettingB Ω) : Prop :=
  ∀ a, IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a)

/-- Every Bob response is binary almost everywhere, setting by setting. -/
def BobAEBinary
    (model : DeterministicLocalModel SettingA SettingB Ω) : Prop :=
  ∀ b, IsAEBinaryValued model.hiddenMeasure (model.bobResponse b)

/-- Every Alice response is a.e. measurable, setting by setting. -/
def AliceAEMeasurable
    (model : DeterministicLocalModel SettingA SettingB Ω) : Prop :=
  ∀ a, AEMeasurable (model.aliceResponse a) model.hiddenMeasure

/-- Every Bob response is a.e. measurable, setting by setting. -/
def BobAEMeasurable
    (model : DeterministicLocalModel SettingA SettingB Ω) : Prop :=
  ∀ b, AEMeasurable (model.bobResponse b) model.hiddenMeasure

theorem AliceBinary.ae
    {model : DeterministicLocalModel SettingA SettingB Ω}
    (h : AliceBinary model) : AliceAEBinary model :=
  fun a => (h a).ae

theorem BobBinary.ae
    {model : DeterministicLocalModel SettingA SettingB Ω}
    (h : BobBinary model) : BobAEBinary model :=
  fun b => (h b).ae

end Bell.HiddenVariable
