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

    @IBAction func set_values(_ sender: Any) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Sendbutton"), object: nil, userInfo: ["name" : self.send_button.stringValue as Any])
    }

}
