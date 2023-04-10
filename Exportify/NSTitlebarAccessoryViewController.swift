//
//  NSTitlebarAccessoryViewController.swift
//  Exportify
//
//  Created by Victor Bernardoni on 09/04/2023.
//

class CustomTitlebarAccessoryViewController: NSTitlebarAccessoryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title font to System UltraLight
        let titleAttributes = [NSAttributedString.Key.font: NSFont.systemFont(ofSize: 20, weight: .ultraLight)]
        self.titleLabel.attributedStringValue = NSAttributedString(string: self.titleLabel.stringValue, attributes: titleAttributes)
    }
}
