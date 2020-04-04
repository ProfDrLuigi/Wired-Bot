//
//  AppDelegate.swift
//  lkjsljflksdjflksjd
//
//  Created by Prof. Dr. Luigi on 03.04.20.
//  Copyright © 2020 Prof. Dr. Luigi. All rights reserved.
//

import Cocoa
import WiredSwift
import ShellOut
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, ConnectionDelegate {

    @IBOutlet weak var send_button: NSButton!
    @IBOutlet weak var disconnect_button: NSButton!
    @IBOutlet weak var connect_button: NSButton!
    
    func applicationShouldTerminateAfterLastWindowClosed (_
        theApplication: NSApplication) -> Bool {
        return true
    }

    var connection:Connection?
    
    func connectionDidReceiveMessage(connection: Connection, message: P7Message) {
        if connection == self.connection {
            //if message.name == "wired.chat.user_kick" {
              //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectbutton"), object: nil, userInfo: ["name" : connect_button])
            //}
            if message.name == "wired.chat.say" {
                // if the message contains a string in 'wired.chat.say' field
                if let saidText = message.string(forField: "wired.chat.say") {
                    // the message message starts with 'Hello'
                    if saidText.starts(with: "Hello Bot") {
                        // we auto reply 'Hey'
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        response.addParameter(field: "wired.chat.say", value: "Hey :-)")
                        _ = connection.send(message: response)
                    }
                    if saidText.starts(with: "Go away") {
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        response.addParameter(field: "wired.chat.say", value: "Moooo :(")
                        _ = connection.send(message: response)
                    }
                    if saidText.starts(with: "/bot uptime") {
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        do {
                        let output = try shellOut(to: "uptime")
                        response.addParameter(field: "wired.chat.say", value: output)
                        _ = connection.send(message: response)
                        } catch {
                            _ = error as! ShellOutError
                        }
                     }
                     if saidText.starts(with: "/bot date") {
                       let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                       response.addParameter(field: "wired.chat.id", value: UInt32(1))
                       do {
                       let output = try shellOut(to: "date")
                       response.addParameter(field: "wired.chat.say", value: output)
                       _ = connection.send(message: response)
                       } catch {
                           _ = error as! ShellOutError
                       }
                    }
                     if saidText.starts(with: "/bot test") {
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        do {
                        let output = try shellOut(to: "base64 /Users/luigi/Desktop/test.png")
                        response.addParameter(field: "wired.chat.say", value: output)
                        UserDefaults.standard.set(output, forKey: "Avatar")
                        _ = connection.send(message: response)
                        } catch {
                            _ = error as! ShellOutError
                        }
                        
                    }
                    if saidText.starts(with: "/bot factme") {
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        do {
                        let output = try shellOut(to: "curl -is --raw https://api.chucknorris.io/jokes/random | sed 's/.*value\"://g' | tail -n 1 | sed 's/}//g'")
                        response.addParameter(field: "wired.chat.say", value: output)
                        _ = connection.send(message: response)
                        } catch {
                            _ = error as! ShellOutError
                        }
                     }
                    if saidText.starts(with: "/bot postilon") {
                       let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                       response.addParameter(field: "wired.chat.id", value: UInt32(1))
                       do {
                       let output = try shellOut(to: "curl -is --raw https://wired.istation.pw/postilon.txt | sort -R | head -n 1")
                       response.addParameter(field: "wired.chat.say", value: output)
                       _ = connection.send(message: response)
                       } catch {
                           _ = error as! ShellOutError
                       }
                    }
                    if saidText.starts(with: "/bot roundhouseme") {
                       let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                       response.addParameter(field: "wired.chat.id", value: UInt32(1))
                       do {
                       let output = try shellOut(to: "curl -is --raw https://wired.istation.pw/chuck.txt | sort -R | head -n 1")
                       response.addParameter(field: "wired.chat.say", value: output)
                       _ = connection.send(message: response)
                       } catch {
                           _ = error as! ShellOutError
                       }
                    }
                }
             }
            if message.name == "wired.chat.user_join" {
                let welcome = UserDefaults.standard.bool(forKey: "WelcomeUsers")
                if welcome == true {
                   let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                   response.addParameter(field: "wired.chat.id", value: UInt32(1))
                   response.addParameter(field: "wired.chat.say", value: "Hello my friend. :-)")
                   sleep(2)
                   _ = connection.send(message: response)
                }
            }
            if message.name == "wired.chat.user_leave" {
               let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
               response.addParameter(field: "wired.chat.id", value: UInt32(1))
               response.addParameter(field: "wired.chat.say", value: "Hope to see you soon again. :(")
               //_ = connection.send(message: response)
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
        
        //UserDefaults.standard.set(false, forKey: "Connected")
 
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.setNick),
        name: NSNotification.Name(rawValue: "setNick"),
        object: nil)
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.setStatus),
        name: NSNotification.Name(rawValue: "setStatus"),
        object: nil)
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.setIcon),
        name: NSNotification.Name(rawValue: "setIcon"),
        object: nil)
 
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.pressConnectbutton),
        name: NSNotification.Name(rawValue: "Connectbutton"),
        object: nil)
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.pressDisconnectbutton),
        name: NSNotification.Name(rawValue: "Disconnectbutton"),
        object: nil)
        
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
        let greeting_check = UserDefaults.standard.string(forKey: "Greeting_Text")
        if greeting_check == nil {
            UserDefaults.standard.set("Hi Folx, whazzup? :-)", forKey: "Greeting_Text")
        }
        let goodbye_check = UserDefaults.standard.string(forKey: "Goodbye_Text")
        if goodbye_check == nil {
            UserDefaults.standard.set("See ya Folx!", forKey: "Goodbye_Text")
        }
        let avatar_check = UserDefaults.standard.string(forKey: "Avatar")
        if avatar_check == nil {
            UserDefaults.standard.set(usericon, forKey: "Avatar")
        }
        
        let autoconnect = UserDefaults.standard.bool(forKey: "Autoconnect")
        if autoconnect == true {
        
            let spec = P7Spec()

            let get_url = UserDefaults.standard.string(forKey: "Address")!
            let url = Url(withString: "wired://" + get_url )

            let connection = Connection(withSpec: spec, delegate: self)

            let nickname = UserDefaults.standard.string(forKey: "Nick")
            connection.nick = (nickname ?? "")

            let status = UserDefaults.standard.string(forKey: "Status")
            connection.status = (status ?? "")

            if connection.connect(withUrl: url) {
                //let message = P7Message(withName: "wired.send_login", spec: connection.spec)
                //message.addParameter(field: "wired.user.login", value: "admin")
                //message.addParameter(field: "wired.user.password", value: "")
                //_ = connection.send(message: message)
                _ = connection.joinChat(chatID: 1)
                self.connection = connection
                let message2 = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                message2.addParameter(field: "wired.chat.id", value: UInt32(1))
                let chat_text = UserDefaults.standard.string(forKey: "Greeting_Text")
                message2.addParameter(field: "wired.chat.say", value: chat_text)
                let greeting = UserDefaults.standard.bool(forKey: "Greeting")
                if greeting == true {
                    _ = connection.send(message: message2)
                }
                UserDefaults.standard.set(true, forKey: "Connected")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectionstatus"), object: nil)
                
                let picture = UserDefaults.standard.string(forKey: "Avatar") ?? ""
                let avatar = P7Message(withName: "wired.user.set_icon", spec: connection.spec)
                avatar.addParameter(field: "wired.user.icon", value: Data(base64Encoded: picture, options: .ignoreUnknownCharacters))
                _ = connection.send(message: avatar)
                
            } else {
                print(connection.socket.errors)
                connectalert()
            }
        }
    }

    
    func applicationWillTerminate(_ aNotification: Notification) {
        let defaults = UserDefaults.standard
        defaults.synchronize()
            if let connection = self.connection {
                if connection.isConnected() {
                    let message = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                    message.addParameter(field: "wired.chat.id", value: UInt32(1))
                    let chat_text = UserDefaults.standard.string(forKey: "Goodbye_Text")
                    message.addParameter(field: "wired.chat.say", value: chat_text)
                    let goodbye = UserDefaults.standard.bool(forKey: "Goodbye")
                    if goodbye == true {
                        _ = connection.send(message: message)
                    }
                    UserDefaults.standard.set(false, forKey: "Connected")
            }
        }
    }

    
    @objc private func setNick(notification: NSNotification){
        let defaults = UserDefaults.standard
        defaults.synchronize()
        if let connection = self.connection {
            if connection.isConnected() {
                let message_nick = P7Message(withName: "wired.user.set_nick", spec: connection.spec)
                let nick = UserDefaults.standard.string(forKey: "Nick")
                message_nick.addParameter(field: "wired.user.nick", value: nick)
                _ = connection.send(message: message_nick)
            }
        }
    }
    
    
    @objc private func setStatus(notification: NSNotification){
        let defaults = UserDefaults.standard
        defaults.synchronize()
        if let connection = self.connection {
            if connection.isConnected() {
                let message_status = P7Message(withName: "wired.user.set_status", spec: connection.spec)
                let status = UserDefaults.standard.string(forKey: "Status")
                message_status.addParameter(field: "wired.user.status", value: status)
                _ = connection.send(message: message_status)
            }
        }
    }
    
    
    @objc private func setIcon(notification: NSNotification){
        if let connection = self.connection {
            if connection.isConnected() {
                let message = P7Message(withName: "wired.user.set_icon", spec: connection.spec)
                do {
                let iconsrc = UserDefaults.standard.string(forKey: "IconSrc") ?? ""
                let output = try shellOut(to: "base64", arguments: [iconsrc])
                UserDefaults.standard.set(output, forKey: "Avatar")
                print(output)
                message.addParameter(field: "wired.user.icon", value: Data(base64Encoded: output, options: .ignoreUnknownCharacters))
                _ = connection.send(message: message)
                } catch {
                    _ = error as! ShellOutError
                }
            }
        }
    }
    
    @objc private func pressConnectbutton(notification: NSNotification){

        let spec = P7Spec()

        let get_url = UserDefaults.standard.string(forKey: "Address")!
        let url = Url(withString: "wired://" + get_url )

        let connection = Connection(withSpec: spec, delegate: self)

        let nickname = UserDefaults.standard.string(forKey: "Nick")
        connection.nick = (nickname ?? "")

        let status = UserDefaults.standard.string(forKey: "Status")
        connection.status = (status ?? "")

        if connection.connect(withUrl: url) {
            //let message = P7Message(withName: "wired.send_login", spec: connection.spec)
            //message.addParameter(field: "wired.user.login", value: "admin")
            //message.addParameter(field: "wired.user.password", value: "")
            //_ = connection.send(message: message)
            _ = connection.joinChat(chatID: 1)
            self.connection = connection
            let message2 = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
            message2.addParameter(field: "wired.chat.id", value: UInt32(1))
            let chat_text = UserDefaults.standard.string(forKey: "Greeting_Text")
            message2.addParameter(field: "wired.chat.say", value: chat_text)
            let greeting = UserDefaults.standard.bool(forKey: "Greeting")
            if greeting == true {
                _ = connection.send(message: message2)
            }
            UserDefaults.standard.set(true, forKey: "Connected")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Connectionstatus"), object: nil)
            
            let picture = UserDefaults.standard.string(forKey: "Avatar") ?? ""
            let avatar = P7Message(withName: "wired.user.set_icon", spec: connection.spec)
            avatar.addParameter(field: "wired.user.icon", value: Data(base64Encoded: picture, options: .ignoreUnknownCharacters))
            _ = connection.send(message: avatar)
        } else {
            print(connection.socket.errors)
            connectalert()
        }

    }

    
    @objc private func pressDisconnectbutton(notification: NSNotification){
        if let connection = self.connection {
            if connection.isConnected() {
                _ = connection.disconnect()
                UserDefaults.standard.set(false, forKey: "Connected")
            }
        }
    }

    
    func connectalert (){
        print("conn refused")
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("It is not possible to log on to the server", comment: "")
        alert.informativeText = NSLocalizedString("Maybe it is not running or the access data is wrong!", comment: "")
        alert.alertStyle = .warning
        let Button = NSLocalizedString("Bummer", comment: "")
        alert.addButton(withTitle: Button)
        alert.runModal()
    }
    
    let usericon = "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"
    
}
