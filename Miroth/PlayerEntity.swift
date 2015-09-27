//
//  PlayerEntity.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class PlayerEntity: Entity {
    
    var hitPoints: Int?
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        hitPoints = 0
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func printHitPoints() {
        print("Player(\(self.name!) hit points: \(self.hitPoints!)", terminator: "")
    }
    
    
}