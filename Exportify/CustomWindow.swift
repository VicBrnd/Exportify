//
//  CustomWindow.swift
//  Exportify
//
//  Created by Victor Bernardoni on 09/04/2023.
//

import Cocoa

class CustomWindow: NSWindow {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Make the title bar transparent and hidden
        titlebarAppearsTransparent = true
        titleVisibility = .visible
        styleMask.insert(.fullSizeContentView)
        
    }
}
