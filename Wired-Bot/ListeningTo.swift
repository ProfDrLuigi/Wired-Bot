//
//  ListeningTo.swift
//  Wired-Bot
//
//  Created by Prof. Dr. Luigi on 03.04.20.
//  Copyright © 2020 Read-Write. All rights reserved.
//

import Cocoa
import Foundation

class ListeningTo: NSViewController {
    
    
    @IBOutlet weak var listening_to: NSButton!
    @IBOutlet weak var include_youtube: NSButton!
    @IBOutlet weak var listening_nick: NSTextField!
    
    override func viewDidLoad() {
        listening("")
    }
  
    @IBAction func listening(_ sender: Any) {
        let check_listening_to = UserDefaults.standard.bool(forKey: "ListeningTo")
        if check_listening_to == true {
            self.include_youtube.isEnabled = true
            self.listening_nick.isEnabled = true
        } else {
            self.include_youtube.isEnabled = false
            self.listening_nick.isEnabled = false
        }
    }


    
}
