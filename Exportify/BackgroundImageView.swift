import Cocoa

class BackgroundImageView: NSView {
    var backgroundImage: NSImage?

    init(frame frameRect: NSRect, backgroundImage: NSImage?) {
        self.backgroundImage = backgroundImage
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let backgroundImage = backgroundImage else { return }
        
        let imageSize = backgroundImage.size
        let aspectRatio = imageSize.width / imageSize.height
        var newRect = bounds

        if aspectRatio > 1 {
            newRect.size.height = bounds.width / aspectRatio
            newRect.origin.y += (bounds.height - newRect.height) / 2
        } else {
            newRect.size.width = bounds.height * aspectRatio
            newRect.origin.x += (bounds.width - newRect.width) / 2
        }

        backgroundImage.draw(in: newRect, from: .zero, operation: .sourceOver, fraction: 1)
    }
}
