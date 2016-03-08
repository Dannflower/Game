//
//  PlayerEntity.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class PlayerEntity: Entity {
    
    private let timePerFrame: NSTimeInterval = 0.1
    private let timePerAttackFrame: NSTimeInterval = 0.025
    
    private var attackNode: SKSpriteNode! = nil
    private var damageNode: DamageInteractor! = nil
    
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
            
            // Create the attack node using any texture
            self.attackNode = SKSpriteNode(texture: downAttackAnimation[1])
            self.attackNode.anchorPoint = CGPointMake(0.0, 0.0)
            
            self.damageNode = DamageInteractor(size: self.attackNode.size)
            self.damageNode.anchorPoint = CGPointMake(0.0, 0.0)
            self.damageNode.zPosition = self.zPosition
            
            self.damageNode.owner = self
            self.damageNode.damage = 1
            
            switch self.facing {
            
            case Facing.Down:
            
                self.attackNode.position = CGPointMake(0.0, -self.size.height)
                self.damageNode.position = CGPointMake(self.position.x, self.position.y - self.size.height)
                self.attackNode.runAction(SKAction.animateWithTextures(downAttackAnimation, timePerFrame: timePerAttackFrame), completion: onAttackComplete)
            
            case Facing.Up:
                
                self.attackNode.position = CGPointMake(0.0, self.size.height)
                self.damageNode.position = CGPointMake(self.position.x, self.position.y + self.size.height)
                self.attackNode.runAction(SKAction.animateWithTextures(upAttackAnimation, timePerFrame: timePerAttackFrame), completion: onAttackComplete)
                
            case Facing.Left:
                
                self.attackNode.position = CGPointMake(-self.size.width, 0.0)
                self.damageNode.position = CGPointMake(self.position.x - self.size.width, self.position.y)
                self.attackNode.runAction(SKAction.animateWithTextures(leftAttackAnimation, timePerFrame: timePerAttackFrame), completion: onAttackComplete)
                
            case Facing.Right:
                
                self.attackNode.position = CGPointMake(self.size.width, 0.0)
                self.damageNode.position = CGPointMake(self.position.x + self.size.width, self.position.y)
                self.attackNode.runAction(SKAction.animateWithTextures(rightAttackAnimation, timePerFrame: timePerAttackFrame), completion: onAttackComplete)
            }
            
            self.isAttacking = true
            
            self.addChild(self.attackNode)
            self.layer.addActor(self.damageNode, x: self.damageNode.position.x, y: self.damageNode.position.y)
        }
    }
    
    private func onAttackComplete() {
        
        self.attackNode.removeFromParent()
        self.damageNode.removeFromParent()
        self.layer.removeActor(self.damageNode)
        self.isAttacking = false
        
    }
    
    override func move(currentTime: CFTimeInterval) {
        
        super.move(currentTime)
        
        // If the character is not moving, stop the animations
        if !self.isEntityMoving() {
            
            self.removeActionForKey(self.MOVE_ANIMATION)
            
            // TODO: This should also reset the character's texture to standing
        }
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