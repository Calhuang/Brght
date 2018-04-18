//
//  PrefViewController.swift
//  Brght
//
//  Created by Calvin on 4/18/18.
//  Copyright © 2018 Calvin Huang. All rights reserved.
//

import Cocoa

class PrefViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBOutlet weak var notPluggedInText: NSTextField!
    @IBOutlet weak var pluggedInText: NSTextField!
    
    @IBAction func updateValues(_ sender: NSButton) {
        
        if notPluggedInText.stringValue != "" {
            KeepTrack.brightnessWhenNotPluggedIn = Double(notPluggedInText.stringValue)!
        }
        else {
            print(notPluggedInText.stringValue)
            print("Field needs a value!")
        }
        if pluggedInText.stringValue != "" {
            KeepTrack.brightnessWhenPluggedIn = Double(pluggedInText.stringValue)!
        }
        else {
            print("Field needs a value!")
        }
    }
    @IBAction func quitButton(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
    
    
}
extension PrefViewController {
    // Storyboard instantiation
    static func freshController() -> PrefViewController {

        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)

        let identifier = NSStoryboard.SceneIdentifier(rawValue: "PrefViewController")

        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PrefViewController else {
            fatalError("Why cant i find PrefViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
    
    
}
