//
//  CustomAlert.swift
//  Exportify
//
//  Created by Victor Bernardoni on 10/04/2023.
//

import Cocoa

class CustomAlert: NSAlert {
    private let okButton = ShakeButton(title: "OK", target: self, action: #selector(okButtonClicked))
    
    override init() {
        super.init()
        
        self.messageText = "Your message"
        self.addButton(withTitle: "") // Add an empty button to create space for the custom button
        
        let accessoryView = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 60))
        accessoryView.addSubview(okButton)
        okButton.frame = NSRect(x: 200, y: 0, width: 100, height: 60)
        self.accessoryView = accessoryView
    }
    
    @objc private func okButtonClicked() {
        self.window.sheetParent?.endSheet(self.window, returnCode: .OK)
    }
}
