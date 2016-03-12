//
//  SlimeEntity.swift
//  Miroth
//
//  Created by Eric Ostrowski on 3/7/16.
//  Copyright © 2016 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class SlimeEntity: Entity {
    
    var hitPoints: Int = 14
    
    let timePerFrame: NSTimeInterval = 0.5
    
    let animation = [   SpriteLoader.getSpriteTexture("green slime", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 0, spacing: 0, margin: 0)!,
                        SpriteLoader.getSpriteTexture("green slime", spriteSize: CGSizeMake(16.0, 16.0), column: 1, row: 0, spacing: 0, margin: 0)!]
    
    
    convenience init() {
        
        self.init(texture: SpriteLoader.getSpriteTexture("green slime", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 0, spacing: 0, margin: 0))
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(animation, timePerFrame: timePerFrame)))
    }
    
    override func collidedWith(actors: [Actor]) {
        
        super.collidedWith(actors)
        
        for actor in actors {
            
            if actor is DamageInteractor {
                
                handleCollisionWithDamageInteractor(actor as! DamageInteractor)
            }
        }
    }
    
    /**

        Handles collision with DamageInteractors.
     
        - parameter damageInteractor: The DamageInteractor colliding with the Slime.

    */
    private func handleCollisionWithDamageInteractor(damageInteractor: DamageInteractor) {
        
        self.hitPoints = self.hitPoints - damageInteractor.damage
        print(hitPoints)
        // Check if the slime has died
        if self.hitPoints <= 0 {
            
            super.die()
            
            // TODO: See if the damage owner is the player, perhaps reward experience?
        }
    }
}
