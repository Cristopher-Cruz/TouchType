//
//  ViewController.swift
//  Ex
//
//  Created by christopher cruz on 4/7/23.
//



import Cocoa

class ViewController: NSViewController {
    // Create singleton instance
    static let shared = ViewController()
    
    @IBOutlet var resetButton: NSButton!
    // Declare varibales and IBOutlets
    var keyDown: Any!
    var inputString: String!
    var currentCharIndex = 0
    var charCount = 0
    var startTime: Date?
    var endTime: Date?
    
    @IBOutlet var textField: NSTextField!
    @IBOutlet var userInput: NSTextField!
    @IBOutlet var practiceLine: NSTextField!
    @IBOutlet var startButton: NSButton!
    @IBOutlet var keyboardView: KeyboardView!
    @IBOutlet var newLineButton: NSButton!
    @IBOutlet var wpmLabel: NSTextField!
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        userInput.becomeFirstResponder()
        userInput.placeholderString = "Enter custom text here"
        startButton.title = "Start"
    }

    
    // MARK: startClicked action
    @IBAction func startClicked(_ sender: Any) {
        // To keep track of the current character
        currentCharIndex = 0
        wpmLabel.stringValue = "0 WPM"
        
        // hide the inputfield and the start button
        userInput.isHidden = true
        startButton.isHidden = true
        
        // Show the practice line field and reset
        practiceLine.isHidden = false
        resetButton.isHidden = false
        newLineButton.isHidden = false
        wpmLabel.isHidden = false
        
        // Show the keyboard view
        keyboardView.isHidden = false
        
        
        // Create input string to pass into NSMutableAttributedString
        let inputString = userInput.stringValue
        practiceLine.stringValue = inputString
        
        // Pass properties into kb view
        keyboardView.practiceLine = practiceLine.stringValue
        keyboardView.currentCharIndex = 0
        
        // Create an attributed string with the first character in a different color
        let attributedString = NSMutableAttributedString(string: inputString)
        attributedString.addAttribute(.foregroundColor, value: NSColor.blue, range: NSRange(location: 0, length: 1))
        
        // Set the attributed string as the string value of the practiceLine text field
        practiceLine.attributedStringValue = attributedString
        
        // begin listening for key strokes
        keyDown = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] in
            self?.keyDown(with: $0)
            return $0
        }
        
        startTime = Date()
        
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        wpmLabel.stringValue = "0"
        currentCharIndex = 0
        keyboardView.currentCharIndex = 0
        let attributedString = NSMutableAttributedString(string: practiceLine.stringValue)
        attributedString.addAttribute(.foregroundColor, value: NSColor.blue, range: NSRange(location: 0, length: 1))
        practiceLine.attributedStringValue = attributedString
        // begin listening for key strokes
        keyDown = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] in
            self?.keyDown(with: $0)
            return $0
        }
    }
    
    @IBAction func newLineClicked(_ sender: Any) {
        wpmLabel.stringValue = "0"
        let alert = NSAlert()
        alert.messageText = "Enter a new practice line"
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        
        let inputTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        alert.accessoryView = inputTextField
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            practiceLine.stringValue = inputTextField.stringValue
        }
        
        // begin listening for key strokes
        keyDown = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] in
            self?.keyDown(with: $0)
            return $0
        }
        
        
    }
    
    // MARK: NSAlert
    func showPopup() {
        endTime = Date()
        if let startTime = startTime, let endTime = endTime {
            let elapsedTime = endTime.timeIntervalSince(startTime) // in seconds
            let wpm = Int(Double(charCount) / elapsedTime * 60 / 4) // assuming 4 characters per word
            wpmLabel.stringValue = String(wpm)
            let wpmText = "WPM: \(wpm)"
            let alert = NSAlert()
            alert.messageText = "Done!\n\(wpmText)"
            alert.runModal()
        } else {
            let alert = NSAlert()
            alert.messageText = "Error: Could not calculate WPM."
            alert.runModal()
        }
        
    }


    

    // MARK: keyDown
    override func keyDown(with event: NSEvent) {
        let typedChar = event.charactersIgnoringModifiers ?? ""
        let practiceString = practiceLine.stringValue
        
        
        
        // Check if the typed character matches the current character in the practice string
        if typedChar == String(practiceString[practiceString.index(practiceString.startIndex, offsetBy: currentCharIndex)]) {
            charCount += 1
            
            // Create an attributed string with all the characters colored green up to the current character
            let attributedString = NSMutableAttributedString(string: practiceString)
            for i in 0..<currentCharIndex {
                attributedString.addAttribute(.foregroundColor, value: NSColor.disabledControlTextColor, range: NSRange(location: i, length: 1))
            }
            
            // Update the attributed string to mark the current character as typed correctly
            attributedString.addAttribute(.foregroundColor, value: NSColor.disabledControlTextColor, range: NSRange(location: currentCharIndex, length: 1))
            
            // Check if the string is done
            if currentCharIndex == practiceString.count-1 {
                practiceLine.attributedStringValue = attributedString
                showPopup() // Trigger pop-up text
                currentCharIndex = 0
                keyboardView.currentCharIndex = 0
                print("Done") // For debugging
                if let keyDown = keyDown {
                    NSEvent.removeMonitor(keyDown)
                    self.keyDown = nil
                }
            }
            // Check if there are more characters to be typed
            else if currentCharIndex < practiceString.count - 1 {
                // Update the index of the current character to the next character in the practice string
                currentCharIndex += 1
                
                // Mark the next character in the practice string as the current character to be typed
                attributedString.addAttribute(.foregroundColor, value: NSColor.blue, range: NSRange(location: currentCharIndex, length: 1))
            }
            
            // Set the attributed string as the string value of the practiceLine text field
            practiceLine.attributedStringValue = attributedString
            
            keyboardView.practiceLine = practiceLine.stringValue
            keyboardView.currentCharIndex = currentCharIndex

        }
        
    }

    deinit {
        if let keyDownMonitor = keyDown {
            NSEvent.removeMonitor(keyDownMonitor)
        }
    }
}


