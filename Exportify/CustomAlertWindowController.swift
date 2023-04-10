//
//  CustomAlertWindowController.swift
//  Exportify
//
//  Created by Victor Bernardoni on 10/04/2023.
//

import Cocoa

class CustomAlertWindowController: NSWindowController {
    
    @IBOutlet weak var okButton: ShakeButton!
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("CustomAlertWindow")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Customize the appearance of the window and its elements here
        okButton.target = self
        okButton.action = #selector(okButtonClicked)
    }
    
    @objc private func okButtonClicked() {
        self.window?.sheetParent?.endSheet(self.window!, returnCode: .OK)
    }
}

