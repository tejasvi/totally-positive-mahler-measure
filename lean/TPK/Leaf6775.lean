import TPCore.Lits
import TPCore.Leaves

set_option maxRecDepth 200000
set_option maxHeartbeats 0

namespace TPCore.TPK

theorem leaf_6775 : leafOK ctxLit (leaves.getD 6775 ⟨0, 0, 0, 0, false, 0⟩) = true := by decide +kernel

end TPCore.TPK
