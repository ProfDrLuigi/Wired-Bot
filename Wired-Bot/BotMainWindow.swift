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
    
    
    @IBAction func connect(_ sender: Any) {
        let connected_check = UserDefaults.standard.bool(forKey: "Connected")
        if connected_check != true {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectbutton"), object: nil)
        }
    }
    
    @IBAction func disconnect(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Disconnectbutton"), object: nil)
    }

    @IBAction func reconnect(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Disconnectbutton"), object: nil)
            DispatchQueue.global(qos: .background).async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectbutton"), object: nil)
        }
    }
    
    @objc private func onlinestatus(notification: NSNotification){
     }
}
