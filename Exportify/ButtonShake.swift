//
//  ButtonShake.swift
//  Exportify
//
//  Created by Victor Bernardoni on 10/04/2023.
//

import Cocoa

class ShakeButton: NSButton {
    
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

    override func awakeFromNib() {
        super.awakeFromNib()
        
        wantsLayer = true
        
        layer?.cornerRadius = 15
        layer?.backgroundColor = NSColor(red: 0.006, green: 0.455, blue: 0.851, alpha: 1).cgColor
        font = NSFont.systemFont(ofSize: 17, weight: .medium)
        title = title.uppercased()
        let textColor = NSColor.white
        let attributedTitle = NSMutableAttributedString(string: title)
        attributedTitle.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: attributedTitle.length))
        self.attributedTitle = attributedTitle
        self.isBordered = false
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        startShakeAnimation()
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        stopShakeAnimation()
    }
    
    private func startShakeAnimation() {
        let shakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation")
        shakeAnimation.values = [
            NSValue(point: NSPoint(x: 0, y: 0)),
            NSValue(point: NSPoint(x: -2, y: 2)),
            NSValue(point: NSPoint(x: -2, y: -2)),
            NSValue(point: NSPoint(x: 2, y: 2)),
            NSValue(point: NSPoint(x: 2, y: -2)),
            NSValue(point: NSPoint(x: 0, y: 0))
        ]
        shakeAnimation.duration = 0.3
        shakeAnimation.repeatCount = .greatestFiniteMagnitude
        layer?.add(shakeAnimation, forKey: "shake")
    }
    
    private func stopShakeAnimation() {
        layer?.removeAnimation(forKey: "shake")
    }
    
    private func createTrackingArea() {
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeInActiveApp]
        let trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        addTrackingArea(trackingArea)
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        createTrackingArea()
    }
}
