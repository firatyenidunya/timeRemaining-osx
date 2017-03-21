//
//  ViewController.swift
//  Time Remaining
//
//  Created by Firat on 21/03/2017.
//  Copyright © 2017 calisma. All rights reserved.
//

import Cocoa
import Foundation
class ViewController: NSViewController {
    @IBOutlet var remainingTime: NSTextField!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullString    = String(bash(command: "pmset",arguments: ["-g","batt"]))
        
        var fullStringArr = fullString?.components(separatedBy: "discharging;")
        
        let stringArr1 = fullStringArr?[1]
        
        fullStringArr = stringArr1?.components(separatedBy: "remaining present")
        
        let time = fullStringArr?[0]
        
        self.remainingTime.stringValue = time!
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func shell(launchPath: String, arguments: [String]) -> String
    {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)!
        if output.characters.count > 0 {
            //remove newline character.
            let lastIndex = output.index(before: output.endIndex)
            return output[output.startIndex ..< lastIndex]
        }
        return output
    }
    
    func bash(command: String, arguments: [String]) -> String {
        let whichPathForCommand = shell(launchPath: "/bin/bash", arguments: [ "-l", "-c", "which \(command)" ])
        return shell(launchPath: whichPathForCommand, arguments: arguments)
    }

}

