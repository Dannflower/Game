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
        self.init(texture: SpriteLoader.getSpriteTexture(SpriteLoader.Sprite.HumanKnight))
        
        let animatedTexture = SpriteLoader.getSpriteTexture("Player1", column: 1, row: 11)
        
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures([self.texture!, animatedTexture!], timePerFrame: 0.5)))
    }
    
    func setTarget(currentTarget: Entity) {
        
        // Remove the highlight from the previous target if there is one
        self.currentTarget?.disableHighlight()
        
        // Enable the highlight on the new target
        self.currentTarget = currentTarget
        currentTarget.enableHighlight()
        
    }
}