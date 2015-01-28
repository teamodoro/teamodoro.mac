//
//  PasmadoModel.swift
//  Pasmado
//
//  Created by Коньшин Алексей on 21.01.15.
//  Copyright (c) 2015 Коньшин Алексей. All rights reserved.
//

import Cocoa

typealias ResponseDictionary = [String: AnyObject]

enum Status: String {
    case Running = "running"
    case ShortBreak = "shortBreak"
    case LongBreak = "longBreak"
    case Unknow = "unknow"
    
    func stringValue() -> String {
        switch self {
        case .Running:
            return "Running"
        case .ShortBreak:
            return "Short Break"
        case .LongBreak:
            return "Long Break"
        case .Unknow:
            return "Unknow"
        }
    }
}

protocol PasmadoDelegate: class {
    func pasmadoDidChange(pasmado: PasmadoModel)
}


class PasmadoModel: NSObject {
    weak var delegate: PasmadoDelegate?
    private var _status: Status = .Unknow
    var status: Status {
        get {
            return _status
        }
        set {
            _status = newValue
            self.sendToDelegate()
        }
    }
    
    var statusLength: NSTimeInterval = 0
    private var _lostTime: NSTimeInterval = 0
    var lostTime: NSTimeInterval {
        get {
            return _lostTime
        }
        set {
            _lostTime = newValue
            self.sendToDelegate()
        }
    }
    private var _color = NSColor.blackColor()
    var color: NSColor {
        get {
            return _color
        }
        set {
            _color = newValue
            self.sendToDelegate()
        }
    }
    
    var timer: NSTimer?
    
    //MARK: - Actions
    
    func synchronize() {
        let manager = AFHTTPRequestOperationManager()
        let url = "http://teamodoro.sdfgh153.ru/api/current"
        
        manager.GET(
            url,
            parameters: nil,
            success: {oepration, object in
                println(object)
                if let dict = object as? ResponseDictionary {
                    self.parseResponse(dict)
                    
                    if self.lostTime > 0 {
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
            },
            failure: {error in
                println("Ошибка синхронизации помидорки")
            }
        )
    }
    
    
    func parseResponse(response: ResponseDictionary) {
        if let stateString = (response["state"] as? ResponseDictionary)?["name"] as? String {
            let status = Status(rawValue: stateString)
            if status != nil {
                self.status = status!
            }
        }
        
        let curTime: AnyObject? = response["currentTime"]
        if let curTime = curTime as? Int {
            let curTimeInterval = NSTimeInterval(curTime)
            
            if let curStateOptionDict = (response["options"] as? ResponseDictionary)?[self.status.rawValue] as? ResponseDictionary {
                
                if let duration = curStateOptionDict["duration"] as? Int {
                    let durationInterval = NSTimeInterval(duration)
                    self.lostTime = durationInterval - curTimeInterval
                    self.statusLength = durationInterval
                }
                if let colorString = curStateOptionDict["color"] as? String {
                    switch colorString {
                    case "white":
                        self.color = NSColor.whiteColor()
                    case "green":
                        self.color = NSColor.greenColor()
                    case "yellow":
                        self.color = NSColor.yellowColor()
                    default:
                        self.color = NSColor.blackColor()
                        break
                    }
                }
            }
        }
    }
    
    
    func sendToDelegate() {
        if let del = self.delegate {
            del.pasmadoDidChange(self)
        }
    }
    
    //MARK: - Timer
    
    func tick() {
        self.lostTime--
        
        if self.lostTime <= 0 {
            self.invalidateTimer()
            self.synchronize()
        }
    }
    
    
    func invalidateTimer() {
        println("invalidateTimer")
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
    }
}
