import Foundation
import LocalAuthentication

let ctx = LAContext()
var error: NSError?
let can = ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
print("canEvaluateBiometrics=\(can)")
if let e = error { print("domain=\(e.domain) code=\(e.code) desc=\(e.localizedDescription)") }
print("biometryType=\(ctx.biometryType.rawValue)")
ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "test") { ok, err in
    print("evaluatePolicy ok=\(ok) err=\(String(describing: err))")
    exit(0)
}
DispatchQueue.global().asyncAfter(deadline: .now() + 8) { print("evaluatePolicy TIMEOUT"); exit(1) }
RunLoop.current.run()
