import Foundation
import UIKit

@objc(SecureWindow)
class SecureWindow: CDVPlugin {
    @objc(makeSecure:)
    func makeSecure(command: CDVInvokedUrlCommand) {
        if let window = UIApplication.shared.windows.first {
            window.makeSecure()
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Window secured")
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        } else {
            let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Failed to secure window")
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }
}

extension UIWindow {
    func makeSecure() {
        let field = UITextField()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.width, height: field.frame.height))
        field.isSecureTextEntry = true
        self.addSubview(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.layer.superlayer?.addSublayer(field.layer)
        field.layer.sublayers?.last?.addSublayer(self.layer)
        field.leftView = view
        field.leftViewMode = .always
    }
}
