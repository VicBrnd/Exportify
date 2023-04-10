//
//  CustomWindow.swift
//  Exportify
//
//  Created by Victor Bernardoni on 09/04/2023.
//

import Cocoa

// Window Style
class CustomWindow: NSWindow {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make the title bar transparent and hidden
        titlebarAppearsTransparent = true
        titleVisibility = .visible
        styleMask.insert(.fullSizeContentView)
    }
}

// Window Position
class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()

        if let window = self.window {
            let screenFrame = window.screen?.frame ?? NSScreen.main!.frame
            let windowFrame = window.frame
            let x = (screenFrame.width - windowFrame.width) / 2
            let y = (screenFrame.height - windowFrame.height) / 2
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }
    }
}
