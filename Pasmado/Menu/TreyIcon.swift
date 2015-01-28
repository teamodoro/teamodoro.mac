//
//  TreyIcon.swift
//  Teamodoro
//
//  Created by Коньшин Алексей on 22.01.15.
//  Copyright (c) 2015 Коньшин Алексей. All rights reserved.
//

import Cocoa

class TreyIcon: NSView {
    let pasmado: PasmadoModel
    
    init(frame: NSRect, pasmado: PasmadoModel) {
        self.pasmado = pasmado
        
        super.init(frame: frame)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func drawRect(dirtyRect: NSRect) {
        
        let gc = NSGraphicsContext.currentContext()!
        
        // Save the current graphics context settings
        gc.saveGraphicsState();

        let center = NSPoint(
            x: dirtyRect.origin.x + dirtyRect.size.width / 2,
            y: dirtyRect.origin.y + dirtyRect.size.height / 2
        )
        let radius = min(center.x, center.y) - 2
        let progress = CGFloat(pasmado.lostTime / pasmado.statusLength)
        let backgroundColor = NSColor.trayReverseColor()
        
        let progressPath = NSBezierPath()
        progressPath.appendBezierPathWithArcWithCenter(
            center,
            radius: radius - 2,
            startAngle: 90,
            endAngle: 90 + 360 * progress
        )
        progressPath.lineToPoint(center)
        
        let backgroundPath = NSBezierPath()
        backgroundPath.appendBezierPathWithArcWithCenter(
            center,
            radius: radius,
            startAngle: 0,
            endAngle: 360
        )
        
//        backgroundPath.appendBezierPath(progressPath.bezierPathByReversingPath)
        
        backgroundColor.setFill()
        backgroundPath.fill()
        backgroundPath.closePath()
        
        if self.pasmado.status == .Running {
            backgroundColor.reverseColor().setFill()
        } else {
            self.pasmado.color.setFill()
        }
        
        progressPath.fill()
        progressPath.closePath()
        
        gc.restoreGraphicsState()
    }
    
}
