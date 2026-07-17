module

public import Bell.Geometry.BellDirections
public import Bell.HiddenVariable.Reproduction
public import Bell.Inequality.Original
public import Bell.Quantum.Singlet

/-!
# The singlet violation of Bell's original inequality

This is the first public module joining the abstract hidden-variable inequality
to the independent finite-matrix singlet calculation. It proves a numerical
violation at three explicit unit directions and finite/global correlation
non-reproduction results. No physical signaling or spacetime conclusion is
stated.
-/

@[expose] public section

open MeasureTheory

namespace Bell.Geometry

open HiddenVariable Inequality Quantum

theorem singletCorrelation_bellA_bellB :
    singletCorrelation bellA bellB = -bellScale := by
  rw [singlet_spin_correlation, bellA_inner_bellB]

theorem singletCorrelation_bellA_bellC :
    singletCorrelation bellA bellC = 0 := by
  rw [singlet_spin_correlation, bellA_inner_bellC]
  norm_num

theorem singletCorrelation_bellB_bellC :
    singletCorrelation bellB bellC = -bellScale := by
  rw [singlet_spin_correlation, bellB_inner_bellC]

theorem singletCorrelation_bellB_bellB :
    singletCorrelation bellB bellB = -1 := by
  rw [singlet_spin_correlation, bellB_inner_self]

theorem singlet_bell_original_lhs :
    |singletCorrelation bellA bellB - singletCorrelation bellA bellC| =
      bellScale := by
  rw [singletCorrelation_bellA_bellB, singletCorrelation_bellA_bellC]
  simpa using abs_of_pos bellScale_pos

theorem singlet_bell_original_rhs :
    1 + singletCorrelation bellB bellC = 1 - bellScale := by
  rw [singletCorrelation_bellB_bellC]
  ring

/-- The right side of equation (15) is strictly smaller than its left side for
the calculated singlet correlations at Bell's directions. -/
theorem singlet_bell_original_strict_violation :
    1 + singletCorrelation bellB bellC <
      |singletCorrelation bellA bellB - singletCorrelation bellA bellC| := by
  rw [singlet_bell_original_lhs, singlet_bell_original_rhs]
  exact one_sub_bellScale_lt_bellScale

/-- The explicitly calculated singlet predictions violate Bell's equation (15)
at the concrete unit directions. -/
theorem singlet_violates_bell_original :
    ¬ |singletCorrelation bellA bellB - singletCorrelation bellA bellC| ≤
      1 + singletCorrelation bellB bellC :=
  not_le_of_gt singlet_bell_original_strict_violation

variable {Ω : Type*} [MeasurableSpace Ω]

/-- Three off-diagonal singlet-correlation equalities contradict fixed-setting
perfect anticorrelation in a normalized deterministic local model. -/
theorem singletCorrelations_incompatible_with_perfectAnticorrelationAt_bellB
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (hAaMeas : AEMeasurable (model.aliceResponse bellA) model.hiddenMeasure)
    (hAbMeas : AEMeasurable (model.aliceResponse bellB) model.hiddenMeasure)
    (hBcMeas : AEMeasurable (model.bobResponse bellC) model.hiddenMeasure)
    (hAaBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse bellA))
    (hAbBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse bellB))
    (hBcBin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse bellC))
    (hanti : PerfectAnticorrelationAt model bellB)
    (hAB : ReproducesCorrelationAt model singletCorrelation bellA bellB)
    (hAC : ReproducesCorrelationAt model singletCorrelation bellA bellC)
    (hBC : ReproducesCorrelationAt model singletCorrelation bellB bellC) :
    False := by
  have hbound := bell_original_of_perfectAnticorrelationAt
    model bellA bellB bellC hAaMeas hAbMeas hBcMeas
      hAaBin hAbBin hBcBin hanti
  rw [hAB, hAC, hBC] at hbound
  exact singlet_violates_bell_original hbound

/-- The four required singlet-correlation equalities are incompatible with a
normalized deterministic local model having measurable binary responses.

Determinism and local response dependence are encoded by the response arities
of `DeterministicLocalModel`; its single measure, with no setting argument,
encodes measurement-setting independence. Normalization, fixed-setting
measurability, a.e. binary range, and correlation reproduction remain separate
hypotheses below. -/
theorem singletCorrelations_incompatible_with_deterministicLocalModel_at_bellDirections
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (hAaMeas : AEMeasurable (model.aliceResponse bellA) model.hiddenMeasure)
    (hAbMeas : AEMeasurable (model.aliceResponse bellB) model.hiddenMeasure)
    (hBbMeas : AEMeasurable (model.bobResponse bellB) model.hiddenMeasure)
    (hBcMeas : AEMeasurable (model.bobResponse bellC) model.hiddenMeasure)
    (hAaBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse bellA))
    (hAbBin : IsAEBinaryValued model.hiddenMeasure (model.aliceResponse bellB))
    (hBbBin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse bellB))
    (hBcBin : IsAEBinaryValued model.hiddenMeasure (model.bobResponse bellC))
    (hAB : ReproducesCorrelationAt model singletCorrelation bellA bellB)
    (hAC : ReproducesCorrelationAt model singletCorrelation bellA bellC)
    (hBB : ReproducesCorrelationAt model singletCorrelation bellB bellB)
    (hBC : ReproducesCorrelationAt model singletCorrelation bellB bellC) :
    False := by
  have hdiag : correlation model bellB bellB = -1 := by
    calc
      correlation model bellB bellB = singletCorrelation bellB bellB := hBB
      _ = -1 := singletCorrelation_bellB_bellB
  have hanti := perfectAnticorrelationAt_of_correlation_eq_neg_one
    model bellB hAbMeas hBbMeas hAbBin hBbBin hdiag
  exact singletCorrelations_incompatible_with_perfectAnticorrelationAt_bellB
    model hAaMeas hAbMeas hBcMeas hAaBin hAbBin hBcBin hanti hAB hAC hBC

/-- No normalized deterministic local model on the given hidden-variable
space can satisfy exactly the finite assumptions used by the Bell triple. -/
theorem no_deterministicLocalModel_reproduces_singletCorrelations_at_bellDirections :
    ¬ ∃ model : DeterministicLocalModel Direction Direction Ω,
      IsProbabilityMeasure model.hiddenMeasure ∧
      AEMeasurable (model.aliceResponse bellA) model.hiddenMeasure ∧
      AEMeasurable (model.aliceResponse bellB) model.hiddenMeasure ∧
      AEMeasurable (model.bobResponse bellB) model.hiddenMeasure ∧
      AEMeasurable (model.bobResponse bellC) model.hiddenMeasure ∧
      IsAEBinaryValued model.hiddenMeasure (model.aliceResponse bellA) ∧
      IsAEBinaryValued model.hiddenMeasure (model.aliceResponse bellB) ∧
      IsAEBinaryValued model.hiddenMeasure (model.bobResponse bellB) ∧
      IsAEBinaryValued model.hiddenMeasure (model.bobResponse bellC) ∧
      ReproducesCorrelationAt model singletCorrelation bellA bellB ∧
      ReproducesCorrelationAt model singletCorrelation bellA bellC ∧
      ReproducesCorrelationAt model singletCorrelation bellB bellB ∧
      ReproducesCorrelationAt model singletCorrelation bellB bellC := by
  rintro ⟨model, hprob, hAaMeas, hAbMeas, hBbMeas, hBcMeas,
    hAaBin, hAbBin, hBbBin, hBcBin, hAB, hAC, hBB, hBC⟩
  letI : IsProbabilityMeasure model.hiddenMeasure := hprob
  exact singletCorrelations_incompatible_with_deterministicLocalModel_at_bellDirections
    model hAaMeas hAbMeas hBbMeas hBcMeas hAaBin hAbBin hBbBin hBcBin
      hAB hAC hBB hBC

/-- Global correlation reproduction is impossible under the corresponding
setting-wise measurability and a.e. binary-response assumptions. -/
theorem no_deterministicLocalModel_reproduces_singletCorrelation
    (model : DeterministicLocalModel Direction Direction Ω)
    [IsProbabilityMeasure model.hiddenMeasure]
    (hAliceMeas : AliceAEMeasurable model)
    (hBobMeas : BobAEMeasurable model)
    (hAliceBin : AliceAEBinary model)
    (hBobBin : BobAEBinary model)
    (hreproduces : ReproducesCorrelation model singletCorrelation) :
    False := by
  exact singletCorrelations_incompatible_with_deterministicLocalModel_at_bellDirections
    model (hAliceMeas bellA) (hAliceMeas bellB) (hBobMeas bellB)
      (hBobMeas bellC) (hAliceBin bellA) (hAliceBin bellB) (hBobBin bellB)
      (hBobBin bellC) (hreproduces.at bellA bellB) (hreproduces.at bellA bellC)
      (hreproduces.at bellB bellB) (hreproduces.at bellB bellC)

end Bell.Geometry
