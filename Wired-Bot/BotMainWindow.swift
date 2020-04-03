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

    @IBOutlet weak var send_button: NSButton!
    @IBOutlet weak var disconnect_button: NSButton!
    @IBOutlet weak var connect_button: NSButton!

    @IBAction func set_values(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Sendbutton"), object: nil, userInfo: ["name" : self.send_button.stringValue as Any])
    }

    @IBAction func connect(_ sender: Any) {
        let connected_check = UserDefaults.standard.bool(forKey: "Connected")
        if connected_check != true {
            UserDefaults.standard.set("", forKey: "Password")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectbutton"), object: nil, userInfo: ["name" : self.connect_button.stringValue as Any])
        }
    }
    
    @IBAction func disconnect(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Disconnectbutton"), object: nil, userInfo: ["name" : self.disconnect_button.stringValue as Any])
        UserDefaults.standard.set(false, forKey: "Connected")
    }

    @IBAction func reconnect(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.synchronize()
        UserDefaults.standard.set(false, forKey: "Connected")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Disconnectbutton"), object: nil, userInfo: ["name" : self.disconnect_button.stringValue as Any])
            DispatchQueue.global(qos: .background).async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectbutton"), object: nil, userInfo: ["name" : self.connect_button.stringValue as Any])
            }
    }
}
