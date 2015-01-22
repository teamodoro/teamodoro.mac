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

        let circlePath = NSBezierPath()
        circlePath.appendBezierPathWithArcWithCenter(
            center,
            radius: radius,
            startAngle: 0,
            endAngle: 360
        )
        
        NSColor.blackColor().setFill()
        circlePath.fill()
        circlePath.closePath()
        
        let arcPath = NSBezierPath()
        let progress = CGFloat(pasmado.lostTime / pasmado.statusLength)
        arcPath.appendBezierPathWithArcWithCenter(
            center, 
            radius: radius - 2,
            startAngle: 90,
            endAngle: 90 + 360 * progress
        )
        arcPath.lineToPoint(center)
        
        self.pasmado.color.setFill()
        
//        arcPath.lineWidth = 2
//        arcPath.stroke()
        arcPath.fill()
        
        arcPath.closePath()
        
        // Restore the context to what it was before we messed with it
        gc.restoreGraphicsState()
    }
    
}
