import Cocoa

class KeyboardView: NSView {
    // An array of buttons representing the keys on the keyboard
    var keyButtons = [NSButton]()
    
    // The current character index to highlight in blue
    var currentCharIndex = 0 {
        didSet {
            // Highlight the key corresponding to the current character index in blue
            if currentCharIndex < keyButtons.count {
                let button = keyButtons[currentCharIndex]
                button.layer?.backgroundColor = NSColor.blue.cgColor
            }
        }
    }
    
    // The practice line string to synchronize with the keyboard view
    var practiceLine = "" {
        didSet {
            // Reset the keyboard view to unhighlight all keys
            for button in keyButtons {
                button.layer?.backgroundColor = NSColor.clear.cgColor
            }
            
            // Set the current character index to 0
            currentCharIndex = 0
        }
    }
    
    // The current button in the keyboard view
    var currentButton: NSButton? {
        didSet {
            // Unhighlight the old current button
            oldValue?.layer?.backgroundColor = NSColor.clear.cgColor
            
            // Highlight the new current button
            currentButton?.layer?.backgroundColor = NSColor.yellow.cgColor
        }
    }
    
    override func awakeFromNib() {
        // Create the buttons for the keyboard view
        let buttonWidth: CGFloat = 40
        let buttonHeight: CGFloat = 40
        let buttonPadding: CGFloat = 8
        
        let row1Chars = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        let row2Chars = ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"]
        let row3Chars = ["A", "S", "D", "F", "G", "H", "J", "K", "L"]
        let row4Chars = ["Z", "X", "C", "V", "B", "N", "M"]
        let row5Chars = ["", " ", ""]
        
        let rowsOfChars = [row1Chars, row2Chars, row3Chars, row4Chars, row5Chars]
        var xPos: CGFloat = buttonPadding
        var yPos: CGFloat = buttonPadding
        
        for rowChars in rowsOfChars {
            for char in rowChars {
                let button = NSButton(frame: NSRect(x: xPos, y: yPos, width: buttonWidth, height: buttonHeight))
                button.title = char
                button.bezelStyle = .rounded
                button.layer?.backgroundColor = NSColor.clear.cgColor
                addSubview(button)
                keyButtons.append(button)
                xPos += buttonWidth + buttonPadding
            }
            yPos += buttonHeight + buttonPadding
            xPos = buttonPadding
        }
        
        // Set the initial state of the keyboard to unhighlight all keys
        for button in keyButtons {
            button.layer?.backgroundColor = NSColor.clear.cgColor
        }
        
        // Set the current button to the first button in the keyboard view
        currentButton = keyButtons.first
    }
    
    
    override func keyDown(with event: NSEvent) {
        // Get the typed character from the event
        let typedChar = event.charactersIgnoringModifiers ?? ""
        
        // Check if the typed character matches the current character in the practice string
        if typedChar == String(practiceLine[practiceLine.index(practiceLine.startIndex, offsetBy: currentCharIndex)]) {
            // Increment the current character index
            currentCharIndex += 1
            
            // Set the current button to the next button in the keyboard

            // Set the current button to the next button in the keyboard view
            if let currentIndex = keyButtons.firstIndex(of: currentButton!), currentIndex + 1 < keyButtons.count {
                currentButton = keyButtons[currentIndex + 1]
            }
        }
    }
}

