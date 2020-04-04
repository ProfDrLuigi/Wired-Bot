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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.addObserver(self, forKeyPath: "Connected", options: NSKeyValueObservingOptions.new, context: nil)
        
        // Do any additional setup after loading the view.
    }
    
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        print("bllaaaaa")
    }
}
