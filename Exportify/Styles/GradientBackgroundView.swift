//
//  GradientBackgroundView.swift
//  Exportify
//
//  Created by Victor Bernardoni on 09/04/2023.
//

import Cocoa

class GradientBackgroundView: NSView {
    var startColor: NSColor
    var endColor: NSColor

    init(frame frameRect: NSRect, startColor: NSColor, endColor: NSColor) {
        self.startColor = startColor
        self.endColor = endColor
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        let gradient = NSGradient(starting: startColor, ending: endColor)
        gradient?.draw(in: bounds, angle: -130)
    }
}
