module

import Bell
import Mathlib.Data.ENNReal.Inv
import Mathlib.MeasureTheory.Measure.Dirac

/-!
# Bell original-inequality audit

This private audit checks the general theorem signatures, a normalized
two-point hidden-variable model with strict and sharp instances of the bound,
and an almost-everywhere (but not pointwise) extremal-correlation bridge.
-/

open MeasureTheory

set_option linter.privateModule false

namespace Bell.Audit.OriginalInequality

open HiddenVariable Inequality

section GeneralSignature

variable {Setting Ω : Type*} [MeasurableSpace Ω]

example (model : DeterministicLocalModel Setting Setting Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a b c : Setting)
    (hAaMeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hAbMeas : AEMeasurable (model.aliceResponse b) model.hiddenMeasure)
    (hBcMeas : AEMeasurable (model.bobResponse c) model.hiddenMeasure)
    (hAaBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hAbBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse b))
    (hBcBin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse c))
    (hanti : PerfectAnticorrelationAt model b) :
    |correlation model a b - correlation model a c| ≤
      1 + correlation model b c :=
  bell_original_of_perfectAnticorrelationAt model a b c
    hAaMeas hAbMeas hBcMeas hAaBin hAbBin hBcBin hanti

example (model : DeterministicLocalModel Setting Setting Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (a b c : Setting)
    (hAaMeas : AEMeasurable (model.aliceResponse a) model.hiddenMeasure)
    (hAbMeas : AEMeasurable (model.aliceResponse b) model.hiddenMeasure)
    (hBbMeas : AEMeasurable (model.bobResponse b) model.hiddenMeasure)
    (hBcMeas : AEMeasurable (model.bobResponse c) model.hiddenMeasure)
    (hAaBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse a))
    (hAbBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse b))
    (hBbBin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse b))
    (hBcBin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse c))
    (hcorrB : correlation model b b = -1) :
    |correlation model a b - correlation model a c| ≤
      1 + correlation model b c :=
  bell_original_of_diagonal_correlation_eq_neg_one model a b c
    hAaMeas hAbMeas hBbMeas hBcMeas hAaBin hAbBin hBbBin hBcBin hcorrB

end GeneralSignature

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

theorem integral_twoPoint (f : Bool → ℝ) :
    ∫ ω, f ω ∂twoPointMeasure = ((f false + f true) / 2) := by
  letI : IsFiniteMeasure ((2 : ENNReal)⁻¹ • Measure.dirac false) :=
    Measure.smul_finite _ (ENNReal.inv_ne_top.mpr (by norm_num))
  letI : IsFiniteMeasure ((2 : ENNReal)⁻¹ • Measure.dirac true) :=
    Measure.smul_finite _ (ENNReal.inv_ne_top.mpr (by norm_num))
  rw [twoPointMeasure,
    integral_add_measure Integrable.of_finite Integrable.of_finite]
  simp [div_eq_mul_inv, ENNReal.toReal_inv]
  ring

/-- Three settings: `a` flips with the hidden value, while `b` and `c` are
opposite constants. Bob is Alice's pointwise opposite. -/
noncomputable def twoPointModel : DeterministicLocalModel (Fin 3) (Fin 3) Bool where
  hiddenMeasure := twoPointMeasure
  aliceResponse := fun setting ω =>
    if setting = 0 then (if ω then -1 else 1)
    else if setting = 1 then 1
    else -1
  bobResponse := fun setting ω =>
    -(if setting = 0 then (if ω then -1 else 1)
      else if setting = 1 then 1
      else -1)

noncomputable instance : IsProbabilityMeasure twoPointModel.hiddenMeasure := by
  change IsProbabilityMeasure twoPointMeasure
  infer_instance

theorem twoPointModel_aliceBinary : AliceBinary twoPointModel := by
  intro setting ω
  fin_cases setting <;> cases ω <;>
    norm_num [twoPointModel, IsBinaryOutcome]

theorem twoPointModel_bobBinary : BobBinary twoPointModel := by
  intro setting ω
  fin_cases setting <;> cases ω <;>
    norm_num [twoPointModel, IsBinaryOutcome]

theorem twoPointModel_aliceAEMeasurable : AliceAEMeasurable twoPointModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem twoPointModel_bobAEMeasurable : BobAEMeasurable twoPointModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem twoPointModel_pointwisePerfect :
    PointwisePerfectAnticorrelation twoPointModel := by
  intro setting ω
  simp [twoPointModel]

theorem twoPointModel_correlation_ab :
    correlation twoPointModel 0 1 = 0 := by
  rw [correlation]
  simp only [twoPointModel]
  rw [integral_twoPoint]
  norm_num [twoPointModel]

theorem twoPointModel_correlation_ac :
    correlation twoPointModel 0 2 = 0 := by
  have h20 : (2 : Fin 3) ≠ 0 := by decide
  have h21 : (2 : Fin 3) ≠ 1 := by decide
  rw [correlation]
  simp only [twoPointModel]
  rw [integral_twoPoint]
  norm_num [twoPointModel, h20, h21]

theorem twoPointModel_correlation_bb :
    correlation twoPointModel 1 1 = -1 := by
  rw [correlation]
  simp only [twoPointModel]
  rw [integral_twoPoint]
  norm_num [twoPointModel]

theorem twoPointModel_correlation_bc :
    correlation twoPointModel 1 2 = 1 := by
  have h20 : (2 : Fin 3) ≠ 0 := by decide
  have h21 : (2 : Fin 3) ≠ 1 := by decide
  rw [correlation]
  simp only [twoPointModel]
  rw [integral_twoPoint]
  norm_num [twoPointModel, h20, h21]

/-- The direct abstract theorem applies to the nonconstant finite model. -/
theorem twoPointModel_bell :
    |correlation twoPointModel 0 1 - correlation twoPointModel 0 2| ≤
      1 + correlation twoPointModel 1 2 := by
  exact bell_original_of_perfectAnticorrelationAt twoPointModel 0 1 2
    (twoPointModel_aliceAEMeasurable 0)
    (twoPointModel_aliceAEMeasurable 1)
    (twoPointModel_bobAEMeasurable 2)
    (twoPointModel_aliceBinary.ae 0)
    (twoPointModel_aliceBinary.ae 1)
    (twoPointModel_bobBinary.ae 2)
    (twoPointModel_pointwisePerfect 1).ae

/-- The diagonal-correlation corollary also applies to the finite model. -/
theorem twoPointModel_bell_from_diagonal :
    |correlation twoPointModel 0 1 - correlation twoPointModel 0 2| ≤
      1 + correlation twoPointModel 1 2 := by
  exact bell_original_of_diagonal_correlation_eq_neg_one twoPointModel 0 1 2
    (twoPointModel_aliceAEMeasurable 0)
    (twoPointModel_aliceAEMeasurable 1)
    (twoPointModel_bobAEMeasurable 1)
    (twoPointModel_bobAEMeasurable 2)
    (twoPointModel_aliceBinary.ae 0)
    (twoPointModel_aliceBinary.ae 1)
    (twoPointModel_bobBinary.ae 1)
    (twoPointModel_bobBinary.ae 2)
    twoPointModel_correlation_bb

/-- Equation (14) is available at a fixed anticorrelated Bob setting. -/
theorem twoPointModel_equation14 :
    correlation twoPointModel 0 1 =
      -∫ ω, twoPointModel.aliceResponse 0 ω *
        twoPointModel.aliceResponse 1 ω ∂twoPointModel.hiddenMeasure :=
  correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt
    twoPointModel 0 1 (twoPointModel_pointwisePerfect 1).ae

/-- For `a = b`, the same finite model attains equality `2 = 2`. -/
theorem twoPointModel_sharp :
    |correlation twoPointModel 1 1 - correlation twoPointModel 1 2| =
      1 + correlation twoPointModel 1 2 := by
  rw [twoPointModel_correlation_bb, twoPointModel_correlation_bc]
  norm_num

/-- For the flipping setting `a`, the inequality is strict: `0 < 2`. -/
theorem twoPointModel_strict :
    |correlation twoPointModel 0 1 - correlation twoPointModel 0 2| <
      1 + correlation twoPointModel 1 2 := by
  rw [twoPointModel_correlation_ab, twoPointModel_correlation_ac,
    twoPointModel_correlation_bc]
  norm_num

end TwoPoint

section NullException

/-- A Dirac model whose one null hidden value violates pointwise
anticorrelation. -/
noncomputable def nullExceptionModel :
    DeterministicLocalModel Unit Unit Bool where
  hiddenMeasure := Measure.dirac false
  aliceResponse := fun _ _ => 1
  bobResponse := fun _ ω => if ω then 1 else -1

noncomputable instance :
    IsProbabilityMeasure nullExceptionModel.hiddenMeasure := by
  change IsProbabilityMeasure (Measure.dirac false)
  infer_instance

theorem nullExceptionModel_aliceAEMeasurable :
    AliceAEMeasurable nullExceptionModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem nullExceptionModel_bobAEMeasurable :
    BobAEMeasurable nullExceptionModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem nullExceptionModel_aliceBinary : AliceBinary nullExceptionModel := by
  intro setting ω
  norm_num [nullExceptionModel, IsBinaryOutcome]

theorem nullExceptionModel_bobBinary : BobBinary nullExceptionModel := by
  intro setting ω
  cases ω <;> norm_num [nullExceptionModel, IsBinaryOutcome]

theorem nullExceptionModel_correlation :
    correlation nullExceptionModel () () = -1 := by
  simp [correlation, nullExceptionModel]

/-- The extremal-correlation bridge yields the correct a.e. conclusion. -/
theorem nullExceptionModel_bridge :
    PerfectAnticorrelationAt nullExceptionModel () :=
  perfectAnticorrelationAt_of_correlation_eq_neg_one nullExceptionModel ()
    (nullExceptionModel_aliceAEMeasurable ())
    (nullExceptionModel_bobAEMeasurable ())
    (nullExceptionModel_aliceBinary.ae ())
    (nullExceptionModel_bobBinary.ae ())
    nullExceptionModel_correlation

/-- The bridge cannot be strengthened to a pointwise conclusion. -/
theorem nullExceptionModel_not_pointwise :
    ¬PointwisePerfectAnticorrelationAt nullExceptionModel () := by
  intro h
  have := h true
  norm_num [nullExceptionModel] at this

end NullException

section AssumptionBoundaries

/-! The following diagnostic models fail exactly one major premise at a time.
They are audit evidence, not part of the public API. -/

/-- Without perfect anticorrelation, normalized measurable binary responses can
violate the claimed inequality. -/
noncomputable def noAnticorrelationModel :
    DeterministicLocalModel Bool Bool Unit where
  hiddenMeasure := Measure.dirac ()
  aliceResponse := fun _ _ => 1
  bobResponse := fun setting _ => if setting then -1 else 1

noncomputable instance :
    IsProbabilityMeasure noAnticorrelationModel.hiddenMeasure := by
  change IsProbabilityMeasure (Measure.dirac ())
  infer_instance

theorem noAnticorrelationModel_aliceBinary :
    AliceBinary noAnticorrelationModel := by
  intro setting ω
  norm_num [noAnticorrelationModel, IsBinaryOutcome]

theorem noAnticorrelationModel_bobBinary :
    BobBinary noAnticorrelationModel := by
  intro setting ω
  cases setting <;> norm_num [noAnticorrelationModel, IsBinaryOutcome]

theorem noAnticorrelationModel_aliceAEMeasurable :
    AliceAEMeasurable noAnticorrelationModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem noAnticorrelationModel_bobAEMeasurable :
    BobAEMeasurable noAnticorrelationModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem noAnticorrelationModel_correlation_ff :
    correlation noAnticorrelationModel false false = 1 := by
  simp [correlation, noAnticorrelationModel]

theorem noAnticorrelationModel_correlation_ft :
    correlation noAnticorrelationModel false true = -1 := by
  simp [correlation, noAnticorrelationModel]

theorem noAnticorrelationModel_not_perfect :
    ¬PerfectAnticorrelationAt noAnticorrelationModel false := by
  norm_num [PerfectAnticorrelationAt, noAnticorrelationModel, ae_dirac_eq]

theorem noAnticorrelationModel_violates :
    ¬|correlation noAnticorrelationModel false false -
        correlation noAnticorrelationModel false true| ≤
      1 + correlation noAnticorrelationModel false true := by
  rw [noAnticorrelationModel_correlation_ff,
    noAnticorrelationModel_correlation_ft]
  norm_num

/-- Without the binary-range premise, even a normalized pointwise-perfect
model can violate the inequality. -/
noncomputable def noBinaryModel :
    DeterministicLocalModel Unit Unit Unit where
  hiddenMeasure := Measure.dirac ()
  aliceResponse := fun _ _ => 2
  bobResponse := fun _ _ => -2

noncomputable instance : IsProbabilityMeasure noBinaryModel.hiddenMeasure := by
  change IsProbabilityMeasure (Measure.dirac ())
  infer_instance

theorem noBinaryModel_aliceAEMeasurable : AliceAEMeasurable noBinaryModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem noBinaryModel_bobAEMeasurable : BobAEMeasurable noBinaryModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem noBinaryModel_pointwisePerfect :
    PointwisePerfectAnticorrelation noBinaryModel := by
  intro setting ω
  cases setting
  cases ω
  norm_num [noBinaryModel]

theorem noBinaryModel_not_aliceBinary : ¬AliceBinary noBinaryModel := by
  intro h
  have hbad := h () ()
  norm_num [noBinaryModel, IsBinaryOutcome] at hbad

theorem noBinaryModel_correlation :
    correlation noBinaryModel () () = -4 := by
  simp [correlation, noBinaryModel]
  norm_num

theorem noBinaryModel_violates :
    ¬|correlation noBinaryModel () () - correlation noBinaryModel () ()| ≤
      1 + correlation noBinaryModel () () := by
  rw [noBinaryModel_correlation]
  norm_num

/-- A measure of total mass two shows why probability normalization cannot be
omitted, even with measurable pointwise-binary perfectly anticorrelated
responses. -/
noncomputable def massTwo : Measure Unit :=
  (2 : ENNReal) • Measure.dirac ()

theorem massTwo_univ : massTwo Set.univ = 2 := by
  simp [massTwo]

noncomputable def noNormalizationModel :
    DeterministicLocalModel Unit Unit Unit where
  hiddenMeasure := massTwo
  aliceResponse := fun _ _ => 1
  bobResponse := fun _ _ => -1

theorem noNormalizationModel_aliceBinary :
    AliceBinary noNormalizationModel := by
  intro setting ω
  norm_num [noNormalizationModel, IsBinaryOutcome]

theorem noNormalizationModel_bobBinary : BobBinary noNormalizationModel := by
  intro setting ω
  norm_num [noNormalizationModel, IsBinaryOutcome]

theorem noNormalizationModel_aliceAEMeasurable :
    AliceAEMeasurable noNormalizationModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem noNormalizationModel_bobAEMeasurable :
    BobAEMeasurable noNormalizationModel :=
  fun _ => (measurable_of_finite _).aemeasurable

theorem noNormalizationModel_pointwisePerfect :
    PointwisePerfectAnticorrelation noNormalizationModel := by
  intro setting ω
  cases setting
  cases ω
  norm_num [noNormalizationModel]

theorem noNormalizationModel_correlation :
    correlation noNormalizationModel () () = -2 := by
  rw [correlation]
  simp only [noNormalizationModel, massTwo, one_mul]
  calc
    (∫ _ : Unit, (-(1 : ℝ)) ∂(2 : ENNReal) • Measure.dirac ()) =
        (2 : ENNReal).toReal • ∫ _ : Unit, (-(1 : ℝ)) ∂Measure.dirac () :=
      integral_smul_measure _ _
    _ = -2 := by norm_num

theorem noNormalizationModel_violates :
    ¬|correlation noNormalizationModel () () -
        correlation noNormalizationModel () ()| ≤
      1 + correlation noNormalizationModel () () := by
  rw [noNormalizationModel_correlation]
  norm_num

end AssumptionBoundaries

#print axioms Bell.HiddenVariable.perfectAnticorrelationAt_of_correlation_eq_neg_one
#print axioms Bell.HiddenVariable.correlation_eq_neg_integral_alice_mul_of_perfectAnticorrelationAt
#print axioms Bell.Inequality.bell_original_of_perfectAnticorrelationAt
#print axioms Bell.Inequality.bell_original_of_diagonal_correlation_eq_neg_one

end Bell.Audit.OriginalInequality
