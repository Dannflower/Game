//
//  Entity.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Entity: SKSpriteNode {
    
    let SPEED: CGFloat = 50.0
    
    var destination: CGPoint? = nil
    var lastUpdateTime: CFTimeInterval? = nil
    var distanceToMove: CGFloat = 0.0
    
    override init(texture: SKTexture?, color: NSColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(sprite: SpriteLoader.Sprite) {
        self.init(texture: SpriteLoader.getSpriteTexture(sprite))
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func setDestination(destinationPosition: CGPoint) {
        
        self.destination = destinationPosition
        
        let destinationVector = CGVector(dx: destinationPosition.x, dy: destinationPosition.y)
        let currentPosition = CGVector(dx: self.position.x, dy: self.position.y)
        
        self.distanceToMove = VectorMath.distance(currentPosition, end: destinationVector)
    }
    
    func move(currentTime: CFTimeInterval) {
        
        if destination != nil {
            
            if distanceToMove > 0.0 {
                
                let currentPosition = CGVector(dx: self.position.x, dy: self.position.y)
                let destinationPosition = CGVector(dx: destination!.x, dy: destination!.y)
                let directionVector = VectorMath.computeDirectionToMoveVector(currentPosition, destinationPosition: destinationPosition)
                let compensatedSpeed = SPEED * CGFloat(currentTime - lastUpdateTime!)
                
                distanceToMove -= VectorMath.length(directionVector) * compensatedSpeed
                
                if distanceToMove > 0.0 {
                    
                    self.position = VectorMath.computeNewPosition(currentPosition, directionVector: directionVector, speed: compensatedSpeed)
                    
                } else {
                    
                    self.position = destination!
                    distanceToMove = 0.0
                }
            }
        }
        
        lastUpdateTime = currentTime
    }
}