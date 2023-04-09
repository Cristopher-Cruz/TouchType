//
//  KeyboardView.swift
//  Ex
//
//  Created by christopher cruz on 4/9/23.
//

import Cocoa

class KeyboardView: NSView {

    
    let keySize = NSSize(width: 40, height: 40)
    let keySpacing = NSSize(width: 10, height: 10)
    
    let keys: [[String]] = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
        ["z", "x", "c", "v", "b", "n", "m"]
    ]
    
    var selectedKey: String?
    var eventMonitor: Any?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        var x = keySpacing.width
        var y = keySpacing.height
        
        for row in keys {
            for key in row {
                let backgroundColor = NSColor.white
                let textColor = NSColor.black
                
                let keyRect = NSRect(origin: NSPoint(x: x, y: y), size: keySize)
                backgroundColor.setFill()
                keyRect.fill()
                
                textColor.set()
                let keyString = NSAttributedString(string: key,
                                                   attributes: [.font: NSFont.systemFont(ofSize: 24)])
                let keyStringSize = keyString.size()
                let keyStringRect = NSRect(origin: NSPoint(x: x + (keySize.width - keyStringSize.width) / 2,y: y + (keySize.height - keyStringSize.height) / 2), size: keyStringSize)
                keyString.draw(in: keyStringRect)
                
                x += keySize.width + keySpacing.width
            }
            
            x = keySpacing.width
            y += keySize.height + keySpacing.height
        }
    }
    
}
