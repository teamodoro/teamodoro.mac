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
    
    var timer: NSTimer?
    var curTimeInterval: NSTimeInterval = 0
    
    var lastStatus = Status.Unknow
    
    override init() {
        super.init()
        
        self.pasmado.delegate = self
        self.pasmado.synchronize()
    }
    
    //MARK: - Actions
    
    func setupMenu() {
        self.menu.delegate = self
        
        self.mainItem.menu = self.menu
        self.mainItem.highlightMode = true
        self.mainItem.title = "Pasmado"
        
        self.pasmadoDidChange(self.pasmado)
    }
    
    
    func tick() {
        self.curTimeInterval--
        
        if self.curTimeInterval <= 0 {
            self.invalidateTimer()
            self.pasmado.synchronize()
        }
        
        self.updateMainItemText(self.pasmado)
    }
    
    
    func updateMainItemText(pasmado: PasmadoModel) {
        let date = NSDate(timeIntervalSince1970: self.curTimeInterval)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "mm:ss"
        let text = formatter.stringFromDate(date)
        
        let attributedText = NSAttributedString(string: text, attributes: [
            NSFontAttributeName: NSFont.systemFontOfSize(14),
            NSForegroundColorAttributeName: pasmado.color
            ])
        
        self.mainItem.attributedTitle = attributedText
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
    
    
    func invalidateTimer() {
        println("invalidateTimer")
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    //MARK: - Pasmado Delegate
    
    func pasmadoDidChange(pasmado: PasmadoModel) {
        self.curTimeInterval = pasmado.lostTime
        self.statusItem.title = pasmado.status.stringValue()
        
        if self.lastStatus != pasmado.status && self.lastStatus != .Unknow {
            self.notifyUserForNewStatus(pasmado.status)
        }
        self.lastStatus = pasmado.status
        
        self.updateMainItemText(pasmado)
        
        if self.curTimeInterval > 0 {
            self.invalidateTimer()
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(
                1,
                target: self,
                selector: "tick",
                userInfo: nil,
                repeats: true
            )
            let runLoop = NSRunLoop.mainRunLoop()
            runLoop.addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        }
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
}
