//
//  Entity.swift
//  Miroth
//
//  Created by Eric Ostrowski on 9/26/15.
//  Copyright (c) 2015 Eric Ostrowski. All rights reserved.
//

import SpriteKit

class Entity: Actor {
    
    private let SPEED: CGFloat = 50.0
    
    private var destination: CGPoint? = nil
    private var lastUpdateTime: CFTimeInterval? = nil
    private var distanceToMove: CGFloat = 0.0
    private var isMoving: Bool = false
    private var lastValidPosition: CGPoint? = nil
    
    func isEntityMoving() -> Bool {
        
        return self.isMoving
    }
    
    func setDestination(destinationPosition: CGPoint) {
        
        self.destination = destinationPosition
        
        let destinationVector = CGVector(dx: destinationPosition.x, dy: destinationPosition.y)
        let currentPosition = CGVector(dx: self.position.x, dy: self.position.y)
        
        self.distanceToMove = VectorMath.distance(currentPosition, end: destinationVector)
    }
    
    func move(currentTime: CFTimeInterval) {
        print(self.position)
        self.lastValidPosition = self.position
        
        if destination != nil {
            
            if distanceToMove > 0.0 {
                
                let currentPosition = CGVector(dx: self.position.x, dy: self.position.y)
                let destinationPosition = CGVector(dx: destination!.x, dy: destination!.y)
                let directionVector = VectorMath.computeDirectionToMoveVector(currentPosition, destinationPosition: destinationPosition)
                let compensatedSpeed = SPEED * CGFloat(currentTime - lastUpdateTime!)
                
                distanceToMove -= VectorMath.length(directionVector) * compensatedSpeed
                
                if distanceToMove > 0.0 {
                    
                    self.position = VectorMath.computeNewPosition(currentPosition, directionVector: directionVector, speed: compensatedSpeed)
                    self.isMoving = true
                    
                } else {
                    
                    self.position = destination!
                    distanceToMove = 0.0
                    self.isMoving = false
                }
            }
        }
        
        lastUpdateTime = currentTime
    }
    
    
    override func collidedWith(actors: [Actor]) {

        for actor in actors {
            if actor.getType() == "Blocked" {
            
                self.position = self.lastValidPosition!
            }
        }
    }
    
    override func isStationaryActor() -> Bool {
        
        return false
    }
}