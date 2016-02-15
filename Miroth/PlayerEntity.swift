//
//  PlayerEntity.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class PlayerEntity: Entity {
    
    var hitPoints: Int = 0
    var currentTarget: Entity? = nil
    
    convenience init() {
        self.init(texture: SpriteLoader.getSpriteTexture(SpriteLoader.Sprite.AdventurerMale))
        
        let animatedTexture1 = SpriteLoader.getSpriteTexture("adventurer_m_front", spriteSize: CGSizeMake(16.0, 16.0), column: 1, row: 3, spacing: 2, margin: 1)
        let animatedTexture2 = SpriteLoader.getSpriteTexture("adventurer_m_front", spriteSize: CGSizeMake(16.0, 16.0), column: 2, row: 3, spacing: 2, margin: 1)
        let animatedTexture3 = SpriteLoader.getSpriteTexture("adventurer_m_front", spriteSize: CGSizeMake(16.0, 16.0), column: 3, row: 3, spacing: 2, margin: 1)

        
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures([self.texture!, animatedTexture1!, animatedTexture2!, animatedTexture3!], timePerFrame: 0.25)))
    }
}