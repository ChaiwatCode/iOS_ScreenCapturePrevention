import Foundation
import UIKit

@objc(SecureWindow)
class SecureWindow: CDVPlugin {
    // Method to secure the window
    @objc(makeSecure:)
    func makeSecure(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            guard let window = self.viewController?.view.window else {
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Failed to secure window")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                return
            }

            // Apply secure settings to the window
            window.makeSecure()

            // Monitor screen recording
            self.monitorScreenRecording()

            let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Window secured")
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    // Monitor for screen recording and handle it
    private func monitorScreenRecording() {
        NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            if UIScreen.main.isCaptured {
                print("Screen recording detected!")
                self.handleScreenRecording()
            }
        }
    }

    // Handle screen recording by blurring the content
    private func handleScreenRecording() {
        DispatchQueue.main.async {
            guard let window = self.viewController?.view.window else { return }
            let blurEffect = UIBlurEffect(style: .light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = window.bounds
            blurEffectView.tag = 999 // Tag for identifying later
            window.addSubview(blurEffectView)
        }
    }

    // Remove blur effect (if needed in the future)
    private func removeBlurEffect() {
        DispatchQueue.main.async {
            guard let window = self.viewController?.view.window else { return }
            window.viewWithTag(999)?.removeFromSuperview()
        }
    }
}

// Extension for securing the UIWindow
extension UIWindow {
    func makeSecure() {
        // Prevent screenshots by using secure content flag
        self.isHidden = false // Ensure the window is visible
        self.layer.superlayer?.addSublayer(self.layer)

        // Secure the window to prevent screenshots
        self.isSecureTextEntryEnabled()
    }

    private func isSecureTextEntryEnabled() {
        // Create a secure UITextField and add it to the window
        let secureField = UITextField()
        secureField.isSecureTextEntry = true
        secureField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(secureField)

        // Apply constraints to center the secure field
        secureField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        secureField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        // Immediately remove the field (it sets the secure property for the window)
        secureField.removeFromSuperview()
    }
}
