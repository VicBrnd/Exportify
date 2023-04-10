//
//  GradientButton.swift
//  Exportify
//
//  Created by Victor Bernardoni on 10/04/2023.
//

import Cocoa

class GradientButton: NSButton {

    override func draw(_ dirtyRect: NSRect) {
        let gradientColors = [
            NSColor(red: 0.969, green: 0.584, blue: 0.2, alpha: 1).cgColor,
            NSColor(red: 0.953, green: 0.439, blue: 0.333, alpha: 1).cgColor,
            NSColor(red: 0.937, green: 0.306, blue: 0.482, alpha: 1).cgColor,
            NSColor(red: 0.627, green: 0.4, blue: 0.667, alpha: 1).cgColor,
            NSColor(red: 0.316, green: 0.451, blue: 0.722, alpha: 1).cgColor,
            NSColor(red: 0.066, green: 0.596, blue: 0.678, alpha: 1).cgColor,
            NSColor(red: 0.027, green: 0.702, blue: 0.608, alpha: 1).cgColor,
            NSColor(red: 0.437, green: 0.729, blue: 0.51, alpha: 1).cgColor
        ]

        let gradient = NSGradient(colors: gradientColors.map { NSColor(cgColor: $0)! }, atLocations: [0, 0.14, 0.28, 0.42, 0.56, 0.7, 0.84, 1], colorSpace: .sRGB)
        gradient?.draw(in: bounds, angle: 120)

        super.draw(dirtyRect)
    }
}
