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

class ViewController: UIViewController, UITextViewDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    var textView:UITextView?

    override func viewDidAppear(animated:Bool) {
        
        super.viewDidAppear(animated)
        
        navigationItem.setHidesBackButton(true, animated: true)
      
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
            alert.title = "Alert"
            alert.message = "Create a shortcut!"
            alert.addButtonWithTitle("Done")
            alert.show()
            
        }
        
    }
    
    var clearTextButton:UIButton!
    
    func clearTextButtonIsPressed(sender:UIButton) {
        
        textView?.text = nil
        
    }
    
    var shortcutsButton:UIButton!
    
    func segueToShortcuts(sender:UIButton) {

        textViewness = textView!.text
        
        performSegueWithIdentifier("TableView", sender: shortcutsButton)
        
    }
    
    var speakOrPauseButton:UIButton!
    
    func speakOrPauseButtonIsPressed(sender:UIButton) {
        
        if textView?.text != nil && textView?.text != "" {
            
            var mySpeechSynthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
            var myString:String = textView!.text
            var mySpeechUtterance:AVSpeechUtterance = AVSpeechUtterance(string:myString)
            mySpeechUtterance.rate = 0.2
            mySpeechSynthesizer.speakUtterance(mySpeechUtterance)
        
        } else {
            
            let alert = UIAlertView()
            alert.title = "Alert"
            alert.message = "Type in some text!"
            alert.addButtonWithTitle("Done")
            alert.show()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}