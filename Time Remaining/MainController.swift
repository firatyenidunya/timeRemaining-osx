//
//  ViewController.swift
//  Time Remaining
//
//  Created by Firat on 21/03/2017.
//  Copyright © 2017 resoft. All rights reserved.
//

import Cocoa
import Foundation

class MainController: NSViewController {
    @IBOutlet var remainingTime: NSTextField!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        print(getBatteryState())

       // self.remainingTime.stringValue = getBatteryState()
        print(getBatteryState())
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
 
    
    func getBatteryState() -> String
    {
        let task = Process()
        let pipe = Pipe()
        task.launchPath = "/usr/bin/pmset"
        task.arguments = ["-g", "batt"]
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
        
        let batteryArray = output.components(separatedBy: ";")
        
        let state = batteryArray[1].trimmingCharacters(in: NSCharacterSet.whitespaces).capitalized
        
        let percent = String.init(batteryArray[0].components(separatedBy: ")")[1].trimmingCharacters(in: NSCharacterSet.whitespaces).characters.dropLast())
        var remaining = String.init(batteryArray[2].characters.dropFirst().split(separator: " ")[0])
        if(remaining == "(no"){
            remaining = "Calculating"
        }
        return "%" + percent + "\n" + remaining + " " + state
    }
    
}

