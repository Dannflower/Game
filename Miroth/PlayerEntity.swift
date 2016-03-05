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
    private let timePerAttackFrame: NSTimeInterval = 0.1
    
    private var attackNode: SKSpriteNode! = nil
    
    private var isAttacking: Bool = false
    
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
    
    let rightAnimation = [  SpriteLoader.getXAxisMirroredSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 3, spacing: 0, margin: 0)!,
                            SpriteLoader.getXAxisMirroredSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 1, row: 3, spacing: 0, margin: 0)!,
                            SpriteLoader.getXAxisMirroredSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 2, row: 3, spacing: 0, margin: 0)!,
                            SpriteLoader.getXAxisMirroredSpriteTexture("adventurer_m_side", spriteSize: CGSizeMake(16.0, 16.0), column: 3, row: 3, spacing: 0, margin: 0)!]
    
    let downAttackAnimation = [ SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 12, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 13, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 14, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 15, row: 0, spacing: 0, margin: 0)!]
    
    let upAttackAnimation = [   SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 0, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 1, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 2, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 3, row: 0, spacing: 0, margin: 0)!]
    
    let leftAttackAnimation = [ SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 8, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 9, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 10, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 11, row: 0, spacing: 0, margin: 0)!]
    
    let rightAttackAnimation = [SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 4, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 5, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 6, row: 0, spacing: 0, margin: 0)!,
                                SpriteLoader.getSpriteTexture("sword_attack", spriteSize: CGSizeMake(16.0, 16.0), column: 7, row: 0, spacing: 0, margin: 0)!]
    
    
    convenience init() {
        
        self.init(texture: SpriteLoader.getSpriteTexture(SpriteLoader.Sprite.AdventurerMale))
    }
    
    func attack() {
        
        if !self.isAttacking {
        
            // The parent of the entity should always be the layer it occupies
            let layer = self.parent!
            
            // Create the attack node using any texture
            self.attackNode = SKSpriteNode(texture: downAttackAnimation[1])
            self.attackNode.anchorPoint = CGPointMake(0.0, 0.0)
            self.attackNode.zPosition = self.zPosition
            
            switch self.facing {
                
            case Facing.Down:
            
                self.attackNode.position = CGPointMake(self.position.x, self.position.y - self.attackNode.size.height)
                self.attackNode.runAction(SKAction.animateWithTextures(downAttackAnimation, timePerFrame: timePerAttackFrame), completion: onAttackComplete)
            
            case Facing.Up:
                
                self.attackNode.position = CGPointMake(self.position.x, self.position.y + self.attackNode.size.height)
                self.attackNode.runAction(SKAction.animateWithTextures(upAttackAnimation, timePerFrame: timePerAttackFrame), completion: onAttackComplete)
                
            case Facing.Left:
                
                self.attackNode.position = CGPointMake(self.position.x - self.attackNode.size.width, self.position.y)
                self.attackNode.runAction(SKAction.animateWithTextures(leftAttackAnimation, timePerFrame: timePerAttackFrame), completion: onAttackComplete)
                
            case Facing.Right:
                
                self.attackNode.position = CGPointMake(self.position.x + self.attackNode.size.width, self.position.y)
                self.attackNode.runAction(SKAction.animateWithTextures(rightAttackAnimation, timePerFrame: timePerAttackFrame), completion: onAttackComplete)
            }
            
            self.isAttacking = true
            
            layer.addChild(self.attackNode)
        }
    }
    
    private func onAttackComplete() {
        
        self.attackNode.removeFromParent()
        self.isAttacking = false
    }
    
    override func move(currentTime: CFTimeInterval) {
        
        super.move(currentTime)
        
        // If the character is not moving, stop the animations
        if !self.isEntityMoving() {
            
            self.removeActionForKey(self.MOVE_ANIMATION)
            
            // TODO: This should also reset the character's texture to standing
        }
        
        // TODO: The attack node should move with the player
    }
    
    override func setFacing(directionVector: CGVector) {
        
        super.setFacing(directionVector)
        
        if self.facing == Facing.Up && (!self.isEntityMoving() || self.previousFacing != Facing.Up) {
            
            self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(upAnimation, timePerFrame: self.timePerFrame)), withKey: self.MOVE_ANIMATION)
        
        } else if self.facing == Facing.Down && (!self.isEntityMoving() || self.previousFacing != Facing.Down) {
            
            self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(downAnimation, timePerFrame: self.timePerFrame)), withKey: self.MOVE_ANIMATION)
        
        } else if self.facing == Facing.Left && (!self.isEntityMoving() || self.previousFacing != Facing.Left) {
            
            self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(leftAnimation, timePerFrame: self.timePerFrame)), withKey: self.MOVE_ANIMATION)
        
        } else if self.facing == Facing.Right && (!self.isEntityMoving() || self.previousFacing != Facing.Right) {
            
            self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(rightAnimation, timePerFrame: self.timePerFrame)), withKey: self.MOVE_ANIMATION)
            
        }
    }
}