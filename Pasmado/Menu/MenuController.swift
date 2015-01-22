//
//  MenuController.swift
//  Pasmado
//
//  Created by Коньшин Алексей on 21.01.15.
//  Copyright (c) 2015 Коньшин Алексей. All rights reserved.
//

import Cocoa

class MenuController: NSObject, NSMenuDelegate, PasmadoDelegate {
    @IBOutlet var menu: NSMenu!
    @IBOutlet var statusItem: NSMenuItem!
    
    var mainItem = NSStatusBar.systemStatusBar().statusItemWithLength(45)
    let pasmado = PasmadoModel()
    
    var lastStatus = Status.Unknow
    
    override init() {
        super.init()
        
        self.pasmado.delegate = self
        self.pasmado.synchronize()
    }
    
    //MARK: - Actions
    
    func setupMenu() {
        self.menu.delegate = self
        self.mainItem.action = "test"
        
        self.mainItem.menu = self.menu
        self.mainItem.highlightMode = true
//        self.mainItem.title = "Pasmado"
        if let button = self.mainItem.button {
            button
        }
        
        self.pasmadoDidChange(self.pasmado)
    }
    
    
    func test() {
        println("test")
    }
    
    
    func updateMainItemText(pasmado: PasmadoModel) {
        if true {
            /**
            Циферблат
            */
            self.mainItem.image = nil
            self.mainItem.length = 45
            
            let date = NSDate(timeIntervalSince1970: pasmado.lostTime)
            let formatter = NSDateFormatter()
            formatter.dateFormat = "mm:ss"
            let text = formatter.stringFromDate(date)
            
            let attributedText = NSAttributedString(string: text, attributes: [
                NSFontAttributeName: NSFont.systemFontOfSize(14),
                NSForegroundColorAttributeName: pasmado.color
                ])
            
            self.mainItem.attributedTitle = attributedText
        } else {
            if pasmado.lostTime <= 0 || pasmado.statusLength <= 0 {
                return
            }
            
            /**
            гарфик
            */
            self.mainItem.title = nil
            self.mainItem.length = 20
            
            let icon = TreyIcon(frame: NSRect(x: 0, y: 0, width: 20, height: 20), pasmado: pasmado)
            let image = NSImage(data: icon.dataWithPDFInsideRect(icon.bounds))
            self.mainItem.image = image
        }
    }

    
    func notifyUserForNewStatus(status: Status) {
        let notification = NSUserNotification()
        notification.title = "Помидорка сменила статус"
        notification.informativeText = "Новый статус: \"\(status.stringValue())\""
        notification.deliveryDate = NSDate()
        notification.soundName = NSUserNotificationDefaultSoundName
        
        let center = NSUserNotificationCenter.defaultUserNotificationCenter()
        center.scheduleNotification(notification)
    }
    
    //MARK: - Pasmado Delegate
    
    func pasmadoDidChange(pasmado: PasmadoModel) {
        self.statusItem.title = pasmado.status.stringValue()
        
        if self.lastStatus != pasmado.status && self.lastStatus != .Unknow {
            self.notifyUserForNewStatus(pasmado.status)
        }
        self.lastStatus = pasmado.status
        
        self.updateMainItemText(pasmado)
    }
    
    //MARK: - IBActions
    
    @IBAction func exit(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    
    @IBAction func synchronize(sender: AnyObject) {
        self.pasmado.synchronize()
    }
    
    
    @IBAction func showSettings(sender: AnyObject) {
        println("show settings")
    }
    
    //MARK: - menu delegate
    
    func menuWillOpen(menu: NSMenu) {

    }
    
    
    func menuDidClose(menu: NSMenu) {
        
    }
}
