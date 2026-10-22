import TPCore.Lits
import TPCore.Leaves

set_option maxRecDepth 200000
set_option maxHeartbeats 0

namespace TPCore.TPK

theorem ctx_eq : mkCtx iLoNum 128 = ctxLit := by decide +kernel

end TPCore.TPK
