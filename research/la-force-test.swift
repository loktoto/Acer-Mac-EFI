import Foundation
import LocalAuthentication
let ctx = LAContext()
var e: NSError?
let can = ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &e)
print("can=\(can) code=\(e?.code ?? 0) type=\(ctx.biometryType.rawValue)")
