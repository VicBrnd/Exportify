import AppKit

class ConfettiMessageView: NSView {
    let confettiView = ConfettiView()
    let messageLabel = NSTextField(labelWithString: "")
    
    init(message: String, frame frameRect: NSRect) {
        super.init(frame: frameRect)
        messageLabel.stringValue = message
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        confettiView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(confettiView)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = NSFont.systemFont(ofSize: 14)
        messageLabel.alignment = .center
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            confettiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            confettiView.trailingAnchor.constraint(equalTo: trailingAnchor),
            confettiView.topAnchor.constraint(equalTo: topAnchor),
            confettiView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
