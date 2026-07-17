module

public import Bell.HiddenVariable.Basic
import Mathlib.MeasureTheory.Integral.Bochner.Basic

/-!
# Response functions bounded by one

Bell's averaged responses in equations (19)–(20) need not be binary. This
module keeps pointwise and almost-everywhere `abs <= 1` assumptions separate
from the existing binary predicates and supplies their elementary bridges.
-/

@[expose] public section

open MeasureTheory

namespace Bell.HiddenVariable

/-- A real response function is bounded by one at every hidden-variable value. -/
def IsBoundedByOne {Ω : Type*} (f : Ω → ℝ) : Prop :=
  ∀ ω, |f ω| ≤ 1

/-- A real response function is bounded by one almost everywhere. -/
def IsAEBoundedByOne {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (f : Ω → ℝ) : Prop :=
  ∀ᵐ ω ∂μ, |f ω| ≤ 1

theorem IsBoundedByOne.ae {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {f : Ω → ℝ} (h : IsBoundedByOne f) :
    IsAEBoundedByOne μ f :=
  Filter.Eventually.of_forall h

theorem IsBinaryValued.boundedByOne {Ω : Type*} {f : Ω → ℝ}
    (h : IsBinaryValued f) : IsBoundedByOne f := by
  intro ω
  rw [(h ω).abs_eq_one]

theorem IsAEBinaryValued.boundedByOne {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} {f : Ω → ℝ} (h : IsAEBinaryValued μ f) :
    IsAEBoundedByOne μ f := by
  filter_upwards [h] with ω hω
  rw [hω.abs_eq_one]

variable {SettingA SettingB Ω : Type*} [MeasurableSpace Ω]

/-- Every Alice response is pointwise bounded by one. -/
def AliceBoundedByOne
    (model : DeterministicLocalModel SettingA SettingB Ω) : Prop :=
  ∀ a, IsBoundedByOne (model.aliceResponse a)

/-- Every Bob response is pointwise bounded by one. -/
def BobBoundedByOne
    (model : DeterministicLocalModel SettingA SettingB Ω) : Prop :=
  ∀ b, IsBoundedByOne (model.bobResponse b)

/-- Every Alice response is bounded by one a.e., setting by setting. -/
def AliceAEBoundedByOne
    (model : DeterministicLocalModel SettingA SettingB Ω) : Prop :=
  ∀ a, IsAEBoundedByOne model.hiddenMeasure (model.aliceResponse a)

/-- Every Bob response is bounded by one a.e., setting by setting. -/
def BobAEBoundedByOne
    (model : DeterministicLocalModel SettingA SettingB Ω) : Prop :=
  ∀ b, IsAEBoundedByOne model.hiddenMeasure (model.bobResponse b)

theorem AliceBoundedByOne.ae
    {model : DeterministicLocalModel SettingA SettingB Ω}
    (h : AliceBoundedByOne model) : AliceAEBoundedByOne model :=
  fun a => (h a).ae

theorem BobBoundedByOne.ae
    {model : DeterministicLocalModel SettingA SettingB Ω}
    (h : BobBoundedByOne model) : BobAEBoundedByOne model :=
  fun b => (h b).ae

theorem AliceBinary.boundedByOne
    {model : DeterministicLocalModel SettingA SettingB Ω}
    (h : AliceBinary model) : AliceBoundedByOne model :=
  fun a => (h a).boundedByOne

theorem BobBinary.boundedByOne
    {model : DeterministicLocalModel SettingA SettingB Ω}
    (h : BobBinary model) : BobBoundedByOne model :=
  fun b => (h b).boundedByOne

theorem AliceAEBinary.boundedByOne
    {model : DeterministicLocalModel SettingA SettingB Ω}
    (h : AliceAEBinary model) : AliceAEBoundedByOne model :=
  fun a => (h a).boundedByOne

theorem BobAEBinary.boundedByOne
    {model : DeterministicLocalModel SettingA SettingB Ω}
    (h : BobAEBinary model) : BobAEBoundedByOne model :=
  fun b => (h b).boundedByOne

/-- Products of a.e.-measurable responses bounded by one are integrable under
any finite hidden-variable measure. -/
theorem boundedProduct_integrable
    {μ : Measure Ω} [IsFiniteMeasure μ] {f g : Ω → ℝ}
    (hfmeas : AEMeasurable f μ) (hgmeas : AEMeasurable g μ)
    (hfbound : IsAEBoundedByOne μ f) (hgbound : IsAEBoundedByOne μ g) :
    Integrable (fun ω => f ω * g ω) μ := by
  apply Integrable.of_bound (hfmeas.mul hgmeas).aestronglyMeasurable 1
  filter_upwards [hfbound, hgbound] with ω hfω hgω
  rw [Real.norm_eq_abs, abs_mul]
  exact mul_le_one₀ hfω (abs_nonneg _) hgω

end Bell.HiddenVariable
