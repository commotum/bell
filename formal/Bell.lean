module

public import Bell.HiddenVariable.Basic
public import Bell.HiddenVariable.Correlation
public import Bell.HiddenVariable.PerfectAnticorrelation
public import Bell.Inequality.Original
public import Bell.Quantum.Singlet

/-!
# Bell

Public root for the Bell 1964 formalization.

The public abstract layer keeps the fixed hidden-variable measure, local
deterministic responses, normalization, binary outcomes, measurability, and
perfect anticorrelation logically distinct. Bell's original inequality is
proved independently of quantum mechanics and geometry. The finite-dimensional
singlet calculation is exported from a separate quantum-only dependency layer.
-/

namespace Bell

end Bell
