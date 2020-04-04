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
    
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.Connectionstatus),
        name: NSNotification.Name(rawValue: "Connectionstatus"),
        object: nil)
    }
    
    
    @IBAction func connect(_ sender: Any) {
        let connected_check = UserDefaults.standard.bool(forKey: "Connected")
        if connected_check != true {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectbutton"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectionstatus"), object: nil)
        }
    }
    
    @IBAction func disconnect(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Disconnectbutton"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectionstatus"), object: nil)
    }

    @IBAction func reconnect(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Disconnectbutton"), object: nil)
            DispatchQueue.global(qos: .background).async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectbutton"), object: nil)
        }
    }

    @objc private func Connectionstatus(notification: NSNotification){
        let connected = UserDefaults.standard.bool(forKey: "Connected")
        if connected == true {
            self.connect_indicator_red.isHidden = true
            self.connect_indicator_green.isHidden = false
        } else {
            self.connect_indicator_red.isHidden = false
            self.connect_indicator_green.isHidden = true
        }
    }
}
