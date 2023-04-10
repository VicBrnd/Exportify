//
//  AppWindowController.swift
//  Exportify
//
//  Created by Victor Bernardoni on 09/04/2023.
//

import Cocoa

class AppWindowController: NSWindowController {
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Set the title bar to be transparent and hidden
        if let window = self.window {
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
        }
    }
}
