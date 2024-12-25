import Foundation
import UIKit

@objc(SecureWindow)
class SecureWindow: CDVPlugin {
    // Method to secure the window
    @objc(makeSecure:)
    func makeSecure(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            guard let window = self.viewController?.view.window else {
                self.showDebugMessage("Error: Failed to access the app's main window.")
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Failed to secure window")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
                return
            }

            // Attempt to secure the window
            if #available(iOS 13.0, *) {
                window.isSecure = true
                self.showDebugMessage("Success: The window has been secured.")
                let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Window secured")
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            } else {
                self.showDebugMessage("Error: isSecure is not available on iOS versions below 13.0.")
                let pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_ERROR,
                    messageAs: "isSecure is not supported on iOS versions below 13.0"
                )
                self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
            }
        }
    }

    // Helper method to display debug messages on the screen
    private func showDebugMessage(_ message: String) {
        DispatchQueue.main.async {
            guard let viewController = self.viewController else { return }

            // Create and present an alert
            let alert = UIAlertController(title: "Debug Message", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
