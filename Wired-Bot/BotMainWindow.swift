//
//  BotMainWindow.swift
//  Wired-Bot
//
//  Created by Prof. Dr. Luigi on 03.04.20.
//  Copyright © 2020 Read-Write. All rights reserved.
//

import Cocoa
import Foundation

class BotMainWindow: NSViewController {
    

    @IBOutlet weak var connect_indicator_red: NSImageView!
    @IBOutlet weak var connect_indicator_green: NSImageView!
    
    
    @IBOutlet weak var connect_button: NSButton!
    @IBOutlet weak var disconnect_button: NSButton!
    @IBOutlet weak var wired_green: NSImageView!
    @IBOutlet weak var wired_red: NSImageView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.Connectionstatus),
        name: NSNotification.Name(rawValue: "Connectionstatus"),
        object: nil)
    }
    
    @IBAction func connect(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectbutton"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectionstatus"), object: nil)
    }
    
    @IBAction func disconnect(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Disconnectbutton"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectionstatus"), object: nil)
    }

    @objc private func Connectionstatus(notification: NSNotification){
        let connected = UserDefaults.standard.bool(forKey: "Connected")
        if connected == true {
            self.connect_indicator_red.isHidden = true
            self.connect_indicator_green.isHidden = false
            self.disconnect_button.isHidden = false
            self.connect_button.isHidden = true
            self.wired_red.isHidden = true
            self.wired_green.isHidden = false
        } else {
            self.connect_indicator_red.isHidden = false
            self.connect_indicator_green.isHidden = true
            self.disconnect_button.isHidden = true
            self.connect_button.isHidden = false
            self.wired_red.isHidden = false
            self.wired_green.isHidden = true
        }
    }
}
