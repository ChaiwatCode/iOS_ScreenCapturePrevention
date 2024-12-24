import Cordova

@objc(SecureWindowPlugin) class SecureWindowPlugin: CDVPlugin {
    @objc(makeSecureWindow:)
    func makeSecureWindow(command: CDVInvokedUrlCommand) {
        // Access the main window
        guard let window = UIApplication.shared.windows.first else {
            let error = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Unable to find window")
            self.commandDelegate.send(error, callbackId: command.callbackId)
            return
        }
        
        let field = UITextField()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: field.frame.width, height: field.frame.height))
        field.isSecureTextEntry = true
        window.addSubview(field)
        
        // Align the field to the center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
        field.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
        
        // Make the text field's view the secure layer
        field.layer.superlayer?.addSublayer(field.layer)
        field.layer.sublayers?.last?.addSublayer(window.layer)
        
        field.leftView = view
        field.leftViewMode = .always

        let result = CDVPluginResult(status: CDVCommandStatus_OK)
        self.commandDelegate.send(result, callbackId: command.callbackId)
    }
}
