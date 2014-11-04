//
//  ViewController.swift
//  AAC
//
//  Created by Byrdann Fox on 10/27/14.
//  Copyright (c) 2014 ExcepApps, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

var textViewness:String = ""
var speechPaused:Bool = false
var sentenceWordCount:Int = 0

class ViewController: UIViewController, UITextViewDelegate, AVSpeechSynthesizerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var textView:UITextView!
    
    override func viewDidAppear(animated:Bool) {
        
        super.viewDidAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: true)
      
        textView.delegate = self
        
        textView?.text = textViewness
        
        textView?.becomeFirstResponder()
        
    }
    
    var saveShortcutButton:UIButton!
    
    func saveShortcutButtonIsPressed(sender:UIButton) {
        
        if textView?.text != nil && textView?.text != "" {

            var ttsText = textView!.text
            
            appDelegate.createNewShortcut(ttsText)
                        
            ttsText = nil
            
        } else {
            
            let alert = UIAlertView()
            alert.title = "Type in some text"
            alert.message = ""
            alert.addButtonWithTitle("Done")
            alert.show()
            
        }
        
    }
    
    var clearTextButton:UIButton!
    
    func clearTextButtonIsPressed(sender:UIButton) {
        
        textView?.text = nil
        self.synthesizer.stopSpeakingAtBoundary(.Immediate)
        
    }
    
    var shortcutsButton:UIButton!
    
    func segueToShortcuts(sender:UIButton) {

        textViewness = textView!.text
        
        performSegueWithIdentifier("TableView", sender: shortcutsButton)
        
    }
    
    var speakOrPauseButton:UIButton!
    
    func speakOrPauseButtonIsPressed(sender:UIButton) {
        
        // fix condition...
        if textView?.text != nil && textView?.text != "" {
            
            
            
            if speechPaused == false {
                
                self.speakOrPauseButton.setTitle("Pause", forState: .Normal)
                self.synthesizer.continueSpeaking()
                speechPaused = true
                
            } else {
                
                self.speakOrPauseButton.setTitle("Speak", forState: .Normal)
                speechPaused = false
                self.synthesizer.pauseSpeakingAtBoundary(.Immediate)
                
            }
            
            if self.synthesizer.speaking == false {
                
                var text:String = textView!.text
                var utterance:AVSpeechUtterance = AVSpeechUtterance(string:text)
                utterance.rate = 0.02
                self.synthesizer.speakUtterance(utterance)
                
            }
        
        } else {
            
            let alert = UIAlertView()
            alert.title = "Type in some text"
            alert.message = ""
            alert.addButtonWithTitle("Done")
            alert.show()
            
        }
        
    }
    
    var synthesizer:AVSpeechSynthesizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.synthesizer = AVSpeechSynthesizer()
        self.synthesizer.delegate = self
        speechPaused = false
        
        textView?.sizeToFit()
        textView?.layoutIfNeeded()
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: 320, height: 220))
        textView?.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        textView?.font = UIFont.systemFontOfSize(20)
        textView?.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(textView!)
    
        speakOrPauseButton = UIButton.buttonWithType(.System) as? UIButton
        speakOrPauseButton.frame = CGRect(x: 250, y: 245, width: 65, height: 44)
        speakOrPauseButton.setTitle("Speak", forState: .Normal)
        speakOrPauseButton.addTarget(self, action: "speakOrPauseButtonIsPressed:", forControlEvents: .TouchDown)
        speakOrPauseButton.backgroundColor = UIColor.lightGrayColor()
        speakOrPauseButton.layer.cornerRadius = 5
        view.addSubview(speakOrPauseButton)
        
        saveShortcutButton = UIButton.buttonWithType(.System) as? UIButton
        saveShortcutButton.frame = CGRect(x: 100, y: 245, width: 70, height: 44)
        saveShortcutButton.setTitle("Save", forState: .Normal)
        saveShortcutButton.addTarget(self, action: "saveShortcutButtonIsPressed:", forControlEvents: .TouchDown)
        saveShortcutButton.backgroundColor = UIColor.lightGrayColor()
        saveShortcutButton.layer.cornerRadius = 5
        view.addSubview(saveShortcutButton)
        
        clearTextButton = UIButton.buttonWithType(.System) as? UIButton
        clearTextButton.frame = CGRect(x: 175, y: 245, width: 70, height: 44)
        clearTextButton.setTitle("Clear", forState: .Normal)
        clearTextButton.addTarget(self, action: "clearTextButtonIsPressed:", forControlEvents: .TouchDown)
        clearTextButton.backgroundColor = UIColor.lightGrayColor()
        clearTextButton.layer.cornerRadius = 5
        view.addSubview(clearTextButton)
        
        shortcutsButton = UIButton.buttonWithType(.System) as? UIButton
        shortcutsButton.frame = CGRect(x: 5, y: 245, width: 90, height: 44)
        shortcutsButton.setTitle("Shortcuts", forState: .Normal)
        shortcutsButton.addTarget(self, action: "segueToShortcuts:", forControlEvents: .TouchDown)
        shortcutsButton.backgroundColor = UIColor.lightGrayColor()
        shortcutsButton.layer.cornerRadius = 5
        view.addSubview(shortcutsButton)
        
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        
        self.speakOrPauseButton.setTitle("Speak", forState: .Normal)
        speechPaused = false
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == " " {
            
            sentenceWordCount += 1
            println(sentenceWordCount)
            
        }
        
        return false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}