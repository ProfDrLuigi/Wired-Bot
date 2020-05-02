//
//  BotMainWindow.swift
//  Wired-Bot
//
//  Created by Prof. Dr. Luigi on 03.04.20.
//  Copyright © 2020 Read-Write. All rights reserved.
//

import Cocoa
import Foundation

class Preferences: NSViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func set_nick(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setNick"), object: nil)
    }
    
    @IBAction func set_status(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setStatus"), object: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        self.view.window?.close()
    }
    
   
}
