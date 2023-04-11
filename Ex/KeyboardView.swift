import Cocoa

class KeyboardView: NSView {
    // An array of buttons representing the keys on the keyboard
    var keyButtons = [[NSButton]]()
    

    // The practice line string to synchronize with the keyboard view
    var practiceLine = "" {
        didSet {
            // Reset the keyboard view to unhighlight all keys
            for row in keyButtons {
                for button in row {
                    button.layer?.backgroundColor = NSColor.clear.cgColor
                }
            }
            // Set the current character index to 0
            currentCharIndex = 0
        }
    }
    
    // The current character index to highlight in blue
    var currentCharIndex = 0 {
        didSet {
            // Unhighlight the old current button
            currentButton?.layer?.backgroundColor = NSColor.clear.cgColor
            
            // Highlight the key corresponding to the new current character index in blue
            let currchar = String(practiceLine[practiceLine.index(practiceLine.startIndex, offsetBy: currentCharIndex)])
            let (rowIndex, colIndex) = getButtonRowAndColumnForCurrentChar(char: currchar)
            let button = keyButtons[rowIndex][colIndex]
            button.layer?.backgroundColor = NSColor.blue.cgColor
            
            // Set the current button to the new button
            currentButton = button
        }
    }

    // Helper function to get the locate the typed character
    func getButtonRowAndColumnForCurrentChar(char: String) -> (Int, Int) {
        let currentChar = String(practiceLine[practiceLine.index(practiceLine.startIndex, offsetBy: currentCharIndex)])
        let rowsOfChars = [["fn", "cntrl", "option", "comm", " ", "comm", "option", "left", "down", "right"],
                           ["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "shift"],
                           ["caps", "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'", "return"],
                           ["tab", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "\\"],
                           ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "+", "delete"]]
        for (rowIndex, rowChars) in rowsOfChars.enumerated() {
            for (colIndex, tempstr) in rowChars.enumerated() {
                if tempstr.lowercased() == currentChar.lowercased() {
                    if char.lowercased() == currentChar.lowercased() || char.uppercased() == tempstr.uppercased() {
                        print("Found it")
                        return (rowIndex, colIndex)
                    }
                }
            }
        }
        return (0,0)
    }


    
    // The current button in the keyboard view
    var currentButton: NSButton? {
        didSet {
            // Unhighlight the old current button
            oldValue?.layer?.backgroundColor = NSColor.clear.cgColor
            
            // Highlight the new current button
            currentButton?.layer?.backgroundColor = NSColor.blue.cgColor
        }
    }
    
    // MARK: Create the keyboard view
    override func awakeFromNib() {
        // Create the buttons for the keyboard view
        var buttonWidth: CGFloat = 55
        var buttonHeight: CGFloat = 55
        var buttonPadding: CGFloat = 0
        
        let row5Chars = [" "]
        let row4Chars = ["shift", "z", "x", "c", "v", "b", "n", "m", ",", ".", "/", "shift"]
        let row3Chars = ["caps", "a", "s", "d", "f", "g", "h", "j", "k", "l", ";", "'", "return"]
        let row2Chars = ["tab", "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", "[", "]", "\\"]
        let row1Chars = ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "+", "delete"]
        
        let rowsOfChars = [row5Chars, row4Chars, row3Chars, row2Chars, row1Chars]
        
        // calculate the center position for the space button
        let spaceButtonXPos = (buttonWidth + buttonPadding) * CGFloat(row5Chars.count)/2 - buttonWidth/2
        var xPos: CGFloat = buttonPadding
        var yPos: CGFloat = buttonPadding
        
        for rowChars in rowsOfChars {
            var rowButtons = [NSButton]()
            for char in rowChars {
                let buttonWidthForChar: CGFloat // set custom widths for better layout
                switch char {
                case " ":
                    buttonWidthForChar = buttonWidth * 8 + buttonPadding // space button
                case "shift":
                    buttonWidthForChar = buttonWidth * 2 + buttonPadding // custom width for shift button
                case "caps":
                    buttonWidthForChar = buttonWidth * 1.5 + buttonPadding
                case "return":
                    buttonWidthForChar = buttonWidth * 1.5 + buttonPadding
                default:
                    buttonWidthForChar = buttonWidth // default width for all other buttons
                }

                let button = (char == " ") ? NSButton(frame: NSRect(x: xPos+CGFloat(165), y: yPos, width: buttonWidthForChar, height: buttonHeight)) : NSButton(frame: NSRect(x: xPos, y: yPos, width: buttonWidthForChar, height: buttonHeight)) // increase width for space button
//
//                let button = NSButton(frame: NSRect(x: xPos, y: yPos, width: buttonWidthForChar, height: buttonHeight))
                button.title = char
                button.bezelStyle = .regularSquare
                button.layer?.backgroundColor = NSColor.clear.cgColor
                addSubview(button)
                rowButtons.append(button)
                xPos += buttonWidthForChar + buttonPadding
            }
            keyButtons.append(rowButtons)
            xPos = buttonPadding
            yPos += buttonHeight + buttonPadding
        }
    }

    
    
    override func keyDown(with event: NSEvent) {
        // Get the typed character from the event
        let typedChar = event.charactersIgnoringModifiers ?? ""
        
        // Check if the typed character matches the current character in the practice string
        if typedChar == String(practiceLine[practiceLine.index(practiceLine.startIndex, offsetBy: currentCharIndex)]) {
            let (rowIndex, colIndex) = getButtonRowAndColumnForCurrentChar(char: typedChar)
            let button = keyButtons[rowIndex][colIndex]
            // Increment the current character index
            currentCharIndex += 1
    
        }
    }
}

