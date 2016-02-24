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
    
    private let timePerFrame: NSTimeInterval = 0.1
    
    private let MOVE_ANIMATION = "moveAnimation"
    
    let downAnimation = [   SpriteLoader.getSpriteTexture("adventurer_m_front", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 3, spacing: 2, margin: 1)!,
                            SpriteLoader.getSpriteTexture("adventurer_m_front", spriteSize: CGSizeMake(16.0, 16.0), column: 1, row: 3, spacing: 2, margin: 1)!,
                            SpriteLoader.getSpriteTexture("adventurer_m_front", spriteSize: CGSizeMake(16.0, 16.0), column: 2, row: 3, spacing: 2, margin: 1)!,
                            SpriteLoader.getSpriteTexture("adventurer_m_front", spriteSize: CGSizeMake(16.0, 16.0), column: 3, row: 3, spacing: 2, margin: 1)!]
    
    let upAnimation = [     SpriteLoader.getSpriteTexture("full_01", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 0, spacing: 0, margin: 0)!,
                            SpriteLoader.getSpriteTexture("full_01", spriteSize: CGSizeMake(16.0, 16.0), column: 1, row: 0, spacing: 0, margin: 0)!,
                            SpriteLoader.getSpriteTexture("full_01", spriteSize: CGSizeMake(16.0, 16.0), column: 2, row: 0, spacing: 0, margin: 0)!,
                            SpriteLoader.getSpriteTexture("full_01", spriteSize: CGSizeMake(16.0, 16.0), column: 3, row: 0, spacing: 0, margin: 0)!]
    
    let leftAnimation = [   SpriteLoader.getSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 3, spacing: 0, margin: 0)!,
                            SpriteLoader.getSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 1, row: 3, spacing: 0, margin: 0)!,
                            SpriteLoader.getSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 2, row: 3, spacing: 0, margin: 0)!,
                            SpriteLoader.getSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 3, row: 3, spacing: 0, margin: 0)!]
    
    let rightAnimation = [  SpriteLoader.getMirroredSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 3, spacing: 0, margin: 0)!,
                            SpriteLoader.getMirroredSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 1, row: 3, spacing: 0, margin: 0)!,
                            SpriteLoader.getMirroredSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 2, row: 3, spacing: 0, margin: 0)!,
                            SpriteLoader.getMirroredSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 3, row: 3, spacing: 0, margin: 0)!]
    
    
    convenience init() {
        
        self.init(texture: SpriteLoader.getSpriteTexture(SpriteLoader.Sprite.AdventurerMale))
    }
    
    func attack() {
        
        
    }
    
    override func move(currentTime: CFTimeInterval) {
        
        super.move(currentTime)
        
        // If the character is not moving, stop the animations
        if !self.isEntityMoving() {
            
            self.removeActionForKey(self.MOVE_ANIMATION)
        }
    }
    
    override func setFacing(directionVector: CGVector) {
        
        super.setFacing(directionVector)
        
        if self.facing == Facing.Up && self.previousFacing != Facing.Up {
            
            self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(upAnimation, timePerFrame: self.timePerFrame)), withKey: self.MOVE_ANIMATION)
        
        } else if self.facing == Facing.Down && self.previousFacing != Facing.Down {
            
            self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(downAnimation, timePerFrame: self.timePerFrame)), withKey: self.MOVE_ANIMATION)
        
        } else if self.facing == Facing.Left && self.previousFacing != Facing.Left {
            
            self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(leftAnimation, timePerFrame: self.timePerFrame)), withKey: self.MOVE_ANIMATION)
        
        } else if self.facing == Facing.Right && self.previousFacing != Facing.Right {
            
            self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(rightAnimation, timePerFrame: self.timePerFrame)), withKey: self.MOVE_ANIMATION)
            
        }
    }
}