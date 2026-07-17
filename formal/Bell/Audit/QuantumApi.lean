module

import Mathlib.Analysis.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Kronecker
import Mathlib.LinearAlgebra.Matrix.PosDef
import Mathlib.LinearAlgebra.Matrix.Trace

/-!
# Finite quantum API probe

Compile-only checks for basis-indexed complex kets, matrices, pure-state
expectations, Hermiticity, traces, and Kronecker products. This module is
diagnostic and is not imported by `Bell.lean`.
-/

open scoped Kronecker Matrix

set_option linter.privateModule false

namespace Bell.Audit.QuantumApi

abbrev QubitIndexProbe := Fin 2
abbrev QubitKetProbe := QubitIndexProbe → ℂ
abbrev QubitOperatorProbe := Matrix QubitIndexProbe QubitIndexProbe ℂ
abbrev TwoQubitIndexProbe := QubitIndexProbe × QubitIndexProbe
abbrev TwoQubitKetProbe := TwoQubitIndexProbe → ℂ
abbrev TwoQubitOperatorProbe := Matrix TwoQubitIndexProbe TwoQubitIndexProbe ℂ

#check Matrix.mulVec
#check dotProduct
#check Matrix.vecMulVec
#check Matrix.conjTranspose
#check Matrix.IsHermitian
#check Matrix.trace
#check Matrix.kronecker
#check Matrix.trace_kronecker
#check Matrix.conjTranspose_kronecker
#check TensorProduct
#check TensorProduct.map

def pureExpectationProbe
    (ψ : QubitKetProbe) (M : QubitOperatorProbe) : ℂ :=
  dotProduct (star ψ) (M *ᵥ ψ)

example (A B : QubitOperatorProbe) : TwoQubitOperatorProbe :=
  A ⊗ₖ B

example (A B : QubitOperatorProbe) :
    (A ⊗ₖ B).conjTranspose = A.conjTranspose ⊗ₖ B.conjTranspose :=
  Matrix.conjTranspose_kronecker A B

end Bell.Audit.QuantumApi
