//
//  StatusBarManager.swift
//  Exportify
//
//  Created by Victor Bernardoni on 10/04/2023.
//

import AppKit
import Cocoa

class StatusBarManager: NSObject {
    
    weak var viewController: ViewController?

    let statusItem: NSStatusItem
    let menu: NSMenu
    
    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        menu = NSMenu(title: "Exportify")
        
        super.init()
        
        setupMenu()
    }
    
    private func setupMenu() {
        // Set up the menu
        let quickViewMenuItem = NSMenuItem(title: "Show Exportify", action: #selector(quickView), keyEquivalent: "")
        quickViewMenuItem.target = self
        menu.addItem(quickViewMenuItem)
        
        let exportMenuItem = NSMenuItem(title: "Export", action: #selector(exportMenuItemClicked(_:)), keyEquivalent: "E")
        exportMenuItem.target = self
        menu.addItem(exportMenuItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "")
        quitMenuItem.target = self
        menu.addItem(quitMenuItem)
        
        statusItem.menu = menu
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "mug.fill", accessibilityDescription: "Favorite")
        }
    }

    @objc func quickView() {
        // Show your quick view window here
    }
    
    @objc func quit() {
        NSApp.terminate(nil)
    }
    
    @objc func exportMenuItemClicked(_ sender: NSMenuItem) {
        let fakeButton = NSButton()
        viewController?.exportButtonClicked(fakeButton)
    }
}
