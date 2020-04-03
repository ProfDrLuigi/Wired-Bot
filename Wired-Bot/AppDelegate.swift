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
                    if saidText.starts(with: "Go away") {
                        // we auto reply 'Hey'
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        response.addParameter(field: "wired.chat.say", value: "Moooo :(")
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
        let nickname_check = UserDefaults.standard.string(forKey: "Nick")
        if nickname_check == nil {
            UserDefaults.standard.set("Wired-Bot", forKey: "Nick")
        }
        let status_check = UserDefaults.standard.string(forKey: "Status")
        if status_check == nil {
            UserDefaults.standard.set("Watching you :-)", forKey: "Status")
        }
        let address_check = UserDefaults.standard.string(forKey: "Address")
        if address_check == nil {
            UserDefaults.standard.set("localhost:4871", forKey: "Address")
        }
        let login_check = UserDefaults.standard.string(forKey: "Login")
        if login_check == nil {
            UserDefaults.standard.set("guest", forKey: "Login")
        }
        let password_check = UserDefaults.standard.string(forKey: "Password")
        if password_check == nil {
            UserDefaults.standard.set("", forKey: "Password")
        }
                
        let spec = P7Spec()

        let get_url = UserDefaults.standard.string(forKey: "Address")!
        let url = Url(withString: "wired://" + get_url )

        let connection = Connection(withSpec: spec, delegate: self)

        let nickname = UserDefaults.standard.string(forKey: "Nick")
        connection.nick = (nickname ?? "")

        let status = UserDefaults.standard.string(forKey: "Status")
        connection.status = (status ?? "")

        if connection.connect(withUrl: url) {
            print("connected")
            _ = connection.joinChat(chatID: 1)
            // we keep a reference to the working connection here
            self.connection = connection
            let message = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
            message.addParameter(field: "wired.chat.id", value: UInt32(1))
            message.addParameter(field: "wired.chat.say", value: "Hi Folx, whazzup?")
            _ = connection.send(message: message)
        } else {
            print(connection.socket.errors)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
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
