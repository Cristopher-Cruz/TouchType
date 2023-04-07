//
//  View.swift
//  Ex
//
//  Created by christopher cruz on 4/7/23.
//

import Cocoa

class View: NSView {
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
}
//class View: NSView {
//
//    override func draw(_ dirtyRect: NSRect) {
//        super.draw(dirtyRect)
//
//        // Drawing code here.
//    }
//
//}
