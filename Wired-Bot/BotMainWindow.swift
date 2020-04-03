//
//  BotMainWindow.swift
//  Wired-Bot
//
//  Created by Prof. Dr. Luigi on 03.04.20.
//  Copyright © 2020 Read-Write. All rights reserved.
//

import Cocoa
import Foundation
import WiredSwift

class BotMainWindow: NSViewController {

    var connection:Connection?
   
    @IBAction func set_values(_ sender: Any) {
        let message = P7Message(withName: "wired.chat.send_say", spec: connection!.spec)
                message.addParameter(field: "wired.chat.id", value: UInt32(1))
                message.addParameter(field: "wired.chat.say", value: "Hello, world!")
        _ = connection!.send(message: message)
    }
}
