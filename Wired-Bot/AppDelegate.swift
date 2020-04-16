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

    private var lastPingDate:Date!
    private var pingCheckTimer:Timer!
    
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
                        response.addParameter(field: "wired.chat.say", value: "Moooo :(")
                        _ = connection.send(message: response)
                        
                    }
                    if saidText.starts(with: "/bot factme") {
                        let picture = factme
                        let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                        response.addParameter(field: "wired.chat.id", value: UInt32(1))
                        do {
                        let output = try shellOut(to: "curl -is --raw https://api.chucknorris.io/jokes/random | sed 's/.*value\"://g' | tail -n 1 | sed 's/}//g'")
                        response.addParameter(field: "wired.chat.say", value: Data(base64Encoded: picture, options: .ignoreUnknownCharacters))
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
               _ = connection.send(message: response)
            }
            let watchedfolder = UserDefaults.standard.string(forKey: "WatchedFolder") ?? ""
            if watchedfolder != "" {
                if message.name == "wired.file.directory_changed" {
                    let names = ["Yes. Fresh meat is arrived in ", "Woohoo. We have some new stuff in ", "WTF? Believe it or not. New Stuff in "]
                    let randomName = names.randomElement()!
                    let watchedfolder = UserDefaults.standard.string(forKey: "WatchedFolder") ?? ""
                    let response = P7Message(withName: "wired.chat.send_say", spec: connection.spec)
                    response.addParameter(field: "wired.chat.id", value: UInt32(1))
                    response.addParameter(field: "wired.chat.say", value: "📂 " + randomName + "\"" + watchedfolder + "\"")
                    _ = connection.send(message: response)
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
            let user_login = UserDefaults.standard.string(forKey: "Login")
            let user_pass = UserDefaults.standard.string(forKey: "Password")
            url.login = user_login ?? ""
            url.password = user_pass ?? ""

            let connection = Connection(withSpec: spec, delegate: self)

            let nickname = UserDefaults.standard.string(forKey: "Nick")
            connection.nick = (nickname ?? "")

            let status = UserDefaults.standard.string(forKey: "Status")
            connection.status = (status ?? "")

            if connection.connect(withUrl: url) {
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

                let watchedfolder = UserDefaults.standard.string(forKey: "WatchedFolder") ?? ""
                
                let subscription = P7Message(withName: "wired.file.subscribe_directory", spec: connection.spec)
                subscription.addParameter(field: "wired.file.path", value: watchedfolder)
                _ = connection.send(message: subscription)
                
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
        let user_login = UserDefaults.standard.string(forKey: "Login")
        let user_pass = UserDefaults.standard.string(forKey: "Password")
        url.login = user_login ?? ""
        url.password = user_pass ?? ""

        let connection = Connection(withSpec: spec, delegate: self)

        let nickname = UserDefaults.standard.string(forKey: "Nick")
        connection.nick = (nickname ?? "")

        let status = UserDefaults.standard.string(forKey: "Status")
        connection.status = (status ?? "")

        if connection.connect(withUrl: url) {
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

            let watchedfolder = UserDefaults.standard.string(forKey: "WatchedFolder") ?? ""
            
            let subscription = P7Message(withName: "wired.file.subscribe_directory", spec: connection.spec)
            subscription.addParameter(field: "wired.file.path", value: watchedfolder)
            _ = connection.send(message: subscription)
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
    
    let factme = "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"
    
}
