//
//  ViewController.swift
//  Ex
//
//  Created by christopher cruz on 4/7/23.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var textField: NSTextField!
    @IBOutlet var userInput: NSTextField!
    @IBOutlet var practiceLine: NSTextField!
    @IBOutlet var startButton: NSButton!
    
    @IBOutlet var keyboardView: KeyboardView!
    var currentCharIndex = 0

    @IBAction func startClicked(_ sender: Any) {
        // To keep track of the current character
        currentCharIndex = 0
        
        // hide the inputfield and the start button
        userInput.isHidden = true
        startButton.isHidden = true
        
        // Unhide the practice line field
        practiceLine.isHidden = false
        
        // Unhide the keyboard view
        keyboardView.isHidden = false
        
        // create input string to pass into NSMutableAttributedString
        let inputString = userInput.stringValue
        practiceLine.stringValue = inputString
        
        // Create an attributed string with the first character in a different color
        let attributedString = NSMutableAttributedString(string: inputString)
        attributedString.addAttribute(.foregroundColor, value: NSColor.blue, range: NSRange(location: 0, length: 1))
        
        // Set the attributed string as the string value of the practiceLine text field
        practiceLine.attributedStringValue = attributedString
        
        
        // begin listening for state of modifier keys
        flags = NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
            self.flagsChanged(with: $0)
            return $0
        }
        
        // begin listening for key strokes
        keyDown = NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        
    }
    
    // declare variables
    var flags: Any!
    var keyDown: Any!
    var inputString: String!
    
    // MARK : Start of code
    override func viewDidLoad() {
        super.viewDidLoad()

        userInput.becomeFirstResponder()
        userInput.placeholderString = "Enter custom text here"
        startButton.title = "Start"
        
    }
    
    
    override func keyDown(with event: NSEvent) {
        let typedChar = event.charactersIgnoringModifiers ?? ""
        let practiceString = practiceLine.stringValue
        
        // Check if the typed character matches the current character in the practice string
        if typedChar == String(practiceString[practiceString.index(practiceString.startIndex, offsetBy: currentCharIndex)]) {
            
            // Create an attributed string with all the characters colored green up to the current character
            let attributedString = NSMutableAttributedString(string: practiceString)
            for i in 0..<currentCharIndex {
                attributedString.addAttribute(.foregroundColor, value: NSColor.disabledControlTextColor, range: NSRange(location: i, length: 1))
            }
            
            // Update the attributed string to mark the current character as typed correctly
            attributedString.addAttribute(.foregroundColor, value: NSColor.disabledControlTextColor, range: NSRange(location: currentCharIndex, length: 1))
            
            // Check if there are more characters to be typed
            if currentCharIndex < practiceString.count - 1 {
                // Update the index of the current character to the next character in the practice string
                currentCharIndex += 1
                
//                 Mark the next character in the practice string as the current character to be typed
                attributedString.addAttribute(.foregroundColor, value: NSColor.blue, range: NSRange(location: currentCharIndex, length: 1))
            }
            
            // Set the attributed string as the string value of the practiceLine text field
            practiceLine.attributedStringValue = attributedString
        }
    }


    deinit {
        if let flagsMonitor = flags {
            NSEvent.removeMonitor(flagsMonitor)
        }
        if let keyDownMonitor = keyDown {
            NSEvent.removeMonitor(keyDownMonitor)
        }
    }
}


