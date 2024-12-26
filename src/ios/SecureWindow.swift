import Foundation
import UIKit

@objc(SecureWindow)
class SecureWindow: CDVPlugin {
    
    @objc(makeSecure:)
    func makeSecure(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            guard let window = self.viewController?.view.window else {
                self.showDebugMessage("Error: Main window is unavailable.")
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Main window unavailable")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                return
            }

            if #available(iOS 13.0, *) {
                // Use isSecure to prevent screenshots and screen recordings on iOS 13+
                window.isSecure = true
                if window.isSecure {
                    self.showDebugMessage("Success: Screenshot protection enabled (iOS 13+).")
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Screenshot protection enabled (iOS 13+)")
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                } else {
                    self.showDebugMessage("Error: Failed to enable screenshot protection on iOS 13+. Please check device settings.")
                    let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Failed to enable screenshot protection")
                    self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                }
            } else {
                // Fallback for iOS versions below 13.0: Apply blur effect
                //self.blurWindow(for: window)
                //self.showDebugMessage("Success: Blur effect applied for screenshot protection (iOS < 13).")
                //let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Blur effect applied (iOS < 13)")
                //self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        }
    }

    // Apply a blur effect to the window (for iOS < 13.0)
    private func blurWindow(for window: UIWindow) {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = window.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.tag = 999 // Assign a unique tag to identify the blur view later
        window.addSubview(blurView)
    }

    // Remove the blur effect if needed
    private func removeBlurWindow(for window: UIWindow) {
        window.viewWithTag(999)?.removeFromSuperview()
    }
    

    // Helper method to display debug messages
    private func showDebugMessage(_ message: String) {
        DispatchQueue.main.async {
            guard let viewController = self.viewController else { return }

            // Create and present an alert for debugging
            let alert = UIAlertController(title: "Debug Message", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    } 
}
