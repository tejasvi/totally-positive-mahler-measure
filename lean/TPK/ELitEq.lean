import TPK.ELit

/-! The literal energy inputs agree with the computed ones (K). -/

set_option maxRecDepth 200000
set_option maxHeartbeats 0

namespace TPCore.TPK

theorem tabI_lit : TABI = TABIlit := by decide +kernel

theorem l2I_lit : L2I = L2Ilit := by decide +kernel

theorem recsI_lit : recsI = recsILit := by decide +kernel

end TPCore.TPK
