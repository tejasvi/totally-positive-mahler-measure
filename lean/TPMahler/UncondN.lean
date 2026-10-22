import TPMahler.FinalN
import AuxCommon.EnergyProof

/-!
# Theorem 1.1 without hypotheses, track N

`EnergySmoothing` is proved in `AuxCommon.EnergyProof` and `PwLinClosedForm` in `TPMahler.ClosedForm`,
so the theorems of `TPMahler.FinalN` hold unconditionally. The statements of `TPMahler.FinalN` are unchanged.
-/

open Polynomial Filter Topology
open AuxCommon

namespace TPMahler.N

/-- **Theorem 1.1** (track N), unconditional. -/
theorem tp_main_unconditional (ε : ℝ) (hε : 0 < ε) : (TPLow (m0 - ε)).Finite :=
  tp_main energySmoothing pwLinClosedForm ε hε

/-- **Theorem 1.1**, second form (track N), unconditional. -/
theorem tp_omega_unconditional :
    {α : ℂ | ∃ P : ℤ[X], IsMinpolyZ P α ∧ AllRootsPos P ∧
      (toC P).mahlerMeasure ^ ((P.natDegree : ℝ)⁻¹) ≤ 17234615 / 10000000}.Finite :=
  tp_omega energySmoothing pwLinClosedForm

/-- **Theorem 1.1**, third form (track N), unconditional. -/
theorem tp_limit_point_unconditional : ∀ y : ℝ, AccPt y (𝓟 Lplus) → Real.exp m0 ≤ y :=
  tp_limit_point energySmoothing pwLinClosedForm

/-! ## The statements of `TPMahler.Statement` (track N, no hypotheses) -/

theorem tpMain : TpMain := tp_main_unconditional

theorem tpOmega : TpOmega := tp_omega_unconditional

theorem tpLimitPoint : TpLimitPoint := tp_limit_point_unconditional

theorem expM0Gt : ExpM0Gt := exp_m0_gt

end TPMahler.N
