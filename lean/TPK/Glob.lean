import TPCore.Lits
import TPCore.Leaves

/-! Global checks of the certificate (K): budget and tails over the literal context `ctxLit`
(`mkCtx iLoNum 128 = ctxLit` is `TPCore.TPK.ctx_eq`, TPKb/LitsEq.lean). -/

set_option maxRecDepth 200000
set_option maxHeartbeats 0

namespace TPCore.TPK

theorem budget_okK : budgetOK = true := by decide +kernel

theorem left_tail_okK : decide (0 < leftTailLB ctxLit DEC 30) = true := by decide +kernel

theorem right_tail_okK : decide (0 < rightTailLB ctxLit (XT * DEC)) = true := by decide +kernel

end TPCore.TPK
