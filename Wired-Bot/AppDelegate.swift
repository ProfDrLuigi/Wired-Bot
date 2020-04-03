//
//  AppDelegate.swift
//  lkjsljflksdjflksjd
//
//  Created by Prof. Dr. Luigi on 03.04.20.
//  Copyright © 2020 Prof. Dr. Luigi. All rights reserved.
//

import Cocoa
import WiredSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, ConnectionDelegate {
    var connection:Connection?
    
    func connectionDidReceiveMessage(connection: Connection, message: P7Message) {
        // if the calling connection is the one we opened
        if connection == self.connection {
            // if it is a chat message
            if message.name == "wired.chat.say" {
                // if the message contains a string in 'wired.chat.say' field
                if let saidText = message.string(forField: "wired.chat.say") {
                    // the message message starts with 'Hello'
                    if saidText.starts(with: "Hello") {
                        // we auto reply 'Hey'
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        response.addParameter(field: "wired.chat.say", value: "Hey :-)")
                        _ = connection.send(message: response)
                    }
                }
             }
        }
    }
    
    func connectionDidReceiveError(connection: Connection, message: P7Message) {
        print("Error received: \(message)")
    }
    
    func connectionDisconnected(connection: Connection, error: Error?) {
        // if we received a disconnect signal, we clear the local connection reference
        self.connection = nil
    }

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let spec = P7Spec()

        // the Wired URL to connect to
        let url = Url(withString: "wired://localhost:4871")

        // init connection
        let connection = Connection(withSpec: spec, delegate: self)
        connection.nick = "Wired-Bot"
        connection.status = "I´m connected (:"

        // perform connect
        if connection.connect(withUrl: url) {
            print("connected")
            _ = connection.joinChat(chatID: 1)
            
            // we keep a reference to the working connection here
            self.connection = connection
        } else {
            // not connected
            print(connection.socket.errors)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func send_text(_ sender: Any) {
        // to send a test message on the connection we opened at launch
        
        // check if the local connection reference is not nil
        if let connection = self.connection {
            // if still connected
            if connection.isConnected() {
                let message = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                // public chat ID : DO NOT FORGET to cast to UInt32 here
                // this is an inconsistency in the framework that need to be fixed
                message.addParameter(field: "wired.chat.id", value: UInt32(1))
                message.addParameter(field: "wired.chat.say", value: "Hello, world!")
                
                _ = connection.send(message: message)
            }
        }
   }
}
