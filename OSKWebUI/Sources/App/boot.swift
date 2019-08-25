import Vapor
import OskGadgetCWrapMock

let oskDataUrl = URL(fileURLWithPath: "/var/spool/osk-data/public/")
var oskGadget: UnsafeMutableRawPointer!

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    // Your code here
    guard let oskGadgetPtr = oskGadgetCreate() else {
        print(":FAIL: oskGadget failed to allocate.")
        return
    }
    oskGadget = oskGadgetPtr
}
