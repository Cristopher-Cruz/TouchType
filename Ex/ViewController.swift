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
    
    @IBOutlet var startButton: NSButton!
    
    @IBOutlet var practiceLine: NSTextField!
    
    @IBOutlet var eventLabel: NSTextField!
    
    
    @IBAction func startClicked(_ sender: Any) {
        // Set the string value to the entered text
        userInput.stringValue = userInput.stringValue
        
        // Disable the userInput text field
        userInput.isEnabled = false
        
        // Remove the placeholder text
        userInput.placeholderString = nil
        
        // Change the text color to a visible color
        userInput.textColor = NSColor.white
        
        // Unhide the practice line field
        practiceLine.isHidden = false
        
        // create input string to pass into NSMutableAttributedString
        let inputString = userInput.stringValue
        practiceLine.stringValue = inputString
        
        // Create an attributed string with the first character in a different color
        let attributedString = NSMutableAttributedString(string: inputString)
        attributedString.addAttribute(.foregroundColor, value: NSColor.red, range: NSRange(location: 0, length: 1))
        
        // Set the attributed string as the string value of the practiceLine text field
        practiceLine.attributedStringValue = attributedString
        
        eventLabel.isHidden = false
        
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
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    override func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        switch event.phase {
        case [.began]:
            print("scrollWheel began scrolling")
        case [.ended]:
            print("scrollWheel ended scrolling")
        default:
            break
        }
        print(event.locationInWindow)
        print(event.timestamp)
        print(event.window ?? "")
        print(event.windowNumber)
    }
    
    override func keyDown(with event: NSEvent) {
        
        eventLabel.stringValue = "key = " + (event.charactersIgnoringModifiers ?? "")
        eventLabel.stringValue += "\ncharacter = " + (event.characters ?? "")
                                             
    }
    
    override func flagsChanged(with event: NSEvent) {
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.shift]:
            print("shift key is pressed")
        case [.control]:
            print("control key is pressed")
        case [.option] :
            print("option key is pressed")
        case [.command]:
            print("Command key is pressed")
        case [.control, .shift]:
            print("control-shift keys are pressed")
        case [.option, .shift]:
            print("option-shift keys are pressed")
        case [.command, .shift]:
            print("command-shift keys are pressed")
        case [.control, .option]:
            print("control-option keys are pressed")
        case [.control, .command]:
            print("control-command keys are pressed")
        case [.option, .command]:
            print("option-command keys are pressed")
        case [.shift, .control, .option]:
            print("shift-control-option keys are pressed")
        case [.shift, .control, .command]:
            print("shift-control-command keys are pressed")
        case [.control, .option, .command]:
            print("control-option-command keys are pressed")
        case [.shift, .command, .option]:
            print("shift-command-option keys are pressed")
        case [.shift, .control, .option, .command]:
            print("shift-control-option-command keys are pressed")
        default:
            print("no modifier keys are pressed")
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

