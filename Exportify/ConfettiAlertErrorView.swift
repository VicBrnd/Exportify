//
//  CustomButton.swift
//  Exportify
//
//  Created by Victor Bernardoni on 09/04/2023.
//

import AppKit

class ConfettiErrorView: NSView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupEmitter()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEmitter()
    }
    
    func emojiToImage(emoji: String, size: CGFloat) -> NSImage? {
        let font = NSFont.systemFont(ofSize: size)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        let textSize = emoji.size(withAttributes: textAttributes)
        let image = NSImage(size: textSize)
        
        image.lockFocus()
        emoji.draw(in: CGRect(origin: .zero, size: textSize), withAttributes: textAttributes)
        image.unlockFocus()
        
        return image
    }

    
    private func setupEmitter() {
        wantsLayer = true
        
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: bounds.midX, y: bounds.maxY)
        emitter.emitterSize = CGSize(width: bounds.width, height: 1)
        emitter.emitterShape = .line
        
        let emojis = ["😡", "🤬", "💩", "❌", "🚫"]
        
        var emitterCells: [CAEmitterCell] = []
        
        for emoji in emojis {
            if let image = emojiToImage(emoji: emoji, size: 40)?.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                let cell = CAEmitterCell()
                cell.contents = image
                cell.birthRate = 2
                cell.lifetime = 7.0
                cell.velocity = 200
                cell.velocityRange = 100
                cell.emissionLongitude = CGFloat.pi
                cell.emissionRange = CGFloat.pi / 4
                cell.spin = 2 * .pi
                cell.spinRange = 3 * .pi
                cell.scale = 0.3
                cell.scaleRange = 0.1
                
                emitterCells.append(cell)
            }
        }
        
        emitter.emitterCells = emitterCells
        
        if let layer = self.layer {
            layer.addSublayer(emitter)
        }
    }

}
