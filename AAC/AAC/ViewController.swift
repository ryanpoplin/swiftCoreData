//
//  ViewController.swift
//  AAC
//
//  Created by Byrdann Fox on 10/27/14.
//  Copyright (c) 2014 ExcepApps, Inc. All rights reserved.
//

// GET THE CORE LOCATION FRAMEWORK OUT OF THE PROJECT IF NEEDED...

import UIKit
import AVFoundation
import QuartzCore
import JavaScriptCore

var textViewness:String = ""
var speechPaused:Bool = false

var speakOrPauseButton:UIButton!
var saveShortcutButton:UIButton!

class ViewController: UIViewController, UITextViewDelegate, AVSpeechSynthesizerDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var textView:UITextView!
    
    override func viewDidAppear(animated:Bool) {
        
        super.viewDidAppear(animated)
        
        textView.delegate = self
        
        textView?.text = textViewness
        
        textView?.becomeFirstResponder()
        
    }
    
    func saveShortcutButtonIsPressed(sender:UIButton) {
        
        var textString:NSString = textView.text
        var charSet:NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var trimmedString:NSString = textString.stringByTrimmingCharactersInSet(charSet)
        
        if trimmedString.length == 0 {
            
        } else {
            
            var ttsText = textView!.text
            
            appDelegate.createNewShortcut(ttsText)
            
            ttsText = nil
            
        }
        
    }
    
    var clearTextButton:UIButton!
    
    func clearTextButtonIsPressed(sender:UIButton) {
        
        textView?.text = nil
        speakOrPauseButton.enabled = false
        saveShortcutButton.enabled = false
        self.synthesizer.stopSpeakingAtBoundary(.Immediate)
        
    }
    
    var shortcutsButton:UIButton!
    
    func segueToShortcuts(sender:UIButton) {
        
        textViewness = textView!.text
        
        performSegueWithIdentifier("TableView", sender: shortcutsButton)
        
    }
    
    func speakOrPauseButtonIsPressed(sender:UIButton) {
        
        var textString:NSString = textView.text
        var charSet:NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var trimmedString:NSString = textString.stringByTrimmingCharactersInSet(charSet)
        
        if trimmedString.length == 0 {
            
        } else {
            
            if speechPaused == false {
                
                speakOrPauseButton.setTitle("Pause", forState: .Normal)
                self.synthesizer.continueSpeaking()
                speechPaused = true
                
            } else {
                
                speakOrPauseButton.setTitle("Speak", forState: .Normal)
                speechPaused = false
                self.synthesizer.pauseSpeakingAtBoundary(.Immediate)
                
            }
            
            if self.synthesizer.speaking == false {
                
                var text:String = textView!.text
                var utterance:AVSpeechUtterance = AVSpeechUtterance(string:text)
                utterance.rate = 0.02
                self.synthesizer.speakUtterance(utterance)
                
            }

        }
        
    }
    
    var synthesizer:AVSpeechSynthesizer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.synthesizer = AVSpeechSynthesizer()
        self.synthesizer.delegate = self
        speechPaused = false
        
        var textViewWidth = 0
        var textViewHeight = 0
        
        var buttonWidth = 0
        var buttonHeight = 0
        var buttonX = 0
        var buttonY = 0
        
        if (self.view.bounds.size.width == 1024) {
            
            textViewWidth = 1024
            textViewHeight = 220
            
            buttonWidth = 120
            buttonHeight = 70
            
            buttonX = 650
            buttonY = 250
            
        /*} else if (self.view.bounds.size.width > 568) {
            
            textViewWidth = 768
            textViewHeight = 220*/
            
        } else {
            
            textViewWidth = 320
            textViewHeight = 220
            
            /*buttonWidth = 65
            buttonHeight = 44
            buttonX = 250
            buttonY = 245*/
            
        }
        
        textView?.sizeToFit()
        textView?.layoutIfNeeded()
        textView = UITextView(frame: CGRect(x: 0, y: 0, width: textViewWidth, height: textViewHeight))
        textView?.contentInset = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        textView?.font = UIFont.systemFontOfSize(20)
        textView?.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(textView!)
    
        speakOrPauseButton = UIButton.buttonWithType(.System) as? UIButton
        speakOrPauseButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        speakOrPauseButton.setTitle("Speak", forState: .Normal)
        speakOrPauseButton.addTarget(self, action: "speakOrPauseButtonIsPressed:", forControlEvents: .TouchDown)
        speakOrPauseButton.backgroundColor = UIColor.lightGrayColor()
        speakOrPauseButton.layer.cornerRadius = 5
        view.addSubview(speakOrPauseButton)
        
        saveShortcutButton = UIButton.buttonWithType(.System) as? UIButton
        saveShortcutButton.frame = CGRect(x: 390, y: buttonY, width: buttonWidth, height: buttonHeight)
        saveShortcutButton.setTitle("Save", forState: .Normal)
        saveShortcutButton.addTarget(self, action: "saveShortcutButtonIsPressed:", forControlEvents: .TouchDown)
        saveShortcutButton.backgroundColor = UIColor.lightGrayColor()
        saveShortcutButton.layer.cornerRadius = 5
        view.addSubview(saveShortcutButton)
        
        clearTextButton = UIButton.buttonWithType(.System) as? UIButton
        clearTextButton.frame = CGRect(x: 520, y: buttonY, width: buttonWidth, height: buttonHeight)
        clearTextButton.setTitle("Clear", forState: .Normal)
        clearTextButton.addTarget(self, action: "clearTextButtonIsPressed:", forControlEvents: .TouchDown)
        clearTextButton.backgroundColor = UIColor.lightGrayColor()
        clearTextButton.layer.cornerRadius = 5
        view.addSubview(clearTextButton)
        
        shortcutsButton = UIButton.buttonWithType(.System) as? UIButton
        shortcutsButton.frame = CGRect(x: 260, y: buttonY, width: buttonWidth, height: buttonHeight)
        shortcutsButton.setTitle("Shortcuts", forState: .Normal)
        shortcutsButton.addTarget(self, action: "segueToShortcuts:", forControlEvents: .TouchDown)
        shortcutsButton.backgroundColor = UIColor.lightGrayColor()
        shortcutsButton.layer.cornerRadius = 5
        view.addSubview(shortcutsButton)
        
        speakOrPauseButton.enabled = false
        saveShortcutButton.enabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
    
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        
        speakOrPauseButton.setTitle("Speak", forState: .Normal)
        speechPaused = false
        var sentenceText:String = textView.text
        analyzeText(sentenceText)
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        var textString:NSString = textView.text
        var charSet:NSCharacterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        var trimmedString:NSString = textString.stringByTrimmingCharactersInSet(charSet)
        
        if trimmedString.length == 0 {
            
            speakOrPauseButton.enabled = false
            saveShortcutButton.enabled = false
            
        } else {
            
            speakOrPauseButton.enabled = true
            saveShortcutButton.enabled = true
            
        }
        
    }
    
    func analyzeText(text: String) {
        
        let context = JSContext(virtualMachine: JSVirtualMachine())
        
        let path = NSBundle.mainBundle().pathForResource("text", ofType: "js")
        
        let content = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        
        context.evaluateScript(content)
        
        let analyzeText = context.objectForKeyedSubscript("analyzeText")
        
        analyzeText.callWithArguments([text])

        let getSentences = context.objectForKeyedSubscript("getSentences")
        
        let getWordsCount = context.objectForKeyedSubscript("getWordsCount")
        
        let getWordsPerSentence = context.objectForKeyedSubscript("getWordsPerSentence")
        
        let getAverageWordLength = context.objectForKeyedSubscript("getAverageWordLength")
        
        var sentences = getSentences.callWithArguments([]).toNumber()
        var wordsCount = getWordsCount.callWithArguments([]).toNumber()
        var wordsPerSentence = getWordsPerSentence.callWithArguments([]).toNumber()
        var averageWordLength = getAverageWordLength.callWithArguments([]).toNumber()
        
        var dataDic:NSDictionary = [
            "text": text,
            "sentences": sentences,
            "wordsCount": wordsCount,
            "wordsPerSentence": wordsPerSentence,
            "averageWordLength": averageWordLength
        ]
        
        println(dataDic)
        
        let sentenceSpoken:NSString = "sentence_spoken"
        
        // HERE'S SOME COMMENTS...
        //
        //
        
        KeenClient.sharedClient().addEvent(dataDic, toEventCollection: sentenceSpoken, error: nil)
        
        KeenClient.sharedClient().uploadWithFinishedBlock({ (Void) -> Void in })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}